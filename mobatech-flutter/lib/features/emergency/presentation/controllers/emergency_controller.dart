import 'dart:async';
import 'package:mobatech_app/core/constants/strings/core_strings.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

import '../providers/emergency_provider.dart';
import 'emergency_state.dart';
import 'location_helper.dart';
import 'emergency_ws_mixin.dart';

class EmergencyController extends AutoDisposeNotifier<EmergencyScreenState>
    with EmergencyWsMixin {
  @override
  EmergencyScreenState build() {
    ref.onDispose(() {
      disposeWs();
    });
    return EmergencyScreenState();
  }

  Future<void> detectLocation() async {
    state = state.copyWith(isLocating: true, locationError: null);
    try {
      final locError = await LocationHelper.checkLocationServices();
      if (locError != null) {
        state = state.copyWith(locationError: locError, isLocating: false);
        return;
      }
      final pos = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 15),
        ),
      );
      state = state.copyWith(
        userLat: pos.latitude,
        userLng: pos.longitude,
        isLocating: false,
      );
    } catch (e) {
      state = state.copyWith(
        locationError: '${CoreStrings.locationDetectFailed}${e.toString()}',
        isLocating: false,
      );
    }
  }

  Future<void> submitRequest(
    String name,
    String condition,
    String phone,
  ) async {
    if (state.userLat == null || state.userLng == null) {
      throw Exception(CoreStrings.locationNotDetected);
    }
    state = state.copyWith(
      isLoading: true,
      status: EmergencyStatus.dispatching,
    );

    try {
      final response = await ref
          .read(emergencyRepositoryProvider)
          .submitRequest({
            "patient_name": name,
            "condition": condition,
            "phone_number": phone,
            "latitude": state.userLat,
            "longitude": state.userLng,
          });
      connectWebSocket(
        (response['id'] ?? response['emergency_id'] ?? '1').toString(),
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, status: EmergencyStatus.form);
      rethrow;
    }
  }
}

final emergencyControllerProvider =
    AutoDisposeNotifierProvider<EmergencyController, EmergencyScreenState>(
      () => EmergencyController(),
    );
