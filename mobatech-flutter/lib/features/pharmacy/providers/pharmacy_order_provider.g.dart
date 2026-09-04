// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pharmacy_order_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(Orders)
final ordersProvider = OrdersProvider._();

final class OrdersProvider
    extends $AsyncNotifierProvider<Orders, List<PharmacyOrder>> {
  OrdersProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'ordersProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$ordersHash();

  @$internal
  @override
  Orders create() => Orders();
}

String _$ordersHash() => r'35987cbf54e53da4e036d14ea711dc44c94f797f';

abstract class _$Orders extends $AsyncNotifier<List<PharmacyOrder>> {
  FutureOr<List<PharmacyOrder>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<List<PharmacyOrder>>, List<PharmacyOrder>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<PharmacyOrder>>, List<PharmacyOrder>>,
              AsyncValue<List<PharmacyOrder>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
