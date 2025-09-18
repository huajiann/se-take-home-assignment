import 'package:flutter/material.dart';
import 'package:mcdonald_cooking_bot/modules/orders/widgets/order_item.dart';
import 'package:provider/provider.dart';
import 'package:mcdonald_cooking_bot/modules/orders/view_model/orders_view_model.dart';

class CompletedOrdersPage extends StatelessWidget {
  const CompletedOrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<OrdersViewModel>(
      builder: (context, vm, _) {
        final orders = vm.completedOrders;
        if (orders.isEmpty) {
          return const Center(
            child: Text('No completed orders', style: TextStyle(fontSize: 16)),
          );
        }
        return ListView.separated(
          padding: const EdgeInsets.all(12),
          itemCount: orders.length,
          separatorBuilder: (context, index) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final order = orders[index];
            return OrderItem.completed(order: order);
          },
        );
      },
    );
  }
}
