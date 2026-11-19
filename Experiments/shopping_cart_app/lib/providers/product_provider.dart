import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/product.dart';
import '../services/api_service.dart';

class ProductProvider extends ChangeNotifier 
{
  final ApiService _api = ApiService();

  List<Product> _products = [];
  bool _isLoading = false;
  String? _error;
  String _searchQuery = '';
  String _selectedCategory = 'all';

  List<Product> get products => _products;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get selectedCategory => _selectedCategory;

  List<String> get categories {
    final set = _products.map((p) => p.category).toSet().toList()..sort();
    return ['all', ...set];
  }

  List<Product> get filteredProducts 
  {
    return _products.where((p) {
      final matchesCategory =
          _selectedCategory == 'all' || p.category == _selectedCategory;
      final matchesSearch = p.title.toLowerCase().contains(_searchQuery);
      return matchesCategory && matchesSearch;
    }).toList();
  }

  Future<void> fetchProducts() async 
  {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try 
    {
      _products = await _api.fetchProducts();
    } 
    on TimeoutException 
    {
      _error = 'The request timed out. Check your connection and try again.';
    } 
    on http.ClientException 
    {
      _error = 'Could not reach the server. Check your internet connection.';
    } 
    on ApiException catch (e) 
    {
      _error = e.message;
    } 
    catch (_) 
    {
      _error = 'Something went wrong. Please try again.';
    }

    _isLoading = false;
    notifyListeners();
  }

  void setSearchQuery(String query) 
  {
    _searchQuery = query.trim().toLowerCase();
    notifyListeners();
  }

  void setCategory(String category) 
  {
    _selectedCategory = category;
    notifyListeners();
  }
}
