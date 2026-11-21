import 'package:flutter/material.dart';
import 'package:ecommerce_app/screens/splash_screen.dart';
import 'package:ecommerce_app/screens/login_screen.dart';
import 'package:ecommerce_app/screens/registration_screen.dart';
import 'package:ecommerce_app/screens/dashboard_screen.dart';

void main()
{
  runApp(const MyApp());
}

class MyApp extends StatelessWidget
{
  const MyApp({super.key});

  @override
  Widget build(BuildContext context)
  {
    return MaterialApp(
      title: 'E-commerce App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),

      // routes...
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => LoginScreen(),
        '/register': (context) => const RegistrationScreen(),
      },

      onGenerateRoute: (settings)
      {
        if (settings.name == '/dashboard') {
          final args = settings.arguments as Map<String, String>;

          return MaterialPageRoute(
            builder: (context) => DashboardScreen(username: args['username']!),
          );
        }

        return null;
      },
    );
  }
}
