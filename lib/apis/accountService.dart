import 'package:http/http.dart' as http;
import 'package:projector/constant.dart';
import 'dart:convert';

import 'package:projector/data/userData.dart';

class AccountService {

  getProfile() async {
    var token = await UserData().getUserToken();
    var body = json.encode({'token': token});
    var res = await http.post(
     Uri.parse( '$serverUrl/getMyProfile'),
      body: body,
    );
    var data = json.decode(res.body);
    //print("get profile image"+res.body);
    if (res.statusCode == 200) {
      return data['data'];
    } else {
      return null;
    }
  }

  updateProfile({mobile}) async {
    var token = await UserData().getUserToken();
    var body = json.encode({
      'token': token,
      'mobile': mobile,
      "country_code": "+91",
    });
    var res = await http.post(
      Uri.parse('$serverUrl/updateMyProfile'),
      body: body,
    );
    //print(res.body);
    if (res.statusCode == 200) {
      return json.decode(res.body);
    } else {
      return null;
    }
  }

  updateImage({mobile, image}) async {
    // print(image);
    print(mobile);
    var token = await UserData().getUserToken();
    var body = json.encode({
      'token': token,
      'mobile': mobile,
      "country_code": "+91",
      "image": "data:image/png;base64" + image,
    });
    var res = await http.post(
      Uri.parse('$serverUrl/updateMyProfile'),
      body: body,
    );
    print(res.body);
    if (res.statusCode == 200) {
      return json.decode(res.body);
    } else {
      return null;
    }
  }

  updateProfileImage({image}) async {
    // print(image);
    var token = await UserData().getUserToken();
    var body = json.encode({
      'token': token,
      "image": "data:image/png;base64," + image,
    });
    var res = await http.post(
      Uri.parse('$serverUrl/updateProfileImge'),
      body: body,
    );
    print("profile image"+res.body);
    if (res.statusCode == 200) {
      return json.decode(res.body);
    } else {
      return null;
    }
  }

  updateEmailRequest() async {
    var token = await UserData().getUserToken();
    // print(token);
    var body = json.encode({
      'token': token,
    });
    var res = await http.post(
      Uri.parse('$serverUrl/changeEmailRequest'),
      body: body,
    );
    // print(res.body);
    if (res.statusCode == 200) {
      return json.decode(res.body);
    } else {
      return null;
    }
  }

  updatePassword(oldPassword, newPassword) async {
    var token = await UserData().getUserToken();
    // print(token);
    var body = json.encode({
      'token': token,
      'old_password': oldPassword,
      'new_password': newPassword,
    });
    var res = await http.post(
      Uri.parse('$serverUrl/updatePassword'),
      body: body,
    );
    // print(res.body);
    if (res.statusCode == 200) {
      return json.decode(res.body);
    } else {
      return null;
    }
  }

  updateNotifications({email, sub, phone, push}) async {
    var token = await UserData().getUserToken();
    // print(token);
    var body = json.encode({
      'token': token,
      "email_notification": email,
      "sub_notification": sub,
      "phone_notification": phone,
      "push_notification": push,
    });
    var res = await http.post(
      Uri.parse('$serverUrl/updateMyProfile'),
      body: body,
    );
    // print(res.body);
    if (res.statusCode == 200) {
      return json.decode(res.body);
    } else {
      return null;
    }
  }

  removeUser({id}) async {
    var token = await UserData().getUserToken();
    var body = json.encode({
      'token': token,
      'id': id,
    });
    var res = await http.post(
      Uri.parse('$serverUrl/deleteFromViewer'),
      body: body,
    );
    if (res.statusCode == 200) {
      return json.decode(res.body);
    } else {
      return [];
    }
  }

  acceptOrDeclineUser({userId, status}) async {
    //1 to accept request , 2 to decline requests
    var token = await UserData().getUserToken();
    var body = json.encode({
      'token': token,
      'id': userId,
      'status': status,
    });
    var res = await http.post(
      Uri.parse('$serverUrl/deleteFromViewer'),
      body: body,
    );

    print("accept_decline---${res.body}");
    if (res.statusCode == 200) {
      return json.decode(res.body);
    } else {
      return null;
    }
  }

  removeNotification({id, status}) async {
    var token = await UserData().getUserToken();
    var body = json.encode({
      'token': token,
      'id': id,
      'status': status,
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

  removeAllNotification() async {
    var token = await UserData().getUserToken();
    var body = json.encode({
      'token': token,
    });
    var res = await http.post(
      Uri.parse('$serverUrl/deleteAllMyNotifications'),
      body: body,
    );
    // print("123"+res.body);
    if (res.statusCode == 200) {
      return json.decode(res.body);
    } else {
      return null;
    }
  }
}
