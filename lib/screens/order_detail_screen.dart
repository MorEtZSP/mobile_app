import 'package:flutter/material.dart';
import '../models/order.dart';
import '../models/client.dart';
import '../models/employee.dart';

class OrderDetailScreen extends StatelessWidget {
  final Order order;
  final Future<Client> clientFuture;
  final Future<Employee> employeeFuture;

  const OrderDetailScreen({
    Key? key,
    required this.order,
    required this.clientFuture,
    required this.employeeFuture,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Детали заказа'),
        actions: [
          // Добавляем кнопку редактирования в AppBar
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // Переход на экран редактирования с передачей текущего заказа
              Navigator.pushNamed(
                context,
                '/edit_order',
                arguments: order,
              );
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: Future.wait([clientFuture, employeeFuture]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Ошибка: ${snapshot.error}'));
          }

          final client = snapshot.data![0] as Client;
          final employee = snapshot.data![1] as Employee;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Номер заказа: ${order.id}'),
                Text('Клиент: ${client.name}'),
                Text('Сотрудник: ${employee.name}'),
                Text('Адрес: ${order.address}'),
                Text('Описание: ${order.description}'),
                Text('Цена: ₽${order.price}'),
                Text('Статус: ${order.status}'),
              ],
            ),
          );
        },
      ),
    );
  }
}
