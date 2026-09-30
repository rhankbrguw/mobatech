// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'emergency_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(EmergencyController)
final emergencyControllerProvider = EmergencyControllerProvider._();

final class EmergencyControllerProvider
    extends $NotifierProvider<EmergencyController, EmergencyScreenState> {
  EmergencyControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'emergencyControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$emergencyControllerHash();

  @$internal
  @override
  EmergencyController create() => EmergencyController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(EmergencyScreenState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<EmergencyScreenState>(value),
    );
  }
}

String _$emergencyControllerHash() =>
    r'f44e17d3aa257b9e7fd1819d4ad273ea3baa43c3';

abstract class _$EmergencyController extends $Notifier<EmergencyScreenState> {
  EmergencyScreenState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<EmergencyScreenState, EmergencyScreenState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<EmergencyScreenState, EmergencyScreenState>,
              EmergencyScreenState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
