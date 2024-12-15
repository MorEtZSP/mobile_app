// client.dart
class Client {
  final int id;
  final String name;
  final String email;
  final String phone;

  Client({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
  });

  // Example static data for demonstration
  static List<Client> exampleClients = [
    Client(
      id: 1,
      name: 'John Doe',
      email: 'john.doe@example.com',
      phone: '+1234567890',
    ),
    Client(
      id: 2,
      name: 'Jane Smith',
      email: 'jane.smith@example.com',
      phone: '+0987654321',
    ),
  ];
}
