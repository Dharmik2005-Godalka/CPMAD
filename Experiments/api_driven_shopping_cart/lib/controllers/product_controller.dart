import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ProductController extends GetxController {
  var products = <Product>[].obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var searchText = ''.obs;
  var selectedCategory = 'All'.obs;

  @override
  void onInit() {
    fetchProducts();
    super.onInit();
  }

  Future<void> fetchProducts() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final response =
          await http.get(Uri.parse('https://fakestoreapi.com/products'));
      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        products.value = data.map((e) => Product.fromJson(e)).toList();
      } else {
        errorMessage.value = 'Server error: ${response.statusCode}';
      }
    } catch (e) {
      errorMessage.value = 'Could not load products. Check your internet.';
    }
    isLoading.value = false;
  }

  List<String> get categories =>
      ['All', ...products.map((p) => p.category).toSet()];

  List<Product> get filteredProducts {
    return products.where((p) {
      final matchesCategory = selectedCategory.value == 'All' ||
          p.category == selectedCategory.value;
      final matchesSearch =
          p.title.toLowerCase().contains(searchText.value.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();
  }
}
