import 'dart:async';
import 'dart:ui';

import 'package:mcdonald_cooking_bot/modules/orders/models/order_data_model.dart';
import 'package:mcdonald_cooking_bot/utils/constants.dart';

class BotWorkerModel {
  final String id;
  final DateTime createdAt = DateTime.now();
  bool isBusy = false;
  Timer? _timer;
  OrderDataModel? currentOrder;
  DateTime? startedAt;

  BotWorkerModel(this.id);

  void startOrder(OrderDataModel order, {required VoidCallback onComplete}) {
    isBusy = true;
    currentOrder = order;
    startedAt = DateTime.now();
    _timer?.cancel();
    _timer = Timer(
      const Duration(seconds: GeneralConstants.processTimeInSeconds),
      onComplete,
    );
  }

  void cancelCurrent() {
    _timer?.cancel();
    isBusy = false;
    _timer = null;
    currentOrder = null;
    startedAt = null;
  }

  void dispose() {
    _timer?.cancel();
  }
}
