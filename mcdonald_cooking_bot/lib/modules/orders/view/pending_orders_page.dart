import 'package:flutter/material.dart';
import 'package:mcdonald_cooking_bot/modules/orders/widgets/order_item.dart';
import 'package:mcdonald_cooking_bot/utils/enums.dart';
import 'package:provider/provider.dart';
import 'package:mcdonald_cooking_bot/modules/orders/models/order_data_model.dart';
import 'package:mcdonald_cooking_bot/modules/orders/view_model/orders_view_model.dart';

class PendingOrdersPage extends StatelessWidget {
  const PendingOrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Buttons moved to top (like Bots page)
            Row(
              children: [
                _buildOrderButton(
                  context: context,
                  label: OrderTier.vip.buttonLabel,
                  backgroundColor: OrderTier.vip.buttonColor,
                  onPressed: () => _onButtonPressed(context, OrderTier.vip),
                ),
                const SizedBox(width: 12),
                _buildOrderButton(
                  context: context,
                  label: OrderTier.normal.buttonLabel,
                  backgroundColor: OrderTier.normal.buttonColor,
                  onPressed: () => _onButtonPressed(context, OrderTier.normal),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Expanded(
              child: Consumer<OrdersViewModel>(
                builder: (context, vm, child) {
                  final orders = vm.pendingOrders;
                  if (orders.isEmpty) return _emptyPlaceholder();
                  return ListView.separated(
                    itemCount: orders.length,
                    separatorBuilder: (context, index) =>
                        const Divider(height: 1),
                    itemBuilder: (context, index) =>
                        OrderItem(order: orders[index]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _emptyPlaceholder() => const Center(
    child: Text('No pending orders', style: TextStyle(fontSize: 16)),
  );

  Widget _buildOrderButton({
    required BuildContext context,
    required String label,
    required Color backgroundColor,
    required VoidCallback onPressed,
  }) {
    return Expanded(
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: Colors.white,
        ),
        child: Text(label),
      ),
    );
  }

  void _onButtonPressed(BuildContext context, OrderTier type) {
    final vm = context.read<OrdersViewModel>();
    final orderId =
        '${type.name.toUpperCase()}-${DateTime.now().toIso8601String()}';
    final order = OrderDataModel(
      id: orderId,
      title: orderId,
      type: OrderStatusType.pending,
      tier: type,
      createdDate: DateTime.now(),
    );
    if (type == OrderTier.vip) {
      vm.addVipOrder(order);
    } else {
      vm.addNormalOrder(order);
    }
  }
}
