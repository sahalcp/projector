class SubscriptionPlan {
  SubscriptionPlan({
    this.productName,
    this.subTitle,
    this.id,
    this.productId,
    this.priceDescription,
    this.currency,
    this.amount,
    this.intervalInDays,
    this.unit,
    this.description,
    this.stripePlanId,
  });

  final String productName;
  final String subTitle;
  final String id;
  final String productId;
  final String priceDescription;
  final String currency;
  final num amount;
  final int intervalInDays;
  final String unit;
  final String description;
  final String stripePlanId;

  factory SubscriptionPlan.fromJson(Map<String, dynamic> json) =>
      SubscriptionPlan(
        productName: json["product_name"],
        subTitle: json["sub_title"],
        id: json["id"],
        productId: json["product_id"],
        priceDescription: json["price_description"],
        currency: json["currency"],
        amount: json["amount"],
        intervalInDays: int.tryParse(json["interval_in_days"]),
        unit: json["unit"],
        description: json["description"],
        stripePlanId: json["stripe_plan_id"],
      );

  Map<String, dynamic> toJson() => {
        "product_name": productName,
        "sub_title": subTitle,
        "id": id,
        "product_id": productId,
        "price_description": priceDescription,
        "currency": currency,
        "amount": amount,
        "interval_in_days": intervalInDays.toString(),
        "unit": unit,
        "description": description,
        "stripe_plan_id": stripePlanId,
      };
}
