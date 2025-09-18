import 'package:mcdonald_cooking_bot/utils/enums.dart';

class OrderDataModel {
  String? id;
  String? title;
  DateTime? createdDate;
  DateTime? processingDate;
  DateTime? completedDate;
  double? totalPrice;
  OrderStatusType? type;
  OrderTier? tier;
  String? processingBy;
  String? completedBy;

  OrderDataModel({
    this.id,
    this.title,
    this.createdDate,
    this.processingDate,
    this.completedDate,
    // this.status,
    this.type,
    this.tier,
    this.processingBy,
    this.completedBy,
  });
}
