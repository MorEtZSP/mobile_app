class AuthService {
  static final Map<String, String> _users = {
    'test@example.com': 'password123',
    'admin@example.com': 'admin123',
  };

  static final Map<String, String> _userNames = {
    'test@example.com': 'John Doe',
    'admin@example.com': 'Jane Doe',
  };

  String? _loggedInUser;

  bool login(String email, String password) {
    if (_users.containsKey(email) && _users[email] == password) {
      _loggedInUser = email;
      print('Login successful for $email');
      return true;
    }
    print('Login failed for $email');
    return false;
  }

  bool register(String name, String email, String password) {
    if (_users.containsKey(email)) {
      print('Email already exists');
      return false;
    }
    _users[email] = password;
    _userNames[email] = name;  // Добавляем имя при регистрации
    print('Registration successful for $email');
    return true;
  }

  void logout() {
    _loggedInUser = null;
    print('User logged out');
  }

  String? get loggedInUser => _loggedInUser;

  String? getUserName(String email) {
    return _userNames[email];  // Возвращаем имя пользователя
  }

  // Новый метод для получения имени текущего пользователя
  String? getLoggedInUserName() {
    if (_loggedInUser != null) {
      return _userNames[_loggedInUser!];
    }
    return null;  // Если пользователь не авторизован
  }
}
