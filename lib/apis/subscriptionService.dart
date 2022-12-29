import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:projector/constant.dart';
import 'package:projector/data/userData.dart';
import 'package:projector/models/subscription_plan.dart';

class SubscriptionService {
  getMySubscription() async {
    var token = await UserData().getUserToken();

    var res = await http.post(
      Uri.parse('$serverUrl/getMySubscription'),
      body: json.encode({'token': token}),
    );
    // print(res.body);

    return json.decode(res.body);
  }

  /// Get all purchase plans
  Future<List<SubscriptionPlan>> getAllActivePlans() async {
    var body = json.encode({"limit": 10, "offset": 0});
    var res = await http.post(
      Uri.parse('$serverUrl/getAllActivePlans'),
      body: body,
    );
    var data = json.decode(res.body);

    if (res.statusCode == 200) {
      final List planList = data['data'];
      return planList
          .map((plan) => new SubscriptionPlan.fromJson(plan))
          .toList();
    } else {
      return null;
    }
  }

  /// Complete Payment to backend with Apple Pay
  Future<bool> payWithApplePay({String planId, String transactionId}) async {
    try {
      var token = await UserData().getUserToken();
      var body = json.encode(
          {"plan_id": planId, "transaction_id": transactionId, "token": token});
      var res = await http.post(
        Uri.parse('$serverUrl/updateApplePayResponse'),
        body: body,
      );

      if (res.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      debugPrint("Error completing transaction with API");
      return false;
    }
  }

  purchaseProduct({email, stripeToken, priceId, trial}) async {
    var body = json.encode({
      "email": email,
      "stripe_token": stripeToken,
      "price_id": priceId,
      "trial_period_days": trial,
    });
    var res = await http.post(
      Uri.parse('$serverUrl/purchaseProduct'),
      body: body,
    );

    return json.decode(res.body);
  }
}
