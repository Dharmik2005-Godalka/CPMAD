import 'package:flutter/material.dart';
import '../models/product.dart';

class WishlistProvider extends ChangeNotifier 
{
  // key = prod id, value = the wishlisted prod
  final Map<int, Product> _items = {};

  List<Product> get items => _items.values.toList();
  int get count => _items.length;

  bool isWishlisted(Product product) => _items.containsKey(product.id);

  void toggle(Product product) 
  {
    if (_items.containsKey(product.id)) 
    {
      _items.remove(product.id);
    } 
    else {
      _items[product.id] = product;
    }
    notifyListeners();
  }
}
