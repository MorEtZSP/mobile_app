import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/registration_screen.dart';
import 'screens/order_list_screen.dart';
import 'screens/order_detail_screen.dart';
import 'screens/add_order_screen.dart';
import 'screens/edit_order_screen.dart';
import 'models/order.dart';
import 'firebase_options.dart'; // Подключаем Firebase options
import '../services/database_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

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
      initialRoute: FirebaseAuth.instance.currentUser == null ? '/login' : '/orders',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/login':
            return MaterialPageRoute(builder: (_) => const LoginScreen());
          case '/register':
            return MaterialPageRoute(builder: (_) => const RegistrationScreen());
          case '/orders':
            return MaterialPageRoute(builder: (_) => OrderListScreen());
          case '/add_order':
            return MaterialPageRoute(
              builder: (context) => Dialog(
                child: AddOrderScreen(),
              ),
            );
          case '/orderDetail':
            final order = settings.arguments as Order;
            final clientFuture = DatabaseService().getClientById(order.clientId);
            final employeeFuture = DatabaseService().getEmployeeById(order.employeeId);
            return MaterialPageRoute(
              builder: (_) => OrderDetailScreen(
                order: order,
                clientFuture: clientFuture,
                employeeFuture: employeeFuture,
              ),
            );
          case '/edit_order':
            final order = settings.arguments as Order;
            return MaterialPageRoute(builder: (_) => EditOrderScreen(order: order));
          default:
            return MaterialPageRoute(
              builder: (_) => const Scaffold(body: Center(child: Text('Page not found'))),
            );
        }
      },
    );
  }
}
