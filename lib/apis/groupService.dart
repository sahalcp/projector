import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:projector/constant.dart';
import 'package:projector/data/userData.dart';

class GroupServcie {

   addNewGroup(String title, File image) async {
    var token = await UserData().getUserToken();
    // print(token);
    // print(title);
    List<int> imageBytes;
    String base64Image;
    if (image != null) {
      imageBytes = image.readAsBytesSync();
      base64Image = Base64Encoder().convert(imageBytes);
    }
    var body = json.encode({
      'token': token,
      'title': title,
      'image':
          base64Image != null ? ('data:image/gif;base64,' + base64Image) : ''
    });
    var res = await http.post(
      Uri.parse('$serverUrl/addNewGroup'),
      body: body,
    );
    // print(res.body);
    if (res.statusCode == 200) {
      return json.decode(res.body);
    } else {
      return null;
    }
  }
  getMyGroups() async {
    var token = await UserData().getUserToken();
    // print(token);
    var body = json.encode({
      'token': token,
    });
    var res = await http.post(
      Uri.parse('$serverUrl/getMyGroups'),
      body: body,
    );
    // print(res.body);
    if (res.statusCode == 200 && json.decode(res.body)['success']==true) {
      return json.decode(res.body)['data'];
    } else {
      return [];
    }
  }

  searchUserFriendList(email) async {
    var token = await UserData().getUserToken();
    // print(token);
    var body = json.encode({'token': token, 'email': email});
    var res = await http.post(
      Uri.parse('$serverUrl/searchUserByEmailFromFrendList'),
      body: body,
    );
    // print(res.body);
    if (res.statusCode == 200) {
      return json.decode(res.body);
    } else {
      return null;
    }
  }
  addMembersToGroup(groupId,userId) async {
    var token = await UserData().getUserToken();
    // print(token);
    var body = json.encode({'token': token, 'group_id': groupId,'users':userId});
    var res = await http.post(
      Uri.parse('$serverUrl/addMemberToGroup'),
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
