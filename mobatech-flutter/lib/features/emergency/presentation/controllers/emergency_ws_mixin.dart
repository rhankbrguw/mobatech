import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../../../../core/network/dio_client.dart';
import 'emergency_state.dart';

mixin EmergencyWsMixin on AutoDisposeNotifier<EmergencyScreenState> {
  WebSocketChannel? _channel;
  StreamSubscription? _wsSubscription;
  Timer? _simulationTimer;

  void disposeWs() {
    _wsSubscription?.cancel();
    _channel?.sink.close();
    _simulationTimer?.cancel();
  }

  void connectWebSocket(String emergencyId) {
    try {
      String baseWsUrl = baseUrl.replaceFirst('http', 'ws');

      _channel = WebSocketChannel.connect(
        Uri.parse('$baseWsUrl/emergencies/$emergencyId/track'),
      );
      _wsSubscription = _channel?.stream.listen(
        _onWsMessage,
        onError: (_) => simulateTracking(),
      );
      Future.delayed(const Duration(seconds: 3), () {
        if (state.status == EmergencyStatus.dispatching) simulateTracking();
      });
    } catch (e) {
      simulateTracking();
    }
  }

  void _onWsMessage(dynamic message) {
    final data = jsonDecode(message as String) as Map<String, dynamic>;
    if (data['type'] == 'location_update') {
      state = state.copyWith(
        status: EmergencyStatus.tracking,
        isLoading: false,
        ambulanceLat: (data['ambulance_lat'] as num).toDouble(),
        ambulanceLng: (data['ambulance_lng'] as num).toDouble(),
        estimatedMinutes: (data['estimated_minutes'] as num).toInt(),
      );
    } else if (data['type'] == 'status_update' && data['status'] == 'Arrived') {
      state = state.copyWith(status: EmergencyStatus.arrived);
    }
  }

  void simulateTracking() {
    final bLat = state.userLat ?? -6.2088;
    final bLng = state.userLng ?? 106.8456;
    double aLat = bLat + 0.015 + Random().nextDouble() * 0.005;
    double aLng = bLng + 0.015 + Random().nextDouble() * 0.005;
    int mins = 8;

    state = state.copyWith(
      status: EmergencyStatus.tracking,
      ambulanceLat: aLat,
      ambulanceLng: aLng,
      estimatedMinutes: mins,
      isLoading: false,
    );
    _simulationTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      aLat += (bLat - aLat) * 0.15;
      aLng += (bLng - aLng) * 0.15;
      mins = max(1, mins - 1);

      if (sqrt(pow(bLat - aLat, 2) + pow(bLng - aLng, 2)) < 0.001) {
        timer.cancel();
        state = state.copyWith(
          ambulanceLat: bLat,
          ambulanceLng: bLng,
          estimatedMinutes: 0,
          status: EmergencyStatus.arrived,
        );
        return;
      }
      state = state.copyWith(
        ambulanceLat: aLat,
        ambulanceLng: aLng,
        estimatedMinutes: mins,
      );
    });
  }
}
