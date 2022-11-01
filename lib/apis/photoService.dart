import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:projector/constant.dart';
import 'package:projector/data/userData.dart';

class PhotoService {
  addAlbum({title, description, icon, albumId}) async {
    var token = await UserData().getUserToken();
    var body = json.encode({
      'token': token,
      'title': title,
      'description': description,
      'icon': icon,
      'album_id': albumId,
    });
    var res = await http.post(
      Uri.parse('$serverUrl/addEditAlbum'),
      body: body,
    );
   // print(res.body);
    if (res.statusCode == 200) {
      return json.decode(res.body);
    } else {
      return null;
    }
  }

  getMyAlbum({userId}) async {
    var token = await UserData().getUserToken();
    var body = json.encode({
      'token': token,
      'user_id': userId,
    });
    var res = await http.post(
      Uri.parse('$serverUrl/getMyAlbum'),
      body: body,
    );
    if (json.decode(res.body)['success'] == true) {
      return json.decode(res.body)['data'];
    } else {
      return [];
    }
  }

  getAlbumStatus({albumId}) async {
    var token = await UserData().getUserToken();
    var body = json.encode({
      'token': token,
      'album_id': albumId,
    });
    var res = await http.post(
      Uri.parse('$serverUrl/getAlbumStatus'),
      body: body,
    );
    //print("video detail-->"+res.body);
    if (res.statusCode == 200) {
      return json.decode(res.body);
    } else {
      return null;
    }
  }

  getMyAlbumDetail({albumId}) async {
    var token = await UserData().getUserToken();
    var body = json.encode({
      'token': token,
      'album_id': albumId,
    });
    var res = await http.post(
      Uri.parse('$serverUrl/getMyAlbumDetail'),
      body: body,
    );
    if (json.decode(res.body)['success'] == true) {
      return json.decode(res.body)['data'];
    } else {
      return [];
    }
  }

  addPhotoContent({
    visibility,
    photoFile,
    albumId
  }) async {
    var token = await UserData().getUserToken();
    Dio dio = new Dio();
    FormData formData;
    formData = FormData.fromMap({
      "token": token,
      "photo_file[]": photoFile,
      "visiblity": visibility,
      "album_id": albumId,
    });

    // print(formData.readAsBytes());
    var res = await dio.post(
      "$serverUrl/addPhotoContent",
      data: formData,
    );
    //print("photores-->"+res.data);

    if (res.statusCode == 200) {
      return res.data;
    } else {
      return null;
    }
  }

}
