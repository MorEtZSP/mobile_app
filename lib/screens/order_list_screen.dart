import 'package:flutter/material.dart';
import '../services/order_service.dart';
import '../models/order.dart';
import 'add_order_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart'; // Импортируем сервис для работы с авторизацией

class OrderListScreen extends StatefulWidget {
  @override
  _OrderListScreenState createState() => _OrderListScreenState();
}

class _OrderListScreenState extends State<OrderListScreen> {
  final OrderService _orderService = OrderService();
  final AuthService _authService = AuthService(); // Создаем экземпляр AuthService

  void _openAddOrderScreen() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddOrderScreen()),
    );

    if (result == true) {
      setState(() {});
    }
  }

  // Функция для выхода из аккаунта
  void _logout() async {
    await _authService.logout(); // Вызываем метод logout из AuthService
    Navigator.pushReplacementNamed(context, '/login'); // Перенаправляем на экран авторизации
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Заказы'),
        automaticallyImplyLeading: false, // Убираем кнопку "Назад"
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
                onTap: () {
                  Navigator.pushNamed(context, '/orderDetail', arguments: order);
                },
              );
            },
          );
        },
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Кнопка добавления заказа
          FloatingActionButton.extended(
            onPressed: _openAddOrderScreen,
            label: const Text('Добавить заказ'),
            icon: const Icon(Icons.add),
          ),
          const SizedBox(height: 16),
          // Кнопка выхода
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
