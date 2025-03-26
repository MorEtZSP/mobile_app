class Order {
  String id; // Removed final to allow mutability
  String clientId;
  String employeeId;
  String address;
  String description;
  double price;
  String status;

  Order({
    required this.id,
    required this.clientId,
    required this.employeeId,
    required this.address,
    required this.description,
    required this.price,
    required this.status,
  });

  // Convert object to Map for Firestore/SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id, // Added for SQLite compatibility
      'clientId': clientId,
      'employeeId': employeeId,
      'address': address,
      'description': description,
      'price': price,
      'status': status,
    };
  }

  // Create Order from Firestore document
  factory Order.fromFirestore(String id, Map<String, dynamic> data) {
    return Order(
      id: id,
      clientId: data['clientId'] ?? '',
      employeeId: data['employeeId'] ?? '',
      address: data['address'] ?? '',
      description: data['description'] ?? '',
      price: (data['price'] as num?)?.toDouble() ?? 0.0,
      status: data['status'] ?? '',
    );
  }

  // Create Order from SQLite map
  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      id: map['id'] ?? '',
      clientId: map['clientId'] ?? '',
      employeeId: map['employeeId'] ?? '',
      address: map['address'] ?? '',
      description: map['description'] ?? '',
      price: (map['price'] as num?)?.toDouble() ?? 0.0,
      status: map['status'] ?? '',
    );
  }
}