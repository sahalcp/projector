import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projector/sideDrawer/viewProfiePage.dart';
import 'package:projector/startWatching.dart';
import 'package:projector/widgets/commingSoon.dart';
import 'package:projector/widgets/widgets.dart';

import 'apis/accountService.dart';

class GetStartedScreen extends StatefulWidget {
  @override
  _GetStartedScreenState createState() => _GetStartedScreenState();
}

class _GetStartedScreenState extends State<GetStartedScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
String image;
  @override
  void initState() {
     AccountService().getProfile().then((data) {
      // print(data);
      setState(() {
        image = data['image'];
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    String title = '';
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        drawer: DrawerList(
          title: '',
        ),
        body: Container(
          color: Color(0xff1A1D2A),
          width: width,
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              SizedBox(height: height * 0.02),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Image(
                    height: 40,
                    image: AssetImage('images/logoIcon.png'),
                  ),
                  Row(
                    children: [
                      InkWell(
                        onTap: () {
                          commingSoonDialog(context);
                          // navigateLeft(context, SelectVideoView());
                        },
                        child: Icon(
                          Icons.video_call,
                          color: Colors.white,
                          size: 38,
                        ),
                      ),
                      SizedBox(width: 20),
                      InkWell(
                        onTap: () {
                          navigate(context, ViewProfilePage());
                        },
                        child: image != null
                            ? CircleAvatar(
                                backgroundColor: Colors.white,
                                radius: 21,
                                child: CircleAvatar(
                                  radius: 20,
                                  backgroundImage: NetworkImage(image),
                                ),
                              )
                            : Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                                color:
                                    title == '' ? Colors.white : Colors.black),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Image(
                              height: 24.0,
                              color: title == '' ? Colors.white : Colors.black,
                              image: AssetImage(
                                'images/person.png',
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: height * 0.025),
              Text(
                'LET’S GET \nYOU STARTED',
                style: GoogleFonts.montserrat(
                  fontSize: 33.0,
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: height * 0.1),
              InkWell(
                onTap: () {
                  // getMySubscription().then((data) {
                  //   print(data);
                  //   if (data['subscription'] == 'Free')
                  //     Navigator.of(context).push(
                  //       CupertinoPageRoute<Null>(
                  //         builder: (BuildContext context) {
                  //           return SubscriptionScreen();
                  //         },
                  //       ),
                  //     );
                  //   else
                  // Navigator.of(context).push(
                  //   CupertinoPageRoute<Null>(
                  //     builder: (BuildContext context) {
                  //       return SelectVideoView();
                  //     },
                  //   ),
                  // );
                  // });
                  commingSoonDialog(context);
                },
                child: Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: 30.0,
                  ),
                  height: height * 0.2,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(
                      width: 3.0,
                      color: Color(0xff5AA5EF),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image(
                        height: height * 0.08,
                        image: AssetImage('images/gallery.png'),
                      ),
                      Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Text(
                          'Start creating and \nuploading your content!',
                          style: GoogleFonts.montserrat(
                            fontSize: 11.0,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(height: height * 0.02),
              InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    CupertinoPageRoute<Null>(
                      builder: (BuildContext context) {
                        return StartWatchingScreen();
                      },
                    ),
                  );
                  // navigate(context, StartWatchingScreen());
                },
                child: Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: 30.0,
                  ),
                  height: height * 0.2,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(
                      width: 3.0,
                      color: Color(0xff5AA5EF),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image(
                        height: height * 0.08,
                        image: AssetImage('images/lock.png'),
                      ),
                      Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Text(
                          'Join or request access to\nwatch content!',
                          style: GoogleFonts.montserrat(
                            fontSize: 11.0,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
