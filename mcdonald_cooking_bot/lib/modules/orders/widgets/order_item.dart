import 'package:flutter/material.dart';
import 'package:mcdonald_cooking_bot/modules/orders/models/order_data_model.dart';
import 'package:mcdonald_cooking_bot/utils/enums.dart';

class OrderItem extends StatelessWidget {
  const OrderItem({super.key, required this.order});

  final OrderDataModel order;

  bool get isVip => order.tier == OrderTier.vip;

  String get status {
    return order.processingBy != null
        ? 'Processing by ${order.processingBy}'
        : 'Waiting';
  }

  String get timeInfo {
    if (order.processingDate != null) {
      final elapsed = DateTime.now()
          .difference(order.processingDate!)
          .inSeconds;
      return ' (${elapsed}s)';
    }

    return '';
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: isVip ? Colors.red : Colors.blue,
        foregroundColor: Colors.white,
        child: Text(isVip ? 'V' : 'N'),
      ),
      title: Text(order.title ?? (isVip ? 'VIP Order' : 'Normal Order')),
      subtitle: Text(status + timeInfo),
      trailing: order.processingBy != null
          ? const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 3),
            )
          : null,
    );
  }
}
