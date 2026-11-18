import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controllers/cart_controller.dart';
import 'controllers/product_controller.dart';
import 'screens/product_list_screen.dart';

void main() {
  Get.put(ProductController());
  Get.put(CartController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Shopping Cart',
      theme: ThemeData(colorSchemeSeed: Colors.lightBlue, useMaterial3: true),
      home: const ProductListScreen(),
    );
  }
}
