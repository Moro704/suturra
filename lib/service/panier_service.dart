import 'package:flutter/material.dart';
import 'package:sutura/Principal/model_item.dart';

class PanierService extends ChangeNotifier {
  List<CardModel> _cartItems = [];
  List<CardModel> get cartItems => _cartItems;
  Future<void> addToCart(CardModel item) async {
  final index = _cartItems.indexWhere((val) => val.id == item.id);

  if (index == -1) {
    _cartItems.add(item);
  } else {
    _cartItems[index] = _cartItems[index].copyWith(
      quantity: _cartItems[index].quantity + item.quantity,
    );
  }

  notifyListeners();
}

  Future<void> UpdateToCart(CardModel item) async {
    final Index = _cartItems.indexWhere((val) => val.id == item.id);
    if (Index != -1) {
      _cartItems[Index] = _cartItems[Index].copyWith(quantity: item.quantity);
    }

    notifyListeners();
  }

  Future<void> removeFromCart(CardModel item) async {
    _cartItems.removeWhere((val) => val.id == item.id);
    notifyListeners();
  }

  double get totalPrice {
    return _cartItems.fold(0.0, (Total, item) {
      return Total + (item.price * item.quantity);
    });
  }
  void clearCart() {
    cartItems.clear();
    notifyListeners();
  }                  
  Map<String, List<CardModel>> groupByFournisseur() {
    final result = <String, List<CardModel>>{};
    for (var item in _cartItems) {
      result.putIfAbsent(item.fournisseurId, () => []).add(item);
    }
    return result;
  }
}
