import 'medicine.dart';

class CartItem {
  final int id;
  final Medicine medicine;
  final int quantity;
  final double totalPrice;

  CartItem({
    required this.id,
    required this.medicine,
    required this.quantity,
    required this.totalPrice,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    final med = Medicine.fromJson(json['medicine'] as Map<String, dynamic>);
    final qty = json['quantity'] as int;
    return CartItem(
      id: json['ID'] ?? json['id'] as int, // Support GORM ID formatting
      medicine: med,
      quantity: qty,
      totalPrice: json['total_price'] != null
          ? (json['total_price'] as num).toDouble()
          : med.price * qty,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'medicine': medicine.toJson(),
      'quantity': quantity,
      'total_price': totalPrice,
    };
  }
}

class Cart {
  final List<CartItem> items;
  final double totalPrice;

  Cart({required this.items, required this.totalPrice});

  factory Cart.fromJson(Map<String, dynamic> json) {
    var itemsList = json['items'] as List? ?? [];
    List<CartItem> cartItems = itemsList
        .map((i) => CartItem.fromJson(i))
        .toList();

    double computedTotal = 0.0;
    for (var item in cartItems) {
      computedTotal += item.totalPrice;
    }

    return Cart(
      items: cartItems,
      totalPrice: json['total_price'] != null
          ? (json['total_price'] as num).toDouble()
          : computedTotal,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'items': items.map((i) => i.toJson()).toList(),
      'total_price': totalPrice,
    };
  }
}
