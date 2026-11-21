import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseServices 
{
  static readUsers() 
  {
    CollectionReference users = FirebaseFirestore.instance.collection('user');

    return users.snapshots();
  }

  static Future<void> deleteUser(String id) async 
  {
    log(id);
    CollectionReference users = FirebaseFirestore.instance.collection('user');
    await users.doc(id).delete();
  }

  static Future<void> addUser(String name, String city, int salary) async 
  {
    CollectionReference users = FirebaseFirestore.instance.collection('user');
    await users.add({'name': name, 'city': city, 'salary': salary});
  }

  static Future<void> updateUser
  (
    String id,
    String name,
    String city,
    int salary,
  ) 
  async 
  {
    CollectionReference users = FirebaseFirestore.instance.collection('user');
    await users.doc(id).update({'name': name, 'city': city, 'salary': salary});
  }
}
