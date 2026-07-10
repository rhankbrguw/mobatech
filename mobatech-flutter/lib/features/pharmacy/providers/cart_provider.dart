import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/dio_client.dart';
import '../data/cart_repository.dart';
import '../models/cart.dart';

final cartRepositoryProvider = Provider<CartRepository>((ref) {
  return CartRepository(ref.watch(dioProvider));
});

class CartNotifier extends StateNotifier<AsyncValue<Cart>> {
  final CartRepository repository;

  CartNotifier(this.repository) : super(const AsyncValue.loading()) {
    fetchCart();
  }

  Future<void> fetchCart() async {
    try {
      state = const AsyncValue.loading();
      final cart = await repository.getCart();
      state = AsyncValue.data(cart);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> addToCart(int medicineId, int quantity) async {
    try {
      await repository.addToCart(medicineId, quantity);
      await fetchCart();
    } catch (e) {
      throw Exception('Failed to add to cart: $e');
    }
  }

  Future<void> updateCartItem(int cartItemId, int quantity) async {
    try {
      await repository.updateCartItem(cartItemId, quantity);
      await fetchCart();
    } catch (e) {
      throw Exception('Failed to update cart: $e');
    }
  }

  Future<void> removeFromCart(int cartItemId) async {
    try {
      await repository.removeFromCart(cartItemId);
      await fetchCart();
    } catch (e) {
      throw Exception('Failed to remove from cart: $e');
    }
  }
}

final cartProvider = StateNotifierProvider<CartNotifier, AsyncValue<Cart>>((
  ref,
) {
  final repo = ref.watch(cartRepositoryProvider);
  return CartNotifier(repo);
});
