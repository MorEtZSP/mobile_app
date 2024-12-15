class Order {
  final int id; // Сделано int
  final String clientId;
  final String employeeId;
  final String address;
  final String description;
  final double price;
  final String status; // "pending", "in_progress", "completed"

  Order({
    required this.id,
    required this.clientId,
    required this.employeeId,
    required this.address,
    required this.description,
    required this.price,
    required this.status,
  });

  // Example static data for demonstration
  static List<Order> exampleOrders = [
    Order(
      id: 1, // Исправлено на int
      clientId: '1',
      employeeId: '2',
      address: '123 Main Street',
      description: 'Deep cleaning of the apartment',
      price: 150.0,
      status: 'pending',
    ),
    Order(
      id: 2, // Исправлено на int
      clientId: '2',
      employeeId: '1',
      address: '456 Elm Street',
      description: 'Office carpet cleaning',
      price: 200.0,
      status: 'in_progress',
    ),
  ];
}
