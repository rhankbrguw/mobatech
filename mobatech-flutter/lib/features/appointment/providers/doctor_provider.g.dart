// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'doctor_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(DoctorSort)
final doctorSortProvider = DoctorSortProvider._();

final class DoctorSortProvider
    extends $NotifierProvider<DoctorSort, DoctorSortOption> {
  DoctorSortProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'doctorSortProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$doctorSortHash();

  @$internal
  @override
  DoctorSort create() => DoctorSort();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DoctorSortOption value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DoctorSortOption>(value),
    );
  }
}

String _$doctorSortHash() => r'28a438a3903afe646bbcaf1145827b78d6e53698';

abstract class _$DoctorSort extends $Notifier<DoctorSortOption> {
  DoctorSortOption build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<DoctorSortOption, DoctorSortOption>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<DoctorSortOption, DoctorSortOption>,
              DoctorSortOption,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(Doctors)
final doctorsProvider = DoctorsProvider._();

final class DoctorsProvider
    extends $AsyncNotifierProvider<Doctors, List<Doctor>> {
  DoctorsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'doctorsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$doctorsHash();

  @$internal
  @override
  Doctors create() => Doctors();
}

String _$doctorsHash() => r'3332dc2e2e3405cdfe5d30f658d0da03b616d948';

abstract class _$Doctors extends $AsyncNotifier<List<Doctor>> {
  FutureOr<List<Doctor>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<Doctor>>, List<Doctor>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Doctor>>, List<Doctor>>,
              AsyncValue<List<Doctor>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
