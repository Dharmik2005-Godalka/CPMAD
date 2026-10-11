import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  final String currentRoute;

  const AppDrawer({super.key, required this.currentRoute});

  void goTo(BuildContext context, String route) {
    final navigator = Navigator.of(context);
    navigator.pop();
    if (route != currentRoute) {
      navigator.pushReplacementNamed(route);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.indigo),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                'Shopping App',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            selected: currentRoute == '/',
            onTap: () => goTo(context, '/'),
          ),
          ListTile(
            leading: const Icon(Icons.shopping_bag),
            title: const Text('Products'),
            selected: currentRoute == '/products',
            onTap: () => goTo(context, '/products'),
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Profile'),
            selected: currentRoute == '/profile',
            onTap: () => goTo(context, '/profile'),
          ),
        ],
      ),
    );
  }
}