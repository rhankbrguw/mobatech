// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prescription_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(Prescriptions)
final prescriptionsProvider = PrescriptionsProvider._();

final class PrescriptionsProvider
    extends $AsyncNotifierProvider<Prescriptions, List<Prescription>> {
  PrescriptionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'prescriptionsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$prescriptionsHash();

  @$internal
  @override
  Prescriptions create() => Prescriptions();
}

String _$prescriptionsHash() => r'd6e5f14233b9c247f9319c87a66dfa793901cb86';

abstract class _$Prescriptions extends $AsyncNotifier<List<Prescription>> {
  FutureOr<List<Prescription>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<List<Prescription>>, List<Prescription>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Prescription>>, List<Prescription>>,
              AsyncValue<List<Prescription>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
