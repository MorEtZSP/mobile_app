import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import '../models/order.dart';
import '../models/client.dart';
import '../models/employee.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database?> get database async {
    if (kIsWeb) return null; // No SQLite on web
    if (_database != null) return _database!;
    _database = await _initDB('cleaning_orders.db');
    return _database!;
  }

  Future<Database> _initDB(String fileName) async {
    final directory = await getApplicationDocumentsDirectory();
    final path = join(directory.path, fileName);

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        // Orders table
        await db.execute('''
          CREATE TABLE orders (
            id TEXT PRIMARY KEY,
            description TEXT,
            status TEXT,
            clientId TEXT,
            employeeId TEXT,
            address TEXT,
            price REAL,
            isSynced INTEGER DEFAULT 0
          )
        ''');
        // Users table
        await db.execute('''
          CREATE TABLE users (
            uid TEXT PRIMARY KEY,
            email TEXT,
            password TEXT,
            isSynced INTEGER DEFAULT 0
          )
        ''');
        // Clients table
        await db.execute('''
          CREATE TABLE clients (
            id TEXT PRIMARY KEY,
            name TEXT,
            email TEXT,
            phone TEXT,
            isSynced INTEGER DEFAULT 0
          )
        ''');
        // Employees table
        await db.execute('''
          CREATE TABLE employees (
            id TEXT PRIMARY KEY,
            name TEXT,
            position TEXT,
            phone TEXT,
            isSynced INTEGER DEFAULT 0
          )
        ''');
      },
    );
  }

  // Orders Methods
  Future<void> insertOrder(Order order, {bool isSynced = false}) async {
    if (kIsWeb) return;
    final db = await database;
    await db!.insert(
      'orders',
      {
        'id': order.id,
        'description': order.description,
        'status': order.status,
        'clientId': order.clientId,
        'employeeId': order.employeeId,
        'address': order.address,
        'price': order.price,
        'isSynced': isSynced ? 1 : 0,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Order>> getOrders() async {
    if (kIsWeb) return [];
    final db = await database;
    final result = await db!.query('orders');
    return result.map((map) => Order.fromMap(map)).toList();
  }

  Future<List<Order>> getUnsyncedOrders() async {
    if (kIsWeb) return [];
    final db = await database;
    final result = await db!.query('orders', where: 'isSynced = ?', whereArgs: [0]);
    return result.map((map) => Order.fromMap(map)).toList();
  }

  Future<void> markAsSynced(String orderId) async {
    if (kIsWeb) return;
    final db = await database;
    await db!.update(
      'orders',
      {'isSynced': 1},
      where: 'id = ?',
      whereArgs: [orderId],
    );
  }

  // Users Methods (unchanged)
  Future<void> insertUser(String uid, String email, String password, {bool isSynced = false}) async {
    if (kIsWeb) return;
    final db = await database;
    await db!.insert(
      'users',
      {'uid': uid, 'email': email, 'password': password, 'isSynced': isSynced ? 1 : 0},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Map<String, dynamic>?> getUserByEmail(String email) async {
    if (kIsWeb) return null;
    final db = await database;
    final result = await db!.query('users', where: 'email = ?', whereArgs: [email], limit: 1);
    return result.isNotEmpty ? result.first : null;
  }

  Future<void> markUserAsSynced(String uid) async {
    if (kIsWeb) return;
    final db = await database;
    await db!.update('users', {'isSynced': 1}, where: 'uid = ?', whereArgs: [uid]);
  }

  // Clients Methods
  Future<void> insertClient(Client client, {bool isSynced = false}) async {
    if (kIsWeb) return;
    final db = await database;
    await db!.insert(
      'clients',
      {
        'id': client.id,
        'name': client.name,
        'email': client.email,
        'phone': client.phone,
        'isSynced': isSynced ? 1 : 0,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Client?> getClientById(String id) async {
    if (kIsWeb) return null;
    final db = await database;
    final result = await db!.query('clients', where: 'id = ?', whereArgs: [id], limit: 1);
    return result.isNotEmpty ? Client.fromMap(result.first) : null;
  }

  // Employees Methods
  Future<void> insertEmployee(Employee employee, {bool isSynced = false}) async {
    if (kIsWeb) return;
    final db = await database;
    await db!.insert(
      'employees',
      {
        'id': employee.id,
        'name': employee.name,
        'position': employee.position,
        'phone': employee.phone,
        'isSynced': isSynced ? 1 : 0,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Employee?> getEmployeeById(String id) async {
    if (kIsWeb) return null;
    final db = await database;
    final result = await db!.query('employees', where: 'id = ?', whereArgs: [id], limit: 1);
    return result.isNotEmpty ? Employee.fromMap(result.first) : null;
  }
}