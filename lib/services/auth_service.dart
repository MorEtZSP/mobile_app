import 'package:firebase_auth/firebase_auth.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../services/database_helper.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  // Check connectivity
  Future<bool> _isOnline() async {
    if (kIsWeb) return true; // Assume online for web
    final connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  // Регистрация пользователя (только онлайн)
  Future<String?> register(String email, String password) async {
    if (!(await _isOnline())) {
      return 'Registration is not available offline';
    }
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      // Sync to SQLite
      await _dbHelper.insertUser(userCredential.user!.uid, email, password, isSynced: true);
      return null; // Успех
    } on FirebaseAuthException catch (e) {
      return e.message; // Ошибка
    }
  }

  // Вход пользователя (онлайн или оффлайн)
  Future<String?> login(String email, String password) async {
    if (await _isOnline()) {
      try {
        UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        // Sync to SQLite
        await _dbHelper.insertUser(userCredential.user!.uid, email, password, isSynced: true);
        return null; // Успех
      } on FirebaseAuthException catch (e) {
        return e.message; // Ошибка
      }
    } else {
      // Offline login
      final userData = await _dbHelper.getUserByEmail(email);
      if (userData != null && userData['password'] == password) {
        return null; // Успех (оффлайн)
      } else {
        return 'Invalid credentials or user not found offline';
      }
    }
  }

  // Выход пользователя
  Future<void> logout() async {
    await _auth.signOut();
  }

  // Проверка авторизованного пользователя
  User? get currentUser => _auth.currentUser;

  // Синхронизация пользователя при подключении к сети
  Future<void> syncUser() async {
    if (kIsWeb || !(await _isOnline())) return;
    final user = _auth.currentUser;
    if (user != null) {
      await _dbHelper.insertUser(user.uid, user.email ?? '', '', isSynced: true);
    }
  }
}