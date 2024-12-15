// database_service.dart
import '../models/client.dart';
import '../models/employee.dart';
import '../models/order.dart';

class DatabaseService {
  // Simulate fetching clients from a database
  List<Client> fetchClients() {
    return Client.exampleClients;
  }

  // Simulate fetching employees from a database
  List<Employee> fetchEmployees() {
    return Employee.exampleEmployees;
  }

  // Simulate fetching orders from a database
  List<Order> fetchOrders() {
    return Order.exampleOrders;
  }

  // Simulate saving an order to the database
  void saveOrder(Order order) {
    print('Order saved: ${order.description}');
  }
}
