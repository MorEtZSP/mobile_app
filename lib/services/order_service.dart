import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/order.dart' as local;

class OrderService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Получение всех заказов
  Future<List<local.Order>> getOrders() async {
    QuerySnapshot snapshot = await _db.collection('orders').get();
    return snapshot.docs.map((doc) => local.Order.fromFirestore(doc.id, doc.data() as Map<String, dynamic>)).toList();
  }

  // Добавление нового заказа
  Future<void> addOrder(local.Order order) async {
    await _db.collection('orders').add(order.toMap());
  }

  // Обновление статуса заказа
  Future<void> updateOrderStatus(String orderId, String newStatus) async {
    await _db.collection('orders').doc(orderId).update({'status': newStatus});
  }

  // Удаление заказа
  Future<void> deleteOrder(String orderId) async {
    await _db.collection('orders').doc(orderId).delete();
  }
}
