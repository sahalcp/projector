import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:projector/constant.dart';
import 'package:projector/data/userData.dart';

class AuthService {
  signUpEmail(email) async {
    var body = json.encode({'email': email});
    var res = await http.post(
      Uri.parse('$serverUrl/signupEmail'),
      body: body,
    );
    //print("signupEmail-->"+res.body);
    if (res.statusCode == 200) {
      return json.decode(res.body);
    } else {
      return null;
    }
  }

  signInEmail(email) async {
    var body = json.encode({'email': email});
    var res = await http.post(
      Uri.parse('$serverUrl/signinEmail'),
      body: body,
    );
    print("sign in email --->"+res.body);
    if (res.statusCode == 200) {
      return json.decode(res.body);
    } else {
      return null;
    }
  }

  signUp({email, password, firstName, lastName}) async {
    var body = json.encode({
      'email': email,
      'password': password,
      'firstname': firstName,
      'lastname': lastName,
    });
    var res = await http.post(
      Uri.parse('$serverUrl/v4/signup'),
      body: body,
    );
    print("signup-->"+res.body);
    if (res.statusCode == 200) {
      return json.decode(res.body);
    } else {
      return null;
    }
  }

  // device_type 1=(web), 2=(mobile), 3=(tv)
  signIn(email, password) async {
    var body = json.encode({
      'email': email,
      'password': password,
      //'is_mobile': true,
      //'devType': "Ios",
      'device_type': "2",
    });
    var res = await http.post(
      Uri.parse('$serverUrl/v4/signin'),
      body: body,
    );
    print("signin-->"+res.body);
    return json.decode(res.body);
    // if (res.statusCode == 200) {
    //   return json.decode(res.body);
    // } else {
    //   return null;
    // }
  }

  getEmailVerifyStatus({email}) async {
    //var Usertoken = await UserData().getUserToken();
    var body = json.encode({"email": email});
    var res = await http.post(
      Uri.parse('$serverUrl/v4/getEmailVerifyStatus'),
      body: body,
    );
    print("generateVerify status-->"+res.body);
    return json.decode(res.body);
  }

  generateVerificationCode({email}) async {
    var body = json.encode({'email': email});
    var res = await http.post(
      Uri.parse('$serverUrl/v2/generateVerificationCode'),
      body: body,
    );
    print("generateVerificationCode-->"+res.body);
    return json.decode(res.body);
  }

  forgotPassword(email) async {
    var body = json.encode({
      'email': email,
    });
    var res = await http.post(
      Uri.parse('$serverUrl/forgotPasswordEmail'),
      body: body,
    );
    // print(res.body);
    if (res.statusCode == 200) {
      return json.decode(res.body);
    } else {
      return null;
    }
  }

  updatePassword(email, code, password) async {
    var body = json.encode({
      'email': email,
      "reset_code": code,
      "password": password,
    });
    var res = await http.post(
      Uri.parse('$serverUrl/updatePasswordWithCode'),
      body: body,
    );
    if (res.statusCode == 200) {
      return json.decode(res.body);
    } else {
      return null;
    }
  }

  getTokenFromWeb({code}) async {
    var body = json.encode({
      'code': code,
    });
    var res = await http.post(
      Uri.parse('$serverUrl/getUserDetFrmCode'),
      body: body,
    );
    print("code from web--"+res.body);
    if (res.statusCode == 200) {
      return json.decode(res.body);
    } else {
      return null;
    }
  }

  tvLogin({code}) async {
    var token = await UserData().getUserToken();
    var body = json.encode({
      'token': token,
      'code': code,
    });
    var res = await http.post(
      Uri.parse('$serverUrl/registerTv'),
      body: body,
    );
    if (res.statusCode == 200) {
      return json.decode(res.body);
    } else {
      return null;
    }
  }

}
