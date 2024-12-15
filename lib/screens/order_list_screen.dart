import 'package:flutter/material.dart';
import 'add_order_screen.dart';
import 'order_detail_screen.dart';
import 'edit_order_screen.dart';
import '../models/order.dart'; // Импортируем модель Order

class OrderListScreen extends StatefulWidget {
  @override
  _OrderListScreenState createState() => _OrderListScreenState();
}

class _OrderListScreenState extends State<OrderListScreen> {
  List<Order> orders = [
    Order(
      id: 1,
      clientId: '1',
      employeeId: '1',
      address: 'Address 1',
      description: 'Description 1',
      price: 100.0,
      status: 'pending',
    ),
    Order(
      id: 2,
      clientId: '2',
      employeeId: '2',
      address: 'Address 2',
      description: 'Description 2',
      price: 150.0,
      status: 'completed',
    ),
    Order(
      id: 3,
      clientId: '3',
      employeeId: '3',
      address: 'Address 3',
      description: 'Description 3',
      price: 200.0,
      status: 'in_progress',
    ),
  ];

  // Фильтрационные переменные
  String clientIdFilter = '';
  String employeeIdFilter = '';
  String addressFilter = '';
  String descriptionFilter = '';
  double priceFilter = 0.0;

  // Метод для фильтрации заказов
  List<Order> getFilteredOrders() {
    return orders.where((order) {
      final matchesClientId = order.clientId.contains(clientIdFilter);
      final matchesEmployeeId = order.employeeId.contains(employeeIdFilter);
      final matchesAddress = order.address.contains(addressFilter);
      final matchesDescription = order.description.contains(descriptionFilter);
      final matchesPrice = order.price >= priceFilter;

      return matchesClientId && matchesEmployeeId && matchesAddress &&
          matchesDescription && matchesPrice;
    }).toList();
  }

  // Обновление состояния фильтров
  void _applyFilters() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final filteredOrders = getFilteredOrders();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Orders'),
      ),
      body: Column(
        children: [
          // Фильтры в раскрывающемся меню
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ExpansionTile(
              title: const Text('Filters'),
              children: [
                TextField(
                  decoration: const InputDecoration(labelText: 'Client ID'),
                  onChanged: (value) {
                    clientIdFilter = value;
                    _applyFilters();
                  },
                ),
                TextField(
                  decoration: const InputDecoration(labelText: 'Employee ID'),
                  onChanged: (value) {
                    employeeIdFilter = value;
                    _applyFilters();
                  },
                ),
                TextField(
                  decoration: const InputDecoration(labelText: 'Address'),
                  onChanged: (value) {
                    addressFilter = value;
                    _applyFilters();
                  },
                ),
                TextField(
                  decoration: const InputDecoration(labelText: 'Description'),
                  onChanged: (value) {
                    descriptionFilter = value;
                    _applyFilters();
                  },
                ),
                Row(
                  children: [
                    const Text('Price:'),
                    Expanded(
                      child: Slider(
                        value: priceFilter,
                        min: 0,
                        max: 500.0,
                        onChanged: (value) {
                          setState(() {
                            priceFilter = value;
                          });
                          _applyFilters();
                        },
                      ),
                    ),
                    Text('\$${priceFilter.toStringAsFixed(2)}'),
                  ],
                ),
              ],
            ),
          ),
          // Список заказов
          Expanded(
            child: ListView.builder(
              itemCount: filteredOrders.length,
              itemBuilder: (context, index) {
                final order = filteredOrders[index];
                return ListTile(
                  title: Text('Order #${order.id}'),
                  subtitle: Text('Client ID: ${order.clientId}\nStatus: ${order.status}'),
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/orderDetail',
                      arguments: order,
                    );
                  },
                  trailing: IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditOrderScreen(order: order),
                        ),
                      ).then((updatedOrder) {
                        if (updatedOrder != null) {
                          setState(() {
                            int index = orders.indexWhere((o) => o.id == updatedOrder.id);
                            if (index != -1) {
                              orders[index] = updatedOrder;
                            }
                          });
                        }
                      });
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      // Кнопка добавления заказа внизу справа
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/add_order').then((newOrder) {
            if (newOrder != null) {
              setState(() {
                orders.add(newOrder as Order);
              });
            }
          });
        },
        child: const Icon(Icons.add),
        tooltip: 'Add Order',
      ),
    );
  }
}
