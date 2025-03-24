import 'package:flutter/material.dart';
import '../models/order.dart';
import '../models/client.dart';
import '../models/employee.dart';
import '../services/database_service.dart';

class EditOrderScreen extends StatefulWidget {
  final Order order;

  const EditOrderScreen({Key? key, required this.order}) : super(key: key);

  @override
  _EditOrderScreenState createState() => _EditOrderScreenState();
}

class _EditOrderScreenState extends State<EditOrderScreen> {
  final DatabaseService _databaseService = DatabaseService();
  final _descriptionController = TextEditingController();
  final _addressController = TextEditingController();
  final _priceController = TextEditingController();
  String? _selectedClient;
  String? _selectedEmployee;
  String _selectedStatus = 'Новый';

  List<String> _statuses = ['Новый', 'В процессе', 'Завершен', 'Отменен', 'Ожидает'];

  @override
  void initState() {
    super.initState();
    _descriptionController.text = widget.order.description;
    _addressController.text = widget.order.address;
    _priceController.text = widget.order.price.toString();
    _selectedStatus = widget.order.status;
    _selectedClient = widget.order.clientId;
    _selectedEmployee = widget.order.employeeId;
  }

  void _updateOrder() async {
    if (_descriptionController.text.isEmpty ||
        _addressController.text.isEmpty ||
        _priceController.text.isEmpty ||
        _selectedClient == null ||
        _selectedEmployee == null) {
      return;
    }

    final updatedOrder = Order(
      id: widget.order.id,
      clientId: _selectedClient!,
      employeeId: _selectedEmployee!,
      address: _addressController.text,
      description: _descriptionController.text,
      price: double.parse(_priceController.text),
      status: _selectedStatus,
    );

    // Обновление заказа в Firebase
    await _databaseService.updateOrder(updatedOrder);
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Редактировать заказ'),
      ),
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
                return DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: 'Клиент'),
                  value: _selectedClient,
                  items: clients
                      .map((client) => DropdownMenuItem<String>(
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
                return DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: 'Сотрудник'),
                  value: _selectedEmployee,
                  items: employees
                      .map((employee) => DropdownMenuItem<String>(
                    value: employee.id,
                    child: Text(employee.name),
                  ))
                      .toList(),
                  onChanged: (value) => setState(() => _selectedEmployee = value),
                );
              },
            ),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Статус'),
              value: _selectedStatus,
              items: _statuses
                  .map((status) => DropdownMenuItem<String>(
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
        onPressed: _updateOrder,
        label: const Text('Сохранить изменения'),
        icon: const Icon(Icons.save),
      ),
    );
  }
}
