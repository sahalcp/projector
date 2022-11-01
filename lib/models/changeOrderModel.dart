import 'package:flutter/widgets.dart';

class ChangeOrder {
  ChangeOrder({@required this.id, this.orderNumber});
  String id, orderNumber;

  Map<String, dynamic> toJson() => {"$id": "$orderNumber"};
}
