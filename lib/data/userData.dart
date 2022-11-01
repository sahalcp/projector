import 'package:shared_preferences/shared_preferences.dart';

class UserData {
  setUserLogged() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('logged', true);
  }

  getUserLogged() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('logged');
  }

  deleteUserLogged() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('logged', false);
    prefs.setBool('started', false);
    prefs.setString('token', null);
    prefs.setString('id', null);
    prefs.setString('videoId', null);
    prefs.setString('albumId', null);

  }

  setUserToken(token) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('token', token);
  }
  getUserToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }
  setUserId(id) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('id', id);
  }
  getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('id');
  }

  setUserStarted({started}) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('started', started);
  }

  getUserStarted() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('started');
  }

  setAlbumId(albumId) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('albumId', albumId);
  }

  getAlbumId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('albumId');
  }

  setVideoId(id) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('videoId', id);
  }
  getVideoId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('videoId');
  }


  setAlbumTitle(title) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('albumTitle', title);
  }
  getAlbumTitle() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('albumTitle');
  }

  setAlbumDescription(description) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('albumDescription', description);
  }

  getAlbumDescription() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('albumDescription');
  }

  setFirstName(firstName) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('firstName', firstName);
  }
  getFirstName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('firstName');
  }

  setCategoryId(id) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('id', id);
  }
  getCategoryId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('id');
  }

  setCategoryName(categoryName) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('categoryName', categoryName);
  }
  getCategoryName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('categoryName');
  }

  isFirstLaunchShowCaseChooseProjectorPage() async {
    final prefs = await SharedPreferences.getInstance();

    bool isFirstLaunch = prefs.getBool("choose_projector") ?? true;

    if(isFirstLaunch)
      prefs.setBool("choose_projector", false);

    return isFirstLaunch;
  }

}
