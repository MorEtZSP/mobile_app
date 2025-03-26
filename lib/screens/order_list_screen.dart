import 'package:flutter/material.dart';
import '../services/order_service.dart';
import '../models/order.dart';
import 'add_order_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class OrderListScreen extends StatefulWidget {
  @override
  _OrderListScreenState createState() => _OrderListScreenState();
}

class _OrderListScreenState extends State<OrderListScreen> {
  final OrderService _orderService = OrderService();
  final AuthService _authService = AuthService();
  bool _isOnline = true;

  @override
  void initState() {
    super.initState();
    _checkConnectivity();
    _orderService.syncOrders(); // Sync when screen loads if online
  }

  Future<void> _checkConnectivity() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    setState(() {
      _isOnline = connectivityResult != ConnectivityResult.none;
    });
    // Listen for connectivity changes
    Connectivity().onConnectivityChanged.listen((result) {
      setState(() {
        _isOnline = result != ConnectivityResult.none;
      });
      if (_isOnline) _orderService.syncOrders();
    });
  }

  void _openAddOrderScreen() async {
    if (!_isOnline) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Cannot add order while offline')),
      );
      return;
    }
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddOrderScreen()),
    );
    if (result == true) setState(() {});
  }

  void _logout() async {
    await _authService.logout();
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Заказы${_isOnline ? '' : ' (Offline)'}'),
        automaticallyImplyLeading: false,
      ),
      body: FutureBuilder<List<Order>>(
        future: _orderService.getOrders(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Ошибка: ${snapshot.error}'));
          }
          final orders = snapshot.data ?? [];
          if (orders.isEmpty) {
            return const Center(child: Text('Нет заказов'));
          }
          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              return ListTile(
                title: Text(order.description),
                subtitle: Text('Статус: ${order.status}'),
                onTap: _isOnline
                    ? () => Navigator.pushNamed(context, '/orderDetail', arguments: order)
                    : null, // Disable navigation when offline
              );
            },
          );
        },
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (_isOnline)
            FloatingActionButton.extended(
              onPressed: _openAddOrderScreen,
              label: const Text('Добавить заказ'),
              icon: const Icon(Icons.add),
            ),
          const SizedBox(height: 16),
          FloatingActionButton(
            onPressed: _logout,
            child: const Icon(Icons.exit_to_app),
            backgroundColor: Colors.red,
          ),
        ],
      ),
    );
  }
}