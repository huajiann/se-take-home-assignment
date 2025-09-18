import 'package:flutter/foundation.dart';
import 'package:mcdonald_cooking_bot/utils/enums.dart';
import 'package:mcdonald_cooking_bot/modules/orders/models/order_data_model.dart';

class OrdersViewModel extends ChangeNotifier {
  final List<OrderDataModel> _orders = [];

  List<OrderDataModel> get orders => List.unmodifiable(_orders);

  List<OrderDataModel> get pendingOrders => List.unmodifiable(
    _orders.where((o) => o.type == OrderStatusType.pending).toList(),
  );

  List<OrderDataModel> get completedOrders => List.unmodifiable(
    _orders.where((o) => o.type == OrderStatusType.completed).toList(),
  );

  void addVipOrder(OrderDataModel order) {
    order.tier = OrderTier.vip;
    order.type = OrderStatusType.pending;
    order.createdDate = DateTime.now();

    final insertIndex = _orders.indexWhere((order) {
      return order.type == OrderStatusType.pending &&
          (order.tier == null || order.tier == OrderTier.normal);
    });

    if (insertIndex == -1) {
      _orders.add(order);
    } else {
      _orders.insert(insertIndex, order);
    }

    notifyListeners();
  }

  void addNormalOrder(OrderDataModel order) {
    order.tier = OrderTier.normal;
    order.type = OrderStatusType.pending;
    order.createdDate = DateTime.now();

    int lastPendingIndex = _orders.lastIndexWhere(
      (order) => order.type == OrderStatusType.pending,
    );
    if (lastPendingIndex == -1) {
      _orders.add(order);
    } else {
      _orders.insert(lastPendingIndex + 1, order);
    }

    notifyListeners();
  }

  void completeOrder(String id) {
    final index = _orders.indexWhere((order) => order.id == id);
    if (index == -1) return;
    final order = _orders[index];
    if (order.type == OrderStatusType.completed) return;

    order.type = OrderStatusType.completed;
    order.completedDate = DateTime.now();

    notifyListeners();
  }
}
