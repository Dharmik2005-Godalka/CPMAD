import 'dart:ui' show PointerDeviceKind;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/cart_provider.dart';
import 'providers/product_provider.dart';
import 'screens/product_list_screen.dart';
import 'providers/wishlist_provider.dart';

void main() 
{
  runApp(
    MultiProvider(
      providers: 
      [
        ChangeNotifierProvider(
          create: (_) => ProductProvider()..fetchProducts(),
        ),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => WishlistProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class AppScrollBehavior extends MaterialScrollBehavior 
{
  @override
  Set<PointerDeviceKind> get dragDevices => 
  {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}

class MyApp extends StatelessWidget 
{
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) 
  {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Shopping Cart',
      scrollBehavior: AppScrollBehavior(),
      theme: ThemeData(colorSchemeSeed: Colors.green, useMaterial3: true),
      home: const ProductListScreen(),
    );
  }
}
