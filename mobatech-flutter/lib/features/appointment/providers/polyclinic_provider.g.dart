// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'polyclinic_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(Polyclinics)
final polyclinicsProvider = PolyclinicsProvider._();

final class PolyclinicsProvider
    extends $AsyncNotifierProvider<Polyclinics, List<Polyclinic>> {
  PolyclinicsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'polyclinicsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$polyclinicsHash();

  @$internal
  @override
  Polyclinics create() => Polyclinics();
}

String _$polyclinicsHash() => r'921a5c8a5ab7c964a7b0974f7e7059bffb4dbdad';

abstract class _$Polyclinics extends $AsyncNotifier<List<Polyclinic>> {
  FutureOr<List<Polyclinic>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<List<Polyclinic>>, List<Polyclinic>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Polyclinic>>, List<Polyclinic>>,
              AsyncValue<List<Polyclinic>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
