// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medicine_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(Medicines)
final medicinesProvider = MedicinesFamily._();

final class MedicinesProvider
    extends $AsyncNotifierProvider<Medicines, List<Medicine>> {
  MedicinesProvider._({
    required MedicinesFamily super.from,
    required MedicineFilter super.argument,
  }) : super(
         retry: null,
         name: r'medicinesProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$medicinesHash();

  @override
  String toString() {
    return r'medicinesProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  Medicines create() => Medicines();

  @override
  bool operator ==(Object other) {
    return other is MedicinesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$medicinesHash() => r'412298d85790a0b62c25e408062d0bc081ea2d7e';

final class MedicinesFamily extends $Family
    with
        $ClassFamilyOverride<
          Medicines,
          AsyncValue<List<Medicine>>,
          List<Medicine>,
          FutureOr<List<Medicine>>,
          MedicineFilter
        > {
  MedicinesFamily._()
    : super(
        retry: null,
        name: r'medicinesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  MedicinesProvider call(MedicineFilter arg) =>
      MedicinesProvider._(argument: arg, from: this);

  @override
  String toString() => r'medicinesProvider';
}

abstract class _$Medicines extends $AsyncNotifier<List<Medicine>> {
  late final _$args = ref.$arg as MedicineFilter;
  MedicineFilter get arg => _$args;

  FutureOr<List<Medicine>> build(MedicineFilter arg);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<Medicine>>, List<Medicine>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Medicine>>, List<Medicine>>,
              AsyncValue<List<Medicine>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}
