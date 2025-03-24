import 'package:cloud_firestore/cloud_firestore.dart';

class Employee {
  final String id;
  final String name;
  final String position;
  final String phone;

  Employee({
    required this.id,
    required this.name,
    required this.position,
    required this.phone,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'position': position,
      'phone': phone,
    };
  }

  factory Employee.fromFirestore(String id, Map<String, dynamic> data) {
    return Employee(
      id: id,
      name: data['name'] ?? '',
      position: data['position'] ?? '',
      phone: data['phone'] ?? '',
    );
  }
}