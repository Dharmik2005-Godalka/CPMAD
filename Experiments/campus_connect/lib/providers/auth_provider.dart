import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier 
{
  final AuthService _service = AuthService();
  bool _isLoading = false;

  bool get isLoading => _isLoading;
  User? get user => _service.currentUser;
  bool get isLoggedIn => user != null;
  String get displayName => user?.displayName ?? user?.email ?? 'Student';
  String get email => user?.email ?? '';

  Future<String?> login(String email, String password) 
  {
    return _run(() => _service.login(email, password));
  }

  Future<String?> register(String name, String email, String password) 
  {
    return _run(() => _service.register(name, email, password));
  }

  Future<void> logout() async 
  {
    await _service.logout();
    notifyListeners();
  }

  Future<String?> _run(Future<void> Function() action) async 
  {
    _isLoading = true;
    notifyListeners();

    String? error;
    try {
      await action();
    } on FirebaseAuthException catch (e) 
    {
      error = _friendlyMessage(e.code);
    } catch (_) {
      error = 'Something went wrong. Please try again.';
    }

    _isLoading = false;
    notifyListeners();
    return error;
  }

  String _friendlyMessage(String code) 
  {
    switch (code) 
    {
      case 'invalid-email':
        return 'That email address is not valid.';
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return 'Incorrect email or password.';
      case 'email-already-in-use':
        return 'An account already exists for this email.';
      case 'weak-password':
        return 'Password is too weak. Use at least 6 characters.';
      case 'network-request-failed':
        return 'No internet connection. Please try again.';
      case 'too-many-requests':
        return 'Too many attempts. Try again later.';
      default:
        return 'Authentication failed. Please try again.';
    }
  }
}
