// employee.dart
class Employee {
  final int id;
  final String name;
  final String position;
  final String phone;

  Employee({
    required this.id,
    required this.name,
    required this.position,
    required this.phone,
  });

  // Example static data for demonstration
  static List<Employee> exampleEmployees = [
    Employee(
      id: 1,
      name: 'Alice Johnson',
      position: 'Cleaner',
      phone: '+1122334455',
    ),
    Employee(
      id: 2,
      name: 'Bob Brown',
      position: 'Supervisor',
      phone: '+2233445566',
    ),
  ];
}
