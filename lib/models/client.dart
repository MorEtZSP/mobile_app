import 'package:cloud_firestore/cloud_firestore.dart';

class Client {
  final String id;
  final String name;
  final String email;
  final String phone;

  Client({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
    };
  }

  factory Client.fromFirestore(String id, Map<String, dynamic> data) {
    return Client(
      id: id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      phone: data['phone'] ?? '',
    );
  }
}