import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/client.dart';
import '../models/employee.dart';
import '../models/order.dart' as app_models;

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Получение списка клиентов
  Future<List<Client>> fetchClients() async {
    final snapshot = await _db.collection('clients').get();
    return snapshot.docs.map((doc) => Client.fromFirestore(doc.id, doc.data())).toList();
  }

  // Получение списка сотрудников
  Future<List<Employee>> fetchEmployees() async {
    final snapshot = await _db.collection('employees').get();
    return snapshot.docs.map((doc) => Employee.fromFirestore(doc.id, doc.data())).toList();
  }

  // Получение списка заказов
  Future<List<app_models.Order>> fetchOrders() async {
    final snapshot = await _db.collection('orders').get();
    return snapshot.docs.map((doc) => app_models.Order.fromFirestore(doc.id, doc.data())).toList();
  }

  // Обновление заказа
  Future<void> updateOrder(app_models.Order order) async {
    await _db.collection('orders').doc(order.id).update(order.toMap());
  }

  // Добавление клиента
  Future<void> addClient(Client client) async {
    await _db.collection('clients').add(client.toMap());
  }

  // Добавление сотрудника
  Future<void> addEmployee(Employee employee) async {
    await _db.collection('employees').add(employee.toMap());
  }

  // Добавление заказа
  Future<void> addOrder(app_models.Order order) async {
    await _db.collection('orders').add(order.toMap());
  }

  // Получение клиента по ID
  Future<Client> getClientById(String clientId) async {
    final clientDoc = await _db.collection('clients').doc(clientId).get();
    if (clientDoc.exists) {
      return Client.fromFirestore(clientId, clientDoc.data()!);
    }
    throw Exception('Client not found');
  }

  // Получение сотрудника по ID
  Future<Employee> getEmployeeById(String employeeId) async {
    final employeeDoc = await _db.collection('employees').doc(employeeId).get();
    if (employeeDoc.exists) {
      return Employee.fromFirestore(employeeId, employeeDoc.data()!);
    }
    throw Exception('Employee not found');
  }
}
