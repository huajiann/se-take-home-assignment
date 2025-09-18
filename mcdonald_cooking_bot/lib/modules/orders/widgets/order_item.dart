import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mcdonald_cooking_bot/modules/orders/models/order_data_model.dart';
import 'package:mcdonald_cooking_bot/utils/enums.dart';

class OrderItem extends StatefulWidget {
  const OrderItem({super.key, required this.order}) : isCompleted = false;
  const OrderItem.completed({super.key, required this.order})
    : isCompleted = true;

  final OrderDataModel order;
  final bool isCompleted;

  @override
  State<OrderItem> createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  Timer? _ticker;

  OrderDataModel get order => widget.order;
  bool get isVip => order.tier == OrderTier.vip;
  bool get _isProcessing =>
      !widget.isCompleted &&
      order.processingDate != null &&
      order.processingBy != null;

  String get status {
    if (widget.isCompleted) {
      final completedDateTime = order.completedDate?.toLocal();
      return completedDateTime != null
          ? 'Completed: ${DateFormat('yyyy-MM-dd HH:mm:ss').format(completedDateTime)}'
          : 'Completed time unknown';
    }
    return _isProcessing ? 'Processing by ${order.processingBy}' : 'Waiting';
  }

  String get timeInfo {
    if (!_isProcessing) return '';
    final elapsed = DateTime.now().difference(order.processingDate!).inSeconds;
    return ' (${elapsed}s)';
  }

  @override
  void didChangeDependencies() {
    _configureTimer();
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(covariant OrderItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.order.processingDate != order.processingDate ||
        oldWidget.order.processingBy != order.processingBy ||
        oldWidget.isCompleted != widget.isCompleted) {
      _configureTimer();
    }
  }

  void _configureTimer() {
    _stopTimer();
    if (_isProcessing) {
      _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
        if (!mounted) return;
        if (!_isProcessing) {
          _stopTimer();
          return;
        }
        setState(() {});
      });
    }
  }

  void _stopTimer() {
    _ticker?.cancel();
    _ticker = null;
  }

  @override
  void dispose() {
    _stopTimer();
    super.dispose();
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
      subtitle: Text(status + (widget.isCompleted ? '' : timeInfo)),
      trailing: _isProcessing
          ? const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 3),
            )
          : null,
    );
  }
}
