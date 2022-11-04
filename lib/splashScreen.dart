import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:new_version/new_version.dart';
import 'package:projector/data/userData.dart';
import 'package:projector/getStartedScreen.dart';
import 'package:projector/login/GuideScreen.dart';
import 'package:projector/sideDrawer/dashboard.dart';
import 'package:projector/sideDrawer/listVideo.dart';
import 'package:projector/signInScreen.dart';
import 'package:projector/startWatching.dart';
import 'package:projector/style.dart';
import 'package:projector/widgets/logo.dart';
import 'package:projector/widgets/versionUpdateDialogBox.dart';
import 'package:projector/widgets/widgets.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  var  status;
  @override
  void initState() {
    if (Platform.isIOS) {
     // _checkVersion();
      _goToScreen();
    }else if (Platform.isAndroid){
      _goToScreen();
    }


    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.height;

    return Sizer(builder: (context, orientation, deviceType){
      return Scaffold(
        //backgroundColor: Color(0xff14141E),
        backgroundColor: appBgColor,
        body: Container(
          height: height,
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                //LogoExpanded(width: width)
                Image(
                  height:deviceType == DeviceType.mobile? 350 : 600,
                  width: deviceType == DeviceType.mobile? 350 : 600,
                  image: AssetImage('images/splash_anim_1080.gif'),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  void _checkVersion() async{

    final newVersion = NewVersion(
      androidId: "com.projectorllc.projectorapp",

    );



     status = await newVersion.getVersionStatus();
    if(status.canUpdate){
     // update Dialog
      showDialog(context: context,
          barrierDismissible: false,
          builder: (BuildContext context){
            return VersionUpdateDialogBox(
              title: "",
              descriptions: "",
              text: "",
              updateButtonClick: (){
                launch(status.appStoreLink);
              },
              cancelButtonClick: (){
                Navigator.pop(context);
                _goToScreen();
              },
            );
          }
      );

    }else{
      _goToScreen();
    }

    print("UPDATE : ${status.canUpdate}");
    print("DEVICE : ${status.localVersion}");
    print("STORE : ${status.storeVersion}");
    print("STORE LINK : ${status.appStoreLink}");

  }
  void _goToScreen(){
    Future.delayed(Duration(seconds: 5), () {
      UserData().getUserLogged().then((data) {
        try {
          if (data) {
            // UserData().getUserStarted().then((started) {
            //   try {
            //     if (started)

            navigateReplace(context, StartWatchingScreen());


            //   else
            //     navigateReplace(context, GetStartedScreen());
            // } catch (e) {
            //   navigateReplace(context, GetStartedScreen());
            // }
            // });
          } else {

           // navigateReplace(context, SignInScreen());
            navigateReplace(context, GuideScreens());
          }
        } catch (e) {
          navigateReplace(context, GuideScreens());
        }
      });
    });
  }


}
