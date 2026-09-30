import 'dart:async';
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../data/models/medical_result.dart';
import '../data/models/reminder.dart';
import '../data/repositories/patient_support_repository.dart';
import '../../../../core/network/dio_client.dart';

final patientSupportRepositoryProvider = Provider<PatientSupportRepository>((
  ref,
) {
  final dio = ref.read(dioProvider);
  return PatientSupportRepository(dio);
});

final medicalResultsProvider = FutureProvider<List<MedicalResult>>((ref) async {
  final repo = ref.read(patientSupportRepositoryProvider);
  return repo.getMedicalResults();
});

final remindersProvider =
    AsyncNotifierProvider<RemindersNotifier, List<Reminder>>(
      RemindersNotifier.new,
    );

class RemindersNotifier extends AsyncNotifier<List<Reminder>> {
  PatientSupportRepository get _repository =>
      ref.read(patientSupportRepositoryProvider);

  StreamSubscription? _wsSub;
  WebSocketChannel? _channel;

  @override
  Future<List<Reminder>> build() async {
    _initWebSocket();
    ref.onDispose(() {
      _wsSub?.cancel();
      _channel?.sink.close();
    });
    return _repository.getReminders();
  }

  void _initWebSocket() async {
    try {
      const storage = FlutterSecureStorage();
      final token = await storage.read(key: 'jwt_token');
      if (token == null || token.isEmpty) return;

      final wsBase = baseUrl.replaceFirst('http', 'ws');
      final uri = Uri.parse('${wsBase}ws/notifications?token=$token');
      _channel = WebSocketChannel.connect(uri);
      _wsSub = _channel?.stream.listen((event) {
        try {
          final decoded = jsonDecode(event as String);
          if (decoded != null && decoded is Map<String, dynamic>) {
            final notif = Reminder.fromBackendJson(decoded);
            state = state.whenData((reminders) {
              if (reminders.any((r) => r.id == notif.id)) return reminders;
              return [notif, ...reminders];
            });
            ref.invalidate(unreadReminderCountProvider);
          }
        } catch (_) {}
      }, onError: (_) {});
    } catch (_) {}
  }

  int _currentPage = 1;
  bool _hasMore = true;
  bool get hasMore => _hasMore;

  Future<void> loadReminders() async {
    try {
      _currentPage = 1;
      _hasMore = true;
      state = const AsyncValue.loading();
      final reminders = await _repository.getReminders(page: 1);
      state = AsyncValue.data(reminders);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> loadMore() async {
    if (!_hasMore || state.isLoading) return;
    try {
      final nextPage = _currentPage + 1;
      final newItems = await _repository.getReminders(page: nextPage);
      if (newItems.isEmpty) {
        _hasMore = false;
        return;
      }
      _currentPage = nextPage;
      state = state.whenData((reminders) {
        final existingIds = reminders.map((r) => r.id).toSet();
        final unique = newItems.where((r) => !existingIds.contains(r.id)).toList();
        if (unique.isEmpty) _hasMore = false;
        return [...reminders, ...unique];
      });
    } catch (_) {}
  }

  Future<void> markAsRead(String id) async {
    try {
      await _repository.markReminderAsRead(id);
      state = state.whenData(
        (reminders) => _updateReminderStatus(reminders, id),
      );
    } catch (e) {
      // Ignore error for now
    }
  }

  List<Reminder> _updateReminderStatus(List<Reminder> reminders, String id) {
    return reminders.map((r) {
      if (r.id == id) {
        return Reminder(
          id: r.id,
          title: r.title,
          message: r.message,
          dateTime: r.dateTime,
          type: r.type,
          isRead: true,
        );
      }
      return r;
    }).toList();
  }
}

final unreadReminderCountProvider = FutureProvider<int>((ref) async {
  final repo = ref.read(patientSupportRepositoryProvider);
  return repo.getUnreadReminderCount();
});
