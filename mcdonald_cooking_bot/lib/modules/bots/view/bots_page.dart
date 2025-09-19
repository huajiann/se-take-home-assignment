import 'package:flutter/material.dart';
import 'package:mcdonald_cooking_bot/utils/enums.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:mcdonald_cooking_bot/modules/bots/view_model/bots_view_model.dart';
import 'package:mcdonald_cooking_bot/modules/orders/view_model/orders_view_model.dart';

class BotsPage extends StatelessWidget {
  const BotsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 16),
          _buildBotActions(),
          const SizedBox(height: 24),
          _buildBody(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Consumer2<BotsViewModel, OrdersViewModel>(
      builder: (context, botsVm, ordersVm, child) {
        final pendingOrders = ordersVm.orders.where((order) {
          return order.type == OrderStatusType.pending &&
              order.processingBy == null;
        }).length;

        return Row(
          children: [
            Text(
              'Bots: ${botsVm.botsCount}',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 16),
            Text('Queued Orders: $pendingOrders'),
          ],
        );
      },
    );
  }

  Widget _buildBody() {
    return Consumer<BotsViewModel>(
      builder: (context, botsVm, child) {
        return Expanded(
          child: botsVm.bots.isEmpty
              ? const Center(child: Text('No bots yet'))
              : ListView.separated(
                  itemCount: botsVm.bots.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final bot = botsVm.bots[index];
                    final status = bot.isBusy ? 'Processing' : 'Idle';
                    final orderTitle = bot.currentOrder?.title ?? '-';
                    final createdFmt = DateFormat(
                      'HH:mm:ss',
                    ).format(bot.createdAt);

                    return ListTile(
                      leading: CircleAvatar(child: Text('${index + 1}')),
                      title: Text('Bot ${bot.id}'),
                      subtitle: Text(
                        'Created: $createdFmt\n$status: $orderTitle',
                      ),
                      isThreeLine: true,
                      trailing: bot.isBusy
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 3),
                            )
                          : const Icon(Icons.pause, color: Colors.grey),
                    );
                  },
                ),
        );
      },
    );
  }

  Widget _buildBotActions() {
    return Consumer<BotsViewModel>(
      builder: (context, botsVm, child) {
        return Row(
          spacing: 12,
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: botsVm.addBot,
                icon: const Icon(Icons.add, color: Colors.white),
                label: const Text(
                  'Bot',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              ),
            ),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: botsVm.botsCount > 0 ? botsVm.removeBot : null,
                icon: const Icon(Icons.remove, color: Colors.white),
                label: const Text(
                  'Bot',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }
}
