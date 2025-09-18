import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mcdonald_cooking_bot/utils/enums.dart';
import 'package:provider/provider.dart';
import '../view_model/orders_view_model.dart';

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
            final isVip = order.tier == OrderTier.vip;
            final completedDate = order.completedDate?.toLocal();

            return ListTile(
              leading: CircleAvatar(
                backgroundColor: isVip ? Colors.red : Colors.blue,
                foregroundColor: Colors.white,
                child: Text(isVip ? 'V' : 'N'),
              ),
              title: Text(
                order.title ?? (isVip ? 'VIP Order' : 'Normal Order'),
              ),
              subtitle: Text(
                completedDate != null
                    ? 'Completed: ${DateFormat('yyyy-MM-dd HH:mm:ss').format(completedDate)}'
                    : 'Completed date unknown',
              ),
            );
          },
        );
      },
    );
  }
}
