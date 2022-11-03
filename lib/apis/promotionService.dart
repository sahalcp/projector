import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:projector/constant.dart';
import 'package:projector/data/userData.dart';

class PromotionService {
  /// Apply promo code to user's account
  Future<bool> addUserPromotion(String promoCode) async {
    try {
      final token = await UserData().getUserToken();
      final reqBody = json.encode({'token': token, "promo_code": promoCode});
      final result = await http.post(
        Uri.parse('$serverUrl/addUserPromotion'),
        body: reqBody,
      );

      if (result.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print("Error occured: ${e.toString()}");
      return false;
    }
  }

  /// Get user's promo code details
  Future<List> getUserPromotion() async {
    try {
      final token = await UserData().getUserToken();
      final reqBody = json.encode({'token': token});
      final result = await http.post(
        Uri.parse('$serverUrl/getSignInPromoCode'),
        body: reqBody,
      );

      if (result.statusCode == 200) {
        final Map<String, dynamic> map = json.decode(result.body);
        return map['promo_code'] as List;
      } else {
        return null;
      }
    } catch (e) {
      print("Error occured: ${e.toString()}");
      return null;
    }
  }

  /// Update User's promo code pop up as skipped
  Future<bool> updatePromoCodePopUpSkipped() async {
    try {
      final token = await UserData().getUserToken();
      final reqBody = json.encode({'token': token});
      final result = await http.post(
        Uri.parse('$serverUrl/updatePromoCodePopUpSkipped'),
        body: reqBody,
      );

      if (result.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print("Error occured: ${e.toString()}");
      return false;
    }
  }
}
