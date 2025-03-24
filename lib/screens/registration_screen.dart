import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();

  String _errorMessage = '';

  void _register() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    String? error = await _authService.register(email, password);
    if (error == null) {
      Navigator.pushReplacementNamed(context, '/login'); // Перенаправление
    } else {
      setState(() {
        _errorMessage = error;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password'),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(onPressed: _register, child: const Text('Register')),
            if (_errorMessage.isNotEmpty)
              Text(_errorMessage, style: const TextStyle(color: Colors.red)),
          ],
        ),
      ),
    );
  }
}
