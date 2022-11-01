import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:projector/apis/subscriptionService.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:stripe_payment/stripe_payment.dart';

class StripeTransactionResponse {
  String message;
  bool success;
  //StripeTransactionResponse({this.message, this.success});
}

class StripeService {
  /*static String apiBase = 'https://api.stripe.com/v1';
  static String paymentApiUrl = '${StripeService.apiBase}/payment_intents';
  static String secret =
      "sk_test_51H6eT4I6NUXskacrekUKVQ9MOMcKaNFVmTTJzEoe4pyk1kBHwDsKfoHaemgMa4KHz85NcGOTv2GZEOT4uPISzgoB00jdwTqzQ5";
  static Map<String, String> headers = {
    'Authorization': 'Bearer ${StripeService.secret}',
    'Content-Type': 'application/x-www-form-urlencoded'
  };
  static init() {
    StripePayment.setOptions(StripeOptions(
        publishableKey:
            "pk_test_qgdXOzP1IBfRXiFiAGh7t1V3",
        merchantId: "Test",
        androidPayMode: 'test'));
  }

  // ignore: missing_return
  static Future payWithNewCard({amount, currency}) async {
    try {
      var paymentMethod = await StripePayment.paymentRequestWithCardForm(
          CardFormPaymentRequest());
      var paymentIntent =
          await StripeService.createPaymentIntent("$amount", currency);

      var response = await StripePayment.confirmPaymentIntent(
        PaymentIntent(
            clientSecret: paymentIntent['client_secret'],
            paymentMethodId: paymentMethod.id),
      );

      if (response.status == 'succeeded') {
        return paymentMethod.id;
      } else {
        return null;
      }
    } on PlatformException catch (err) {
      print(err);
      return null;
    } catch (err) {
      print(err);
      return null;
    }
  }

  static getPlatformExceptionErrorResult(err) {
    return new StripeTransactionResponse(
        message: err.toString(), success: false);
  }

  static Future<Map<String, dynamic>> createPaymentIntent(
      String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': amount,
        'currency': currency,
        'payment_method_types[]': 'card'
      };
      var response = await http.post(StripeService.paymentApiUrl,
          body: body, headers: StripeService.headers);
      return jsonDecode(response.body);
    } catch (err) {
      print('err charging user: ${err.toString()}');
    }
    return null;
  }*/
}
