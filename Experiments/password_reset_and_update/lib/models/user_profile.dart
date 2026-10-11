class UserProfile {
  final String uid;
  final String name;
  final String email;
  final String phone;

  UserProfile({
    required this.uid,
    required this.name,
    required this.email,
    required this.phone,
  });

  // object -> map, used when saving to Firestore
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'phone': phone,
    };
  }

  // map -> object, used when reading from Firestore
  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
    );
  }
}