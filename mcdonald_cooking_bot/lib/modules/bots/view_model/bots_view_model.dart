import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:mcdonald_cooking_bot/modules/bots/models/bot_worker_model.dart';
import 'package:mcdonald_cooking_bot/modules/orders/view_model/orders_view_model.dart';
import 'package:mcdonald_cooking_bot/modules/orders/models/order_data_model.dart';
import 'package:mcdonald_cooking_bot/utils/constants.dart';
import 'package:mcdonald_cooking_bot/utils/enums.dart';

class BotsViewModel extends ChangeNotifier {
  final List<BotWorkerModel> _bots = [];
  OrdersViewModel? _ordersVm;
  int _idSeq = 0;
  bool _assigning = false;

  BotsViewModel([OrdersViewModel? ordersVm]) {
    attach(ordersVm);
    _initDefaultBot();
  }

  int get botsCount => _bots.length;
  List<BotWorkerModel> get bots => List.unmodifiable(_bots);

  void attach(OrdersViewModel? ordersVm) {
    _ordersVm?.removeListener(_onOrdersChanged);
    _ordersVm = ordersVm;
    _ordersVm?.addListener(_onOrdersChanged);
    Future.microtask(_tryAssignWork);
  }

  Future<void> addBot() async {
    _bots.add(_createBot());
    await _tryAssignWork();
    notifyListeners();
  }

  Future<void> removeBot() async {
    if (_bots.isEmpty) return;
    final bot = _bots.removeAt(0);
    _requeueOrderFromBot(bot);
    bot.cancelCurrent();
    bot.dispose();
    notifyListeners();
    await _tryAssignWork();
  }

  void _initDefaultBot() {
    if (_bots.isEmpty) {
      for (int i = 0; i < GeneralConstants.defaultBotCount; i++) {
        _bots.add(_createBot());
      }
      Future.microtask(_tryAssignWork);
    }
  }

  BotWorkerModel _createBot() => BotWorkerModel('BOT-${++_idSeq}');

  void _requeueOrderFromBot(BotWorkerModel bot) {
    final order = bot.currentOrder;
    if (order == null) return;
    order.type = OrderStatusType.pending;
    order.processingBy = null;
    order.processingDate = null;
    _ordersVm?.notifyListeners();
  }

  void _onOrdersChanged() => _tryAssignWork();

  Future<void> _tryAssignWork() async {
    if (_assigning) return;
    if (_ordersVm == null) return;
    _assigning = true;
    try {
      await _assignAvailableOrders();
    } finally {
      _assigning = false;
    }
  }

  Future<void> _assignAvailableOrders() async {
    final vm = _ordersVm;
    if (vm == null) return;

    final pending = vm.orders.where((o) {
      return o.type == OrderStatusType.pending && o.processingBy == null;
    }).toList();

    if (pending.isEmpty) return;

    bool anyOrderChanged = false;
    bool anyBotChanged = false;

    for (final bot in _bots.where((b) => !b.isBusy)) {
      if (pending.isEmpty) break;
      final order = pending.removeAt(0);
      _startOrder(bot, order);
      anyOrderChanged = true;
      anyBotChanged = true;
    }

    if (anyOrderChanged) vm.notifyListeners();
    if (anyBotChanged) notifyListeners();
  }

  void _startOrder(BotWorkerModel bot, OrderDataModel order) {
    order.processingBy = bot.id;
    order.processingDate = DateTime.now();
    bot.startOrder(order, () => _finalizeOrder(bot, order));
  }

  void _finalizeOrder(BotWorkerModel bot, OrderDataModel order) {
    order.type = OrderStatusType.completed;
    order.completedBy = bot.id;
    order.completedDate = DateTime.now();
    bot.isBusy = false;
    bot.currentOrder = null;
    bot.startedAt = null;
    _ordersVm?.notifyListeners();
    notifyListeners();
    _tryAssignWork();
  }

  @override
  void dispose() {
    _ordersVm?.removeListener(_onOrdersChanged);
    for (final b in _bots) {
      b.dispose();
    }
    super.dispose();
  }
}
