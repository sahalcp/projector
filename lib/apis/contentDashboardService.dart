import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:projector/constant.dart';
import 'package:projector/data/userData.dart';
import 'package:projector/models/group/groupListVideoAlbumModel.dart';

class ContentDashboardService {
  getViewersList() async {
    var token = await UserData().getUserToken();
    var body = json.encode({'token': token});
    var res = await http.post(
      Uri.parse('$serverUrl/getViewersList'),
      body: body,
    );
    //print(res.body);
    if (res.statusCode == 200) {
      return json.decode(res.body)['data'];
    } else {
      return null;
    }
  }

  getPendingViewersList() async {
    var token = await UserData().getUserToken();
    var body = json.encode({'token': token});
    var res = await http.post(
      Uri.parse('$serverUrl/getPendingViewersList'),
      body: body,
    );
    //print(res.body);
    if (res.statusCode == 200) {
      return json.decode(res.body)['data'];
    } else {
      return null;
    }
  }

  deleteViewer({userId}) async {
    var token = await UserData().getUserToken();
    var body = json.encode({'token': token, 'id': userId});
    var res = await http.post(
      Uri.parse('$serverUrl/deleteMyViewer'),
      body: body,
    );
    //print(res.body);
    if (res.statusCode == 200) {
      return json.decode(res.body);
    } else {
      return null;
    }
  }

  cancelInvitation({email}) async {
    var token = await UserData().getUserToken();
    var body = json.encode({'token': token, 'email': email});
    var res = await http.post(
      Uri.parse('$serverUrl/cancelInvitation'),
      body: body,
    );
    //print(res.body);
    if (res.statusCode == 200) {
      return json.decode(res.body);
    } else {
      return null;
    }
  }

  getSuccessorsList() async {
    var token = await UserData().getUserToken();
    var body = json.encode({'token': token});
    var res = await http.post(
      Uri.parse('$serverUrl/getMySucessors'),
      body: body,
    );
    //print(res.body);
    if (res.statusCode == 200) {
      return json.decode(res.body)['data'];
    } else {
      return null;
    }
  }

  deleteSuccessor({userId}) async {
    var token = await UserData().getUserToken();
    var body = json.encode({'token': token, 'user_id': userId});
    var res = await http.post(
      Uri.parse('$serverUrl/removeSuccessor'),
      body: body,
    );
    if (res.statusCode == 200) {
      return json.decode(res.body);
    } else {
      return null;
    }
  }

  searchUserInvite({email}) async {
    var token = await UserData().getUserToken();
    // print(email);
    var body = json.encode({
      'token': token,
      'email': email,
    });
    var res = await http.post(
      Uri.parse('$serverUrl/searchUserToInvite'),
      body: body,
    );
    //print(res.body);
    if (res.statusCode == 200) {
      return json.decode(res.body);
    } else {
      return null;
    }
  }

  searchUserSuccessor({email}) async {
    var token = await UserData().getUserToken();
    // print(email);
    var body = json.encode({
      'token': token,
      'email': email,
    });
    var res = await http.post(
      Uri.parse('$serverUrl/searchUserByEmailFromFrendList'),
      body: body,
    );
    //print(res.body);
    if (res.statusCode == 200) {
      return json.decode(res.body);
    } else {
      return null;
    }
  }

  addSuccessors({user}) async {
    var token = await UserData().getUserToken();
    var body = json.encode({
      'token': token,
      'user': user,
    });
    var res = await http.post(
      Uri.parse('$serverUrl/addSuccessor'),
      body: body,
    );
    // print("request successor ----->"+res.body);
    if (res.statusCode == 200) {
      return json.decode(res.body);
    } else {
      return null;
    }
  }

  addViewers({data}) async {
    var token = await UserData().getUserToken();
    var body = json.encode({
      'token': token,
      'data': data,
    });
    var res = await http.post(
      Uri.parse('$serverUrl/addViewer'),
      body: body,
    );
    // print("request successor ----->"+res.body);
    if (res.statusCode == 200) {
      return json.decode(res.body);
    } else {
      return null;
    }
  }

  getContentType() async {
    var token = await UserData().getUserToken();
    var body = json.encode({'token': token});
    var res = await http.post(
      Uri.parse('$serverUrl/getContentType'),
      body: body,
    );
    //print(res.body);
    if (res.statusCode == 200) {
      return json.decode(res.body)['data'];
    } else {
      return null;
    }
  }

