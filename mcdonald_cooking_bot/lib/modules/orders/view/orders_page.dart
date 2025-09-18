import 'package:flutter/material.dart';
import 'package:mcdonald_cooking_bot/utils/enums.dart';

import 'completed_orders_page.dart';
import 'pending_orders_page.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: OrderStatusType.values.length,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TabBar(
            tabs: OrderStatusType.values
                .map((type) => Tab(text: type.label))
                .toList(),
          ),
          Expanded(
            child: TabBarView(
              children: OrderStatusType.values.map((type) {
                switch (type) {
                  case OrderStatusType.pending:
                    return const PendingOrdersPage();
                  case OrderStatusType.completed:
                    return const CompletedOrdersPage();
                }
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
