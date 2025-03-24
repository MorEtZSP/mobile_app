import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Регистрация пользователя
  Future<String?> register(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
      return null; // Успех
    } on FirebaseAuthException catch (e) {
      return e.message; // Ошибка
    }
  }

  // Вход пользователя
  Future<String?> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return null; // Успех
    } on FirebaseAuthException catch (e) {
      return e.message; // Ошибка
    }
  }

  // Выход пользователя
  Future<void> logout() async {
    await _auth.signOut();
  }

  // Проверка авторизованного пользователя
  User? get currentUser => _auth.currentUser;
}
