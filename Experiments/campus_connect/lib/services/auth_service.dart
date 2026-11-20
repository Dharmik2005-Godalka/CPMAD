import 'package:firebase_auth/firebase_auth.dart';

class AuthService 
{
  FirebaseAuth get _auth => FirebaseAuth.instance;

  User? get currentUser => _auth.currentUser;

  Future<void> login(String email, String password) async 
  {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> register(String name, String email, String password) async 
  {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    await credential.user?.updateDisplayName(name);
  }

  Future<void> logout() async 
  {
    await _auth.signOut();
  }
}
