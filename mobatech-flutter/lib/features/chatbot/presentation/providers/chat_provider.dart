import 'dart:convert';
import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/dio_client.dart';
import '../../data/chat_repository.dart';

part 'chat_messages_notifier.dart';
part 'chat_stream_processor.dart';

final chatRepositoryProvider = Provider((ref) {
  return ChatRepository(ref.watch(dioProvider));
});

final chatSessionsProvider = FutureProvider<List<dynamic>>((ref) async {
  final repo = ref.watch(chatRepositoryProvider);
  return await repo.getUserSessions();
});

class CurrentSessionId extends Notifier<int?> {
  @override
  int? build() => null;
  @override
  set state(int? val) => super.state = val;
}

final currentSessionIdProvider = NotifierProvider<CurrentSessionId, int?>(
  CurrentSessionId.new,
);

final chatMessagesProvider =
    NotifierProvider<ChatMessagesNotifier, List<Map<String, dynamic>>>(
      ChatMessagesNotifier.new,
    );

class IsChatHistoryLoading extends Notifier<bool> {
  @override
  bool build() => false;
  @override
  set state(bool val) => super.state = val;
}

final isChatHistoryLoadingProvider =
    NotifierProvider<IsChatHistoryLoading, bool>(IsChatHistoryLoading.new);
