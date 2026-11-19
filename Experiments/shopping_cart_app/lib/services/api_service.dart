import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ApiException implements Exception 
{
  final String message;
  ApiException(this.message);

  @override
  String toString() => message;
}

class ApiService 
{
  static const String _baseUrl = 'https://dummyjson.com';

  Future<List<Product>> fetchProducts() async 
  {
    final response = await http
        .get(Uri.parse('$_baseUrl/products?limit=0')) 
        .timeout(const Duration(seconds: 15));

    if (response.statusCode != 200) {
      throw ApiException(
        'Server error (${response.statusCode}). Please try again.',
      );
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final list = data['products'] as List<dynamic>;

    return list
        .map((item) => Product.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}
