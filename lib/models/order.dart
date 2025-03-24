class Order {
  final String id;
  final String clientId;
  final String employeeId;
  final String address;
  final String description;
  final double price;
  final String status;

  Order({
    required this.id,
    required this.clientId,
    required this.employeeId,
    required this.address,
    required this.description,
    required this.price,
    required this.status,
  });

  // Конвертация объекта в Map для Firestore
  Map<String, dynamic> toMap() {
    return {
      'clientId': clientId,
      'employeeId': employeeId,
      'address': address,
      'description': description,
      'price': price,
      'status': status,
    };
  }

  // Создание объекта Order из документа Firestore
  factory Order.fromFirestore(String id, Map<String, dynamic> data) {
    return Order(
      id: id,
      clientId: data['clientId'] ?? '', // Преобразуем int в String
      employeeId: data['employeeId'] ?? '',
      address: data['address'] ?? '',
      description: data['description'] ?? '',
      price: (data['price'] as num?)?.toDouble() ?? 0.0, // Приводим int/num к double
      status: data['status'] ?? '',
    );
  }
}
