import 'package:flutter/material.dart';

enum OrderStatusType {
  pending,
  completed;

  String get label {
    switch (this) {
      case pending:
        return 'PENDING';
      case completed:
        return 'COMPLETE';
    }
  }
}

enum OrderTier {
  vip,
  normal;

  String get buttonLabel {
    switch (this) {
      case vip:
        return 'New VIP Order';
      case normal:
        return 'New Normal Order';
    }
  }

  Color get buttonColor {
    switch (this) {
      case vip:
        return Colors.red;
      case normal:
        return Colors.blue;
    }
  }
}
