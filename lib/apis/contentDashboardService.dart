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

  deleteMemberFromGroup({groupId,users}) async {
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

  getVideoAndAlbumOfUser({groupId}) async {
    var token = await UserData().getUserToken();
    var userId = await UserData().getUserId();
    var body = json.encode({'token': token,
      'user_id' : userId,
      'group_id' : groupId
    });
    var res = await http.post(
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
}
