import '../models/order.dart';

class OrderService {
  List<Order> filterOrdersByStatus(List<Order> orders, String status) {
    return orders.where((order) => order.status == status).toList();
  }

  void updateOrderStatus(Order order, String newStatus) {
    // Пересоздаем объект Order с обновленным статусом
    order = Order(
      id: order.id,
      clientId: order.clientId,
      employeeId: order.employeeId,
      address: order.address,
      description: order.description,
      price: order.price,
      status: newStatus, // новый статус
    );
    print('Order ${order.id} status updated to $newStatus');
  }
}
