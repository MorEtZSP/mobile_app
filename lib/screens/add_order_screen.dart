import 'package:flutter/material.dart';
import '../models/client.dart';
import '../models/employee.dart';
import '../models/order.dart';
import '../services/database_service.dart';

class AddOrderScreen extends StatefulWidget {
  @override
  _AddOrderScreenState createState() => _AddOrderScreenState();
}

class _AddOrderScreenState extends State<AddOrderScreen> {
  final _descriptionController = TextEditingController();
  final _addressController = TextEditingController();
  final _priceController = TextEditingController();
  final DatabaseService _databaseService = DatabaseService();
  String? _selectedClient;
  String? _selectedEmployee;
  String _selectedStatus = 'Новый';

  final List<String> _statuses = ['Новый', 'В процессе', 'Завершен', 'Отменен', 'Ожидает'];

  void _addOrder() {
    if (_descriptionController.text.isEmpty ||
        _addressController.text.isEmpty ||
        _priceController.text.isEmpty ||
        _selectedClient == null ||
        _selectedEmployee == null) {
      return;
    }

    final newOrder = Order(
      id: '',
      clientId: _selectedClient!,
      employeeId: _selectedEmployee!,
      address: _addressController.text,
      description: _descriptionController.text,
      price: double.parse(_priceController.text),
      status: _selectedStatus,
    );

    _databaseService.addOrder(newOrder);
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Добавить заказ')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Описание'),
            ),
            TextField(
              controller: _addressController,
              decoration: const InputDecoration(labelText: 'Адрес'),
            ),
            TextField(
              controller: _priceController,
              decoration: const InputDecoration(labelText: 'Цена'),
              keyboardType: TextInputType.number,
            ),
            FutureBuilder<List<Client>>(
              future: _databaseService.fetchClients(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }
                if (snapshot.hasError) {
                  return Text('Ошибка загрузки клиентов: ${snapshot.error}');
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text('Нет доступных клиентов');
                }

                final clients = snapshot.data!;
                return DropdownButtonFormField(
                  decoration: const InputDecoration(labelText: 'Клиент'),
                  value: _selectedClient,
                  items: clients
                      .map((client) => DropdownMenuItem(
                    value: client.id,
                    child: Text(client.name),
                  ))
                      .toList(),
                  onChanged: (value) => setState(() => _selectedClient = value),
                );
              },
            ),
            FutureBuilder<List<Employee>>(
              future: _databaseService.fetchEmployees(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }
                if (snapshot.hasError) {
                  return Text('Ошибка загрузки сотрудников: ${snapshot.error}');
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text('Нет доступных сотрудников');
                }

                final employees = snapshot.data!;
                return DropdownButtonFormField(
                  decoration: const InputDecoration(labelText: 'Сотрудник'),
                  value: _selectedEmployee,
                  items: employees
                      .map((employee) => DropdownMenuItem(
                    value: employee.id,
                    child: Text(employee.name),
                  ))
                      .toList(),
                  onChanged: (value) => setState(() => _selectedEmployee = value),
                );
              },
            ),
            DropdownButtonFormField(
              decoration: const InputDecoration(labelText: 'Статус'),
              value: _selectedStatus,
              items: _statuses
                  .map((status) => DropdownMenuItem(
                value: status,
                child: Text(status),
              ))
                  .toList(),
              onChanged: (value) => setState(() => _selectedStatus = value!),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addOrder,
        label: const Text('Сохранить заказ'),
        icon: const Icon(Icons.save),
      ),
    );
  }
}
