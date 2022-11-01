import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:projector/constant.dart';
import 'package:projector/data/userData.dart';

getMySubscription() async {
  var token = await UserData().getUserToken();

  var res = await http.post(
   Uri.parse('$serverUrl/getMySubscription'),
    body: json.encode({'token': token}),
  );
  // print(res.body);

  return json.decode(res.body);
}

getAllPlans() async {
  var res =
      await http.get(Uri.parse('$serverUrl/GetAllProducts'));
  return json.decode(res.body);
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
