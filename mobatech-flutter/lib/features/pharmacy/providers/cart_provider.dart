import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/network/dio_client.dart';
import '../data/cart_repository.dart';
import '../models/cart.dart';

part 'cart_provider.g.dart';

@riverpod
CartRepository cartRepository(Ref ref) {
  return CartRepository(ref.watch(dioProvider));
}

@riverpod
class CartNotifier extends _$CartNotifier {
  @override
  FutureOr<Cart> build() async {
    return _fetchCart();
  }

  Future<Cart> _fetchCart() async {
    final repo = ref.read(cartRepositoryProvider);
    return repo.getCart();
  }

  Future<void> fetchCart() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchCart());
  }

  Future<void> addToCart(int medicineId, int quantity) async {
    try {
      final repo = ref.read(cartRepositoryProvider);
      await repo.addToCart(medicineId, quantity);
      await fetchCart();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateCartItem(int cartItemId, int quantity) async {
    try {
      final repo = ref.read(cartRepositoryProvider);
      await repo.updateCartItem(cartItemId, quantity);
      await fetchCart();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> removeFromCart(int cartItemId) async {
    try {
      final repo = ref.read(cartRepositoryProvider);
      await repo.removeFromCart(cartItemId);
      await fetchCart();
    } catch (e) {
      rethrow;
    }
  }
}
