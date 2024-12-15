import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/registration_screen.dart';
import 'screens/order_list_screen.dart';
import 'screens/order_detail_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/add_order_screen.dart';
import 'screens/edit_order_screen.dart'; // Импортируем экран редактирования
import 'models/order.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cleaning Orders',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegistrationScreen(),
        '/orders': (context) => OrderListScreen(),
        '/add_order': (context) => AddOrderScreen(),
        '/orderDetail': (context) {
          final Order order = ModalRoute.of(context)?.settings.arguments as Order;
          return OrderDetailScreen(order: order);
        },
        '/profile': (context) => const ProfileScreen(),
        '/edit_order': (context) => EditOrderScreen(order: Order( // Пример редактирования
          id: 1,
          clientId: '1',
          employeeId: '1',
          address: 'Address 1',
          description: 'Description 1',
          price: 100.0,
          status: 'pending',
        )),
      },
    );
  }
}
