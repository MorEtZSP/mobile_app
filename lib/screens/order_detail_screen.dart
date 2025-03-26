import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../models/order.dart';
import '../models/client.dart';
import '../models/employee.dart';

class OrderDetailScreen extends StatefulWidget {
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
  _OrderDetailScreenState createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  bool _isOnline = true;

  @override
  void initState() {
    super.initState();
    _checkConnectivity();
  }

  Future<void> _checkConnectivity() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    setState(() {
      _isOnline = connectivityResult != ConnectivityResult.none;
    });
    Connectivity().onConnectivityChanged.listen((result) {
      setState(() {
        _isOnline = result != ConnectivityResult.none;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Детали заказа${_isOnline ? '' : ' (Offline)'}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: _isOnline
                ? () {
              Navigator.pushNamed(
                context,
                '/edit_order',
                arguments: widget.order,
              );
            }
                : null, // Disable editing when offline
            tooltip: _isOnline ? 'Редактировать' : 'Редактирование недоступно оффлайн',
          ),
        ],
      ),
      body: FutureBuilder(
        future: Future.wait([widget.clientFuture, widget.employeeFuture]),
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
                Text('Номер заказа: ${widget.order.id}'),
                Text('Клиент: ${client.name}'),
                Text('Сотрудник: ${employee.name}'),
                Text('Адрес: ${widget.order.address}'),
                Text('Описание: ${widget.order.description}'),
                Text('Цена: ₽${widget.order.price}'),
                Text('Статус: ${widget.order.status}'),
              ],
            ),
          );
        },
      ),
    );
  }
}