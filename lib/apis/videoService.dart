import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:projector/constant.dart';
import 'package:projector/data/userData.dart';
import 'package:projector/login/GuideScreen.dart';
import 'package:projector/signInScreen.dart';
import 'package:projector/widgets/widgets.dart';

class VideoService {
  Dio dio = Dio();

  deleteCategory({catId}) async {
    var token = await UserData().getUserToken();
    var body = json.encode({
      'token': token,
      'catId': catId,
    });
    var res = await http.post(
      Uri.parse('$serverUrl/deleteMyCategory'),
      body: body,
    );
    // print(res.body);
    if (res.statusCode == 200) {
      return json.decode(res.body);
    } else {
      return [];
    }
  }

  deletePlaylist({playlistId}) async {
    var token = await UserData().getUserToken();
    print(playlistId);
    var body = json.encode({
      'token': token,
      'id': playlistId,
    });
    var res = await http.post(
      Uri.parse('$serverUrl/deleteMyPlayList'),
      body: body,
    );
    print(res.body);
    if (res.statusCode == 200) {
      return json.decode(res.body);
    } else {
      return [];
    }
  }

  deleteGroup({groupId}) async {
    var token = await UserData().getUserToken();
    var body = json.encode({
      'token': token,
      'id': groupId,
    });
    var res = await http.post(
      Uri.parse('$serverUrl/deleteMyGroups'),
      body: body,
    );
    print(res.body);
    if (res.statusCode == 200) {
      return json.decode(res.body);
    } else {
      return [];
    }
  }

  searchVideo(isMy, {id, key}) async {
    var token = await UserData().getUserToken();
    var userId = await UserData().getUserId();
    var body = json.encode({
      'token': token,
      'search_key': key,
      'user_id': isMy ? userId : id,
    });
    try {
      var res = await http.post(
        Uri.parse('$serverUrl/searchVideo'),
        body: body,
      );
      // print(res.body);
      if (res.statusCode == 200) {
        return json.decode(res.body);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  getMyVideoList() async {
    var token = await UserData().getUserToken();
    print(token);
    var body = json.encode({
      'token': token,
    });
    var res = await http.post(
      Uri.parse('$serverUrl/getMyVideosList'),
      body: body,
    );
    // print(res.body);
    if (res.statusCode == 200) {
      return json.decode(res.body)['data'];
    } else {
      return [];
    }
  }

  getMyContents() async {
    var token = await UserData().getUserToken();
    var body = json.encode({
      'token': token,
    });
    var res = await http.post(
      Uri.parse('$serverUrl/getMyContents'),
      body: body,
    );
    // print(res.body);
    if (res.statusCode == 200) {
      return json.decode(res.body)['data'];
    } else {
      return [];
    }
  }

  getMyContentsAll({sortBy}) async {
    // sort_by (date,status,category,name)
    var token = await UserData().getUserToken();
    var userId = await UserData().getUserId();
    var body = json.encode({
      'token': token,
      'user_id': userId,
      'order_by': "0",
      'sort_by': sortBy,
      'limit': "100",
      //'page': "1",
    });
    var res = await http.post(
      Uri.parse('$serverUrl/V1/getMyContentsBasedOnUploadDate'),
      body: body,
    );
    // print("contents --->"+res.body);
    if (res.statusCode == 200) {
      return json.decode(res.body)['data'];
    } else {
      return [];
    }
  }

  getVideoDetails(id) async {
    var token = await UserData().getUserToken();
    var body = json.encode({
      'token': token,
      'id': id,
    });
    var res = await http.post(
      Uri.parse('$serverUrl/getVideosDetail'),
      body: body,
    );
    //print("video detail-->"+res.body);
    if (res.statusCode == 200) {
      return json.decode(res.body)['data'];
    } else {
      return null;
    }
  }

  getVideoStatus({videoId}) async {
    var token = await UserData().getUserToken();
    var body = json.encode({
      'token': token,
      'video_id': videoId,
    });
    var res = await http.post(
      Uri.parse('$serverUrl/getvideoStatus'),
      body: body,
    );
    //print("video detail-->"+res.body);
    if (res.statusCode == 200) {
      return json.decode(res.body);
    } else {
      return null;
    }
  }

  addToPauseList({videoId, action}) async {
    var token = await UserData().getUserToken();
    var body = json.encode({
      'token': token,
      'video_id': videoId,
      'action': action,
    });
    var res = await http.post(
      Uri.parse('$serverUrl/addToPausedList'),
      body: body,
    );
    print(res.body);
    if (res.statusCode == 200) {
      return json.decode(res.body);
    } else {
      return null;
    }
  }

  updateVideoPaused({videoId, pausedTime}) async {
    var token = await UserData().getUserToken();
    var body = json.encode({
      'token': token,
      'video_id': videoId,
      'paused_at': pausedTime,
    });
    var res = await http.post(
      Uri.parse('$serverUrl/updateVideoPaused'),
      body: body,
    );
    if (res.statusCode == 200) {
      return json.decode(res.body);
    } else {
      return null;
    }
  }

  clearResumeList({userId}) async {
    var token = await UserData().getUserToken();
    var body = json.encode({
      'token': token,
      'user_id': userId
    });
    var res = await http.post(
      Uri.parse('$serverUrl/v2/clearResumeList'),
      body: body,
    );
    if (res.statusCode == 200) {
      return json.decode(res.body);
    } else {
      return null;
    }
  }

  getCurrentWatching() async {
    var token = await UserData().getUserToken();
    var body = json.encode({
      'token': token,
    });
    var res = await http.post(
      Uri.parse('$serverUrl/getCurrentlyWatching'),
      body: body,
    );
    var data = json.decode(res.body);
    if (data['success'] == true) {
      return data;
    } else {
      return [];
    }
  }

  updateWatchlist({action, videoId}) async {
    var token = await UserData().getUserToken();
    var body = json.encode({
      'token': token,
      'video_id': videoId,
      'action': action,
    });
    var res = await http.post(
      Uri.parse('$serverUrl/updateWatchList'),
      body: body,
    );
    var data = json.decode(res.body);

    if (data['success'] == true) {
      return data;
    } else {
      return [];
    }
  }

  getWatchlist(isMy, {id}) async {
    var token = await UserData().getUserToken();
    var userId = await UserData().getUserId();
    var body = json.encode({
      'token': token,
      'user_id': isMy ? userId : id,
    });
    var res = await http.post(
      Uri.parse('$serverUrl/getMyWatchList'),
      body: body,
    );
    var data = json.decode(res.body);
    if (data['success'] == true) {
      return data['videos'] ?? [];
    } else {
      return [];
    }
  }

  getMyFriendsCategory(userId, {categoryId}) async {
    var token = await UserData().getUserToken();
    var body = json.encode({
      'token': token,
      'user_id': userId,
      'category_id': categoryId,
    });
    var res = await http.post(
      Uri.parse('$serverUrl/getFrendsCategory'),
      body: body,
    );
   // print("category list--${res.body}");
    if (json.decode(res.body)['success'] == true) {
      return json.decode(res.body)['data'];
    } else {
      return [];
    }
  }

  getyFriendsPlaylist(userId) async {
    var token = await UserData().getUserToken();
    var body = json.encode({
      'token': token,
      'user_id': userId,
    });
    var res = await http.post(
      Uri.parse('$serverUrl/getFrendsPlaylist'),
      body: body,
    );
    if (json.decode(res.body)['success'] == true) {
      return json.decode(res.body)['data'];
    } else {
      return [];
    }
  }

  getMyFriendList(userId, type) async {
    // print(userId);
    var token = await UserData().getUserToken();
    var body = json.encode({
      "token": token,
      "user_id": userId,
    });
    var res = await http.post(
      Uri.parse('$serverUrl/getFreindVideosList'),
      body: body,
    );
    var data = json.decode(res.body);
    if (data['success'] == true) {
      if (type == 'resume')
        return data['CurrentlyWatching'];
      else if (type == 'playlist')
        return data['playlist'];
      else
        return data['videos'];
    } else {
      return [];
    }
  }

  addVideoContent(
      {title,
      description,
      status,
      categoryId,
      subCategoryId,
      playlistId,
      visibility,
      videoFile,
      videoId,
      thumbnail,
      customThumbnail,
      groupId}) async {
    var token = await UserData().getUserToken();
    Dio dio = new Dio();
    FormData formData;
    if (videoFile != null) {
      String fileName = videoFile.path.split('/').last;
      // if (thumbnail.length != 0) image = thumbnail.path.split('/').last;
      formData = FormData.fromMap({
        "token": token,
        "video_file":
            await MultipartFile.fromFile(videoFile.path, filename: fileName),
        "visibility": visibility,
        "category_id": categoryId,
        "subcategory_id": subCategoryId,
        "playlist_id": playlistId,
        "title": title,
        "description": description,
        "group_id": groupId,
        "publish_date": DateTime.now(),
        "video_id": videoId,
        "status": status,
        "thumbnails": thumbnail,
        "custom_thumbnails": customThumbnail,
      });
    } else {
      formData = FormData.fromMap({
        "token": token,
        "visibility": visibility,
        "category_id": categoryId,
        "subcategory_id": subCategoryId,
        "playlist_id": playlistId.join(","),
        "title": title,
        "description": description,
        "group_id": groupId.join(","),
        "publish_date": DateTime.now(),
        "video_id": videoId,
        "status": status,
        "thumbnails": thumbnail,
        "custom_thumbnails": customThumbnail,
      });
    }

    // print(formData.readAsBytes());
    var res = await dio.post(
      "$serverUrl/addVideoContnet",
      data: formData,
      onSendProgress: (sent, total){
        final progressTotal = sent / total * 100;
       var  totalProgressValue = progressTotal.round();
        print("loading value vieoservice--->"+totalProgressValue.toString());
      }
    );

   // print("upload video content 3 ------"+res.toString());

    if (res.statusCode == 200) {
      return res.data;
    } else {
      return null;
    }
  }

  getMyCategory({parentId}) async {
    // print(parentId);
    var token = await UserData().getUserToken();
    var body = json.encode({
      'token': token,
      'category_id': parentId,
    });
    var res = await http.post(
      Uri.parse('$serverUrl/getMyCategory'),
      body: body,
    );
     //print("categoryResponse-->"+res.body);
    if (json.decode(res.body)['success'] == true) {
      return json.decode(res.body)['data'];
    } else {
      return null;
    }
  }

  getMySubCategory({parentId}) async {
    // print(parentId);
    var token = await UserData().getUserToken();
    var body = json.encode({
      'token': token,
      'subcategory_id': parentId,
    });
    var res = await http.post(
      Uri.parse('$serverUrl/getMySubCategory'),
      body: body,
    );
   // print("subcategoryResponse-->"+res.body);
    if (json.decode(res.body)['success'] == true) {
      return json.decode(res.body);
    } else {
      return null;
    }
  }

  addEditCategory({title, parentId, categoryId, bgImageId}) async {
    var token = await UserData().getUserToken();
    var body = json.encode({
      'token': token,
      "category_id": categoryId,
      // "parent_id": parentId,
      "title": title,
      "description": "",
      "icon": bgImageId,
    });
    var res = await http.post(
      Uri.parse('$serverUrl/addEditCategory'),
      body: body,
    );
    print("add edit category ----" + res.body);
    if (res.statusCode == 200) {
      return json.decode(res.body);
    } else {
      return null;
    }
  }

  addEditSubCategory({title, categoryId}) async {
    var token = await UserData().getUserToken();
    var body = json.encode({
      'token': token,
      "subcategory_id": categoryId,
      // "parent_id": parentId,
      "title": title,
      "description": "",
      "icon": "",
    });
    var res = await http.post(
      Uri.parse('$serverUrl/addEditSubCategory'),
      body: body,
    );
     print("add edit sub category ----"+res.body);
    if (res.statusCode == 200) {
      return json.decode(res.body);
    } else {
      return null;
    }
  }

  getMyPlaylist() async {
    var token = await UserData().getUserToken();
    var body = json.encode({
      'token': token,
    });
    var res = await http.post(
      Uri.parse('$serverUrl/getMyPlaylist'),
      body: body,
    );
    var data = json.decode(res.body);
    if (data['success'] == true) {
      return data['data'];
    } else {
      return [];
    }
  }

  getCategoryVideos({categoryId}) async {
    var token = await UserData().getUserToken();
    var body = json.encode({'token': token, 'category_id': categoryId});
    var res = await http.post(
      Uri.parse('$serverUrl/getMyCategory'),
      body: body,
    );
    if (json.decode(res.body)['success'] == true) {
      return json.decode(res.body)['data'];
    } else {
      return null;
    }
  }

  getPlaylistVideos({playlistId}) async {
    var token = await UserData().getUserToken();
    var body = json.encode({'token': token, 'playlist_id': playlistId});
    var res = await http.post(
      Uri.parse('$serverUrl/getMyPlaylist'),
      body: body,
    );
    // print(res.body);
    if (json.decode(res.body)['success'] == true) {
      return json.decode(res.body)['data'];
    } else {
      return null;
    }
  }

  updatePlaylistVideoOrder({playlistId, items}) async {
    var token = await UserData().getUserToken();
    // print(token);
    var body = json.encode({
      'token': token,
      'playlist_id': playlistId,
      'items': items,
    });
    var res = await http.post(
      Uri.parse('$serverUrl/updatePlayListVideoOrder'),
      body: body,
    );
    // print(res.body);
    if (json.decode(res.body)['success'] == true) {
      return json.decode(res.body)['data'];
    } else {
      return null;
    }
  }

  updateCategoryVideoOrder({categoryId, items}) async {
    var token = await UserData().getUserToken();
    // print(token);
    var body = json.encode({
      'token': token,
      'category_id': categoryId,
      'items': items,
    });
    var res = await http.post(
      Uri.parse('$serverUrl/updateCategoryListVideoOrder'),
      body: body,
    );
    // print(res.body);
    if (json.decode(res.body)['success'] == true) {
      return json.decode(res.body)['data'];
    } else {
      return null;
    }
  }

  addEditPlaylist({title, playlistId}) async {
    var token = await UserData().getUserToken();
    var body = json.encode({
      'token': token,
      "playlist_id": playlistId,
      "title": title,
    });
    var res = await http.post(
      Uri.parse('$serverUrl/addEditPlaylist'),
      body: body,
    );
    // print(res.body);
    if (res.statusCode == 200) {
      return json.decode(res.body);
    } else {
      return null;
    }
  }

  updateCategoryOrder(items) async {
    // print(items);
    var token = await UserData().getUserToken();
    var body = json.encode({"token": token, "items": items});
    var res = await http.post(
      Uri.parse('$serverUrl/updateCategoryOrder'),
      body: body,
    );
    if (res.statusCode == 200) {
      return json.decode(res.body);
    } else {
      return null;
    }
  }

  updatePlaylistOrder(items) async {
    var token = await UserData().getUserToken();
    var body = json.encode({'token': token, "items": items});
    var res = await http.post(
      Uri.parse('$serverUrl/updatePlaylistOrder'),
      body: body,
    );
    // print(res.body);
    if (json.decode(res.body)['success'] == true) {
      return json.decode(res.body);
    } else {
      return null;
    }
  }

  getUserContentList(userId, context) async {
    // print(userId);
    var token = await UserData().getUserToken();
    var body = json.encode({
      "token": token,
      "user_id": userId,
    });
    var res = await http.post(
      Uri.parse('$serverUrl/getUserContents'),
      body: body,
    );
   // print("usercontents--->"+res.body);
    if (res.statusCode == 200) {
      var data = json.decode(res.body);
      // print("usercontents--->"+data);
      if (data['success'] == true) {
        return data['data'];
      } else {
        return [];
      }
    } else if (res.statusCode == 401) {
      navigateReplace(context, GuideScreens());
    } else {
      return null;
    }
  }

  getResumeWatchingList(userId) async {
    // print(userId);
    var token = await UserData().getUserToken();
    var body = json.encode({
      "token": token,
      "user_id": userId,
    });
    var res = await http.post(
      Uri.parse('$serverUrl/getMyPausedList'),
      body: body,
    );
    var data = json.decode(res.body);
    print("resume list--$data");
    if (data['success'] == true) {
      return data['paused'];
    } else {
      return [];
    }
  }

  getUserAllVideoList(userId) async {
    // print(userId);
    var token = await UserData().getUserToken();
    var body = json.encode({
      "token": token,
      "user_id": userId,
    });
    var res = await http.post(
      Uri.parse('$serverUrl/getUserVideoList'),
      body: body,
    );
    var data = json.decode(res.body);
    // print(data);
    if (data['success'] == true) {
      return data['data'];
    } else {
      return [];
    }
  }

  getCategoryDetail(userId, categoryId) async {
    // print(userId);
    var token = await UserData().getUserToken();
    var body = json.encode({
      "token": token,
      "user_id": userId,
      "category_id": categoryId,
    });
    var res = await http.post(
      Uri.parse('$serverUrl/getCategoryDetail'),
      body: body,
    );
    var data = json.decode(res.body);
    // print(data);
    if (data['success'] == true) {
      return json.decode(res.body);
    } else {
      return [];
    }
  }

  getAlbumDetails(id) async {
    var token = await UserData().getUserToken();
    var body = json.encode({
      'token': token,
      'album_id': id,
    });
    try {
      var res = await http.post(
        Uri.parse('$serverUrl/getMyAlbumDetail'),
        body: body,
      );
      if (res.statusCode == 200) {
        return json.decode(res.body)['data'];
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  getCategoryBackgroundImages() async {
    var token = await UserData().getUserToken();
    var body = json.encode({'token': token});
    try {
      var res = await http.post(
        Uri.parse('$serverUrl/getBackgroundImages'),
        body: body,
      );
      //print("get bg images --->"+res.body);
      if (res.statusCode == 200) {
        return json.decode(res.body)['data'];
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  deleteVideo({videoId}) async {
    var token = await UserData().getUserToken();
    var body = json.encode({
      'token': token,
      "video_id": videoId
    });
    var res = await http.post(
      Uri.parse('$serverUrl/deleteVideo'),
      body: body,
    );
     print("deletevideo--->"+res.body);
    if (res.statusCode == 200) {
      return json.decode(res.body);
    } else {
      return null;
    }
  }

  deleteAlbum({albumId}) async {
    var token = await UserData().getUserToken();
    var body = json.encode({
      'token': token,
      "album_id": albumId
    });
    var res = await http.post(
      Uri.parse('$serverUrl/deleteMyAlbum'),
      body: body,
    );
    // print("deletealbum--->"+res.body);
    if (res.statusCode == 200) {
      return json.decode(res.body);
    } else {
      return null;
    }
  }

}
