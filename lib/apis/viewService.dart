import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:projector/constant.dart';
import 'package:projector/data/userData.dart';
import 'package:projector/login/GuideScreen.dart';
import 'package:projector/signInScreen.dart';
import 'package:projector/widgets/widgets.dart';

class ViewService {

  searchUser(email) async {
    var token = await UserData().getUserToken();
    // print(email);
    var body = json.encode({
      'token': token,
      'email': email,
    });
    var res = await http.post(
      Uri.parse('$serverUrl/searchCreatorByEmail'),
      body: body,
    );
    //print(res.body);
    if (res.statusCode == 200) {
      return json.decode(res.body);
    } else {
      return null;
    }
  }

  sendViewRequest(userId) async {
    var token = await UserData().getUserToken();
    var body = json.encode({
      'token': token,
      'users': userId,
    });
    var res = await http.post(
      Uri.parse('$serverUrl/sendViewRequest'),
      body: body,
    );
    // print("request ----->"+res.body);
    if (res.statusCode == 200) {
      return json.decode(res.body);
    } else {
      return null;
    }
  }

  updateRequestStatus(status, userId) async {
    //1 to accept and 2 to reject.............
    var token = await UserData().getUserToken();
    // print(token);
    // print(userId);
    var body = json.encode({
      'token': token,
      'status': status,
      'user': userId,
    });
    var res = await http.post(
      Uri.parse('$serverUrl/updateViewRequest'),
      body: body,
    );
    // print(res.body);
    if (res.statusCode == 200) {
      return json.decode(res.body);
    } else {
      return null;
    }
  }

  getAllViewRequests(status) async {
    //0 to new request , 1 to accepted requests , 2 to rejected reuqests......
    var token = await UserData().getUserToken();
    var body = json.encode({
      'token': token,
      'status': status,
    });
    var res = await http.post(
      Uri.parse('$serverUrl/getAllViewRequest'),
      body: body,
    );
    // print(res.body);
    if (res.statusCode == 200) {
      return json.decode(res.body)['data'];
    } else {
      return null;
    }
  }
   getAllViewRequestSent(status,context) async {
    //0 to new request , 1 to accepted requests , 2 to rejected requests , 3 to invitations
    var token = await UserData().getUserToken();
     print("token-->"+token);
    var body = json.encode({
      'token': token,
      'status': status,
      //'is_mobile': "1",
    });
    var res = await http.post(
      Uri.parse('$serverUrl/getAllViewRequestSent'),
      body: body,
    );
    //print(token);
    if (res.statusCode == 200) {
      return json.decode(res.body)['data'];
    } else if(res.statusCode == 401){
      navigateReplace(context, GuideScreens());
   }else{
      return null;
    }
  }

  getAllViewRequestSentNotification(status,context) async {
    //0 to new request , 1 to accepted requests , 2 to rejected requests , 3 to invitations
    var token = await UserData().getUserToken();
   // print("token-->"+token);
    var body = json.encode({
      'token': token,
      'status': status,
      'is_mobile': "1",
    });
    var res = await http.post(
      Uri.parse('$serverUrl/getAllViewRequestSent'),
      body: body,
    );
   // print("notification request-->${res.body}");
    if (res.statusCode == 200) {
      return json.decode(res.body)['data'];
    } else if(res.statusCode == 401){
      navigateReplace(context, GuideScreens());
    }else{
      return null;
    }
  }

    getMyNotifications() async {
      var token = await UserData().getUserToken();
      var body = json.encode({
        'token': token,
      });
      var res = await http.post(
        Uri.parse('$serverUrl/getMyNotifications'),
        body: body,
      );
      if (res.statusCode == 200) {
        return json.decode(res.body)['data'];
      } else {
        return null;
      }
    }

  getMyNotificationsLandingPage() async {
    var token = await UserData().getUserToken();
    var body = json.encode({
      'token': token,
    });
    var res = await http.post(
      Uri.parse('$serverUrl/getMyNotifications'),
      body: body,
    );
    if (res.statusCode == 200) {
      return json.decode(res.body);
    } else {
      return null;
    }
  }

  readNotification() async {
    var token = await UserData().getUserToken();
    var body = json.encode({
      'token': token,
      'read_all': true,
    });
    var res = await http.post(
      Uri.parse('$serverUrl/updateMyNotifications'),
      body: body,
    );
    if (res.statusCode == 200) {
      return json.decode(res.body);
    } else {
      return null;
    }
  }

  checkSubscription() async {
    var token = await UserData().getUserToken();
    var body = json.encode({
      'token': token
    });
    var res = await http.post(
      Uri.parse('$serverUrl/checkSubscription'),
      body: body,
    );
    // print(res.body);
    if (res.statusCode == 200) {
      return json.decode(res.body);
    } else {
      return null;
    }
  }

  checkStorage() async {
    var token = await UserData().getUserToken();
    var body = json.encode({
      'token': token
    });
    var res = await http.post(
      Uri.parse('$serverUrl/getMySubscription'),
      body: body,
    );
    // print(res.body);
    if (res.statusCode == 200) {
      return json.decode(res.body);
    } else {
      return null;
    }
  }
}
