import 'package:flutter/material.dart';
import '../models/cart_item.dart';
import '../models/product.dart';

class CartProvider extends ChangeNotifier 
{
  static const double taxRate = 0.05;

  final Map<int, CartItem> _items = {};

  List<CartItem> get items => _items.values.toList();
  bool get isEmpty => _items.isEmpty;

  int get totalQuantity =>
      _items.values.fold(0, (sum, item) => sum + item.quantity);

  double get subtotal =>
      _items.values.fold(0.0, (sum, item) => sum + item.subtotal);

  double get tax => subtotal * taxRate;

  double get total => subtotal + tax;

  int quantityOf(Product product) => _items[product.id]?.quantity ?? 0;

  void addProduct(Product product) {
    if (_items.containsKey(product.id)) 
    {
      _items[product.id]!.quantity++;
    } 
    else 
    {
      _items[product.id] = CartItem(product: product);
    }
    notifyListeners();
  }

  void decreaseQuantity(Product product) 
  {
    final item = _items[product.id];
    if (item == null) return;

    if (item.quantity > 1) 
    {
      item.quantity--;
    } 
    else 
    {
      _items.remove(product.id);
    }
    notifyListeners();
  }

  void removeProduct(Product product) 
  {
    _items.remove(product.id);
    notifyListeners();
  }

  void clear() 
  {
    _items.clear();
    notifyListeners();
  }
}
