import 'package:flutter/material.dart';
import '../models/order.dart';

class AddOrderScreen extends StatelessWidget {
  final TextEditingController clientIdController = TextEditingController();
  final TextEditingController employeeIdController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Order'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: clientIdController,
              decoration: const InputDecoration(labelText: 'Client ID'),
            ),
            TextField(
              controller: employeeIdController,
              decoration: const InputDecoration(labelText: 'Employee ID'),
            ),
            TextField(
              controller: addressController,
              decoration: const InputDecoration(labelText: 'Address'),
            ),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            TextField(
              controller: priceController,
              decoration: const InputDecoration(labelText: 'Price'),
              keyboardType: TextInputType.number,
            ),
            ElevatedButton(
              onPressed: () {
                final newOrder = Order(
                  id: DateTime.now().millisecondsSinceEpoch, // Генерация уникального id
                  clientId: clientIdController.text,
                  employeeId: employeeIdController.text,
                  address: addressController.text,
                  description: descriptionController.text,
                  price: double.parse(priceController.text),
                  status: 'pending', // Статус по умолчанию
                );
                // Возвращаем новый заказ на экран списка заказов
                Navigator.pop(context, newOrder);
              },
              child: const Text('Add Order'),
            ),
          ],
        ),
      ),
    );
  }
}
