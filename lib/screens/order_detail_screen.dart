import 'package:flutter/material.dart';
import '../models/order.dart';

class OrderDetailScreen extends StatelessWidget {
  // Конструктор с параметром 'order'
  final Order order;

  const OrderDetailScreen({Key? key, required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Order ID: ${order.id}'),
            Text('Client ID: ${order.clientId}'),
            Text('Employee ID: ${order.employeeId}'),
            Text('Address: ${order.address}'),
            Text('Description: ${order.description}'),
            Text('Price: \$${order.price}'),
            Text('Status: ${order.status}'),
          ],
        ),
      ),
    );
  }
}
