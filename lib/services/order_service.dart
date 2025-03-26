import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../models/order.dart' as local;
import 'database_helper.dart';

class OrderService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<bool> _isOnline() async {
    if (kIsWeb) return true;
    final connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  Future<List<local.Order>> getOrders() async {
    if (await _isOnline()) {
      QuerySnapshot snapshot = await _db.collection('orders').get();
      final orders = snapshot.docs.map((doc) => local.Order.fromFirestore(doc.id, doc.data() as Map<String, dynamic>)).toList();
      if (!kIsWeb) {
        for (var order in orders) {
          await _dbHelper.insertOrder(order, isSynced: true);
        }
      }
      return orders;
    } else {
      return await _dbHelper.getOrders();
    }
  }

  Future<void> addOrder(local.Order order) async {
    if (!(await _isOnline())) {
      throw Exception('Cannot add order while offline');
    }
    await _db.collection('orders').doc(order.id).set(order.toMap());
    if (!kIsWeb) await _dbHelper.insertOrder(order, isSynced: true);
  }

  Future<void> updateOrderStatus(String orderId, String newStatus) async {
    if (!(await _isOnline())) {
      throw Exception('Cannot update order while offline');
    }
    await _db.collection('orders').doc(orderId).update({'status': newStatus});
    if (!kIsWeb) {
      final order = (await getOrders()).firstWhere((o) => o.id == orderId);
      order.status = newStatus;
      await _dbHelper.insertOrder(order, isSynced: true);
    }
  }

  Future<void> deleteOrder(String orderId) async {
    if (!(await _isOnline())) {
      throw Exception('Cannot delete order while offline');
    }
    await _db.collection('orders').doc(orderId).delete();
    if (!kIsWeb) {
      final db = await _dbHelper.database;
      await db!.delete('orders', where: 'id = ?', whereArgs: [orderId]);
    }
  }

  Future<void> syncOrders() async {
    if (kIsWeb || !(await _isOnline())) return;
    final unsyncedOrders = await _dbHelper.getUnsyncedOrders();
    for (var order in unsyncedOrders) {
      await _db.collection('orders').doc(order.id).set(order.toMap());
      await _dbHelper.markAsSynced(order.id);
    }
  }
}