import 'package:flutter/material.dart';
import 'package:projector/apis/subscriptionService.dart';
import 'package:projector/models/subscription_plan.dart';

class PaymentProvider extends ChangeNotifier {
  /// Whether the page is in busy state
  bool isBusy = true;

  /// Error message if exists
  String errorMessage;

  /// Selected plan
  SubscriptionPlan selectedPlan;

  /// All Active Plans
  List<SubscriptionPlan> allPlans;

  void initialize() async {
    try {
      allPlans = await SubscriptionService().getAllActivePlans();

      if (allPlans != null) {
        selectedPlan = allPlans.first;
      }

      isBusy = false;

      notifyListeners();
    } catch (e) {
      isBusy = false;
      errorMessage = "Error occured while initializing payment page";
      print("$errorMessage: ${e.toString()}");
      notifyListeners();
    }
  }

  Future<void> changeSelectedPlan(SubscriptionPlan newPlan) {
    selectedPlan = newPlan;
    notifyListeners();
  }

  Future<void> completePayment() {}
}