  reOrderContentType(items) async {
    var token = await UserData().getUserToken();
    var body = json.encode({'token': token, "items": items});
    var res = await http.post(
      Uri.parse('$serverUrl/reOrderMyContentType'),
      body: body,
    );
    //print(res.body);
    if (res.statusCode == 200) {
      return json.decode(res.body);
    } else {
      return null;
    }
  }

  updatePhotoAlbumOrder(items) async {
    var token = await UserData().getUserToken();
    var body = json.encode({'token': token, "items": items});
    var res = await http.post(
      Uri.parse('$serverUrl/reOrderMyAlbum'),
      body: body,
    );
    // print(res.body);
    if (json.decode(res.body)['success'] == true) {
      return json.decode(res.body);
    } else {
      return null;
    }
  }

  reOrderPhotosList(items) async {
    var token = await UserData().getUserToken();
    var body = json.encode({'token': token, "items": items});
    var res = await http.post(
      Uri.parse('$serverUrl/reOrderMyPhotos'),
      body: body,
    );
    // print(res.body);
    if (json.decode(res.body)['success'] == true) {
      return json.decode(res.body);
    } else {
      return null;
    }
  }

  deleteSubCategory({subCatId}) async {
    var token = await UserData().getUserToken();
    var body = json.encode({
      'token': token,
      'subCatId': subCatId,
    });
    var res = await http.post(
      Uri.parse('$serverUrl/deleteMySubCategory'),
      body: body,
    );
    if (res.statusCode == 200) {
      return json.decode(res.body);
    } else {
      return [];
    }
  }

  deleteMemberFromGroup({groupId, users}) async {
    var token = await UserData().getUserToken();
    var body = json.encode({
      'token': token,
      'group_id': groupId,
      'users': users,
    });
    var res = await http.post(
      Uri.parse('$serverUrl/removeMemberFromGroup'),
      body: body,
    );
    if (res.statusCode == 200) {
      return json.decode(res.body);
    } else {
      return [];
    }
  }

  /// Fetch user's all videos and albums
  Future<dynamic> getVideoAndAlbumOfUser() async {
    final token = await UserData().getUserToken();
    final userId = await UserData().getUserId();
    final body = json.encode({'token': token, 'user_id': userId});
    final res = await http.post(
      Uri.parse('$serverUrl/getVideosAndALbumsOfUser'),
      body: body,
    );

    if (res.statusCode == 200) {
      // return json.decode(res.body);
      return GroupListVideoAlbumModel.fromJson(json.decode(res.body));
    } else {
      return null;
    }
  }

  /// Fetch user's Video and Album of respective group id.
  Future<dynamic> getVideoAndAlbumsOfGroup({String groupId}) async {
    try {
      final token = await UserData().getUserToken();
      final body = json.encode({'token': token, 'group_id': groupId});
      final req = await http.post(
        Uri.parse('$serverUrl/getVideosAndALbumsOfGroup'),
        body: body,
      );

      if (req.statusCode == 200) {
        return GroupListVideoAlbumModel.fromJson(json.decode(req.body));
      } else {
        return null;
      }
    } catch (e) {
      print(e.toString());
    }
  }

  /// Fetch User's slideshow settings from the API
  Future<Map<String, dynamic>> getSlideshowSettings() async {
    try {
      final token = await UserData().getUserToken();
      final body = json.encode({'token': token});
      final req = await http.post(
        Uri.parse('$serverUrl/getAlbumSettings'),
        body: body,
      );

      if (req.statusCode == 200) {
        return json.decode(req.body);
      } else {
        return {"error": "An error occured while fetching slideshow settings"};
      }
    } catch (e) {
      print(e.toString());
      return {"error": "An unknown error occured"};
    }
  }

  /// Save User's slideshow settings to the API
  Future<bool> saveSlideshowSettings(
      {int slideshowSpeed, String slideshowTransition}) async {
    try {
      final token = await UserData().getUserToken();
      final body = json.encode({
        'token': token,
        "value1": "$slideshowSpeed",
        "value2": slideshowTransition,
        "settingId1": 1,
        "settingId2": 2,
      });
      final req = await http.post(
        Uri.parse('$serverUrl/updateAllAlbumSettings'),
        body: body,
      );

      if (req.statusCode == 200) {
        final result = json.decode(req.body);
        return result['success'];
      } else {
        return false;
      }
    } catch (e) {
      print(e.toString());
      return false;
    }
  }
}
