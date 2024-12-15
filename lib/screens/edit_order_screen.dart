import 'package:flutter/material.dart';
import '../models/order.dart'; // Импортируем модель Order

class EditOrderScreen extends StatefulWidget {
  final Order order;

  const EditOrderScreen({Key? key, required this.order}) : super(key: key);

  @override
  _EditOrderScreenState createState() => _EditOrderScreenState();
}

class _EditOrderScreenState extends State<EditOrderScreen> {
  late TextEditingController clientIdController;
  late TextEditingController employeeIdController;
  late TextEditingController addressController;
  late TextEditingController descriptionController;
  late TextEditingController priceController;
  String? selectedStatus;

  @override
  void initState() {
    super.initState();
    // Инициализируем контроллеры с текущими значениями заказа
    clientIdController = TextEditingController(text: widget.order.clientId);
    employeeIdController = TextEditingController(text: widget.order.employeeId);
    addressController = TextEditingController(text: widget.order.address);
    descriptionController = TextEditingController(text: widget.order.description);
    priceController = TextEditingController(text: widget.order.price.toString());
    selectedStatus = widget.order.status; // Инициализируем статус
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Order'),
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
            // Добавляем выпадающий список для выбора статуса
            DropdownButton<String>(
              value: selectedStatus,
              onChanged: (String? newValue) {
                setState(() {
                  selectedStatus = newValue;
                });
              },
              items: <String>['pending', 'in_progress', 'completed', 'cancelled']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              hint: const Text('Select Status'),
            ),
            ElevatedButton(
              onPressed: () {
                // Обновляем данные заказа
                final updatedOrder = Order(
                  id: widget.order.id,
                  clientId: clientIdController.text,
                  employeeId: employeeIdController.text,
                  address: addressController.text,
                  description: descriptionController.text,
                  price: double.parse(priceController.text),
                  status: selectedStatus ?? widget.order.status, // Статус может быть null
                );
                // Возвращаем обновленный заказ
                Navigator.pop(context, updatedOrder);
              },
              child: const Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
