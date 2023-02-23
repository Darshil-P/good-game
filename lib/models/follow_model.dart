import 'package:cloud_firestore/cloud_firestore.dart';

class Follow {
  String username;
  DocumentReference user;
  Follow({required this.username, required this.user});

  factory Follow.fromMap(Map<String, dynamic> map) {
    return Follow(
      username: map['username'],
      user: map['user'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      "user": user,
    };
  }
}
