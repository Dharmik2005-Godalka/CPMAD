import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'registration_screen.dart';

class LoginScreen extends StatefulWidget 
{
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> 
{
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() 
  {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() 
  {
    final username = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) 
    {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter both username and password'),
        ),
      );
      return;
    }

    Navigator.pushReplacementNamed(
      context,
      '/dashboard',
      arguments: {'username': username},
    );
  }

  @override
  Widget build(BuildContext context) 
  {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _handleLogin,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('Login'),
            ),
            const SizedBox(height: 16),
            RichText(
              text: TextSpan(
                text: 'New User? ',
                style: const TextStyle(color: Colors.black),
                children: [
                  TextSpan(
                    text: 'Register here',
                    style: const TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.pushNamed(context, '/register');
                      },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
