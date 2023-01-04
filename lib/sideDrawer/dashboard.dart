import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:projector/apis/accountService.dart';
import 'package:projector/apis/subscriptionService.dart';
import 'package:projector/apis/videoService.dart';
import 'package:projector/apis/viewService.dart';
import 'package:projector/contents/contentViewScreen.dart';
import 'package:projector/data/checkConnection.dart';
import 'package:projector/data/userData.dart';
// import 'package:projector/getStartedScreen.dart';
import 'package:projector/sideDrawer/viewProfiePage.dart';
import 'package:projector/subscriptionScreen.dart';
import 'package:projector/uploading/addDetailsVideo.dart';
import 'package:projector/widgets/dialogs.dart';
// import 'package:projector/signInScreen.dart';
import '../widgets/widgets.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import '../uploading/selectVideo.dart';

class DashBoard extends StatefulWidget {
  @override
  _DashBoardState createState() => _DashBoardState();
}

StreamController subscriptionController = StreamController.broadcast();
String maxStorage = '0', maxReq = '0';
int reqSent = 0;
var diskUsed = 0;

class _DashBoardState extends State<DashBoard> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool loading = false;

  var subscriptionType;
  @override
  void initState() {
    //CheckConnectionService().init(_scaffoldKey);
    SubscriptionService().getMySubscription().then((data) {
      subscriptionController.add(data);
      // print(data);
      subscriptionType = data['subscription'];
      maxStorage = data['subscription']['max_storage_mb'];
      maxReq = data['subscription']['max_view_request_sent'];
      diskUsed = data['disk_used_mb'];
      reqSent = data['view_request_sent'];
      req = int.parse(maxReq) - reqSent;
    });

    super.initState();
  }

  var req;

  requestDialog(context, height, width) {
    String email = '';
    List users = [];
    List selectedUsers = [];
    List selectedUsersEmail = [];
    return showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          List<Widget> wids = [];
          List<Widget> bottom = [];

          for (var i = 0; i < selectedUsers.length; i++) {
            wids.add(ListTile(
              leading: CircleAvatar(
                child: Text(
                  selectedUsersEmail[i]
                      .toString()
                      .substring(0, 1)
                      .toUpperCase(),
                  style: GoogleFonts.poppins(
                    fontSize: 21.0,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ),
              title: Text('${selectedUsersEmail[i]}'),
            ));
          }

          for (var index = 0; index < users.length; index++) {
            bottom.add(ListTile(
              onTap: () {
                // print('object');
                // print(selectedUsers);
                // bool canReq = true;
                // print(req);

                if (maxReq == '-1' || req != 0) {
                  if (users[index]['status'] == '0') {
                    showConfirmDialog(context,
                        text:
                            "You already send an invitation to the user please wait till user accept");
                  } else if (users[index]['status'] == '1') {
                    showConfirmDialog(context,
                        text: "You already have an connection with the user ");
                  } else if (users[index]['status'] == '2') {
                    showConfirmDialog(context,
                        text: "Your invitation is rejected by the user ");
                  } else if (selectedUsers.contains(users[index]['id'])) {
                    if (maxReq != '-1') {
                      req += 1;
                      print(req);
                    }
                    setState(() {
                      selectedUsers.remove(users[index]['id']);
                      selectedUsersEmail.remove(users[index]['email']);
                    });
                  } else {
                    if (maxReq != '-1') {
                      req -= 1;
                      print(req);
                    }
                    setState(() {
                      selectedUsers.add(users[index]['id']);
                      selectedUsersEmail.add(users[index]['email']);
                    });
                  }
                } else {
                  Fluttertoast.showToast(
                      msg: 'You have completed your request');
                }
              },
              leading: CircleAvatar(
                backgroundColor: selectedUsers.contains(users[index]['id'])
                    ? Colors.grey
                    : Color(0xff14F47B),
                child: Text(
                  users[index]['email']
                      .toString()
                      .substring(0, 1)
                      .toUpperCase(),
                  style: GoogleFonts.poppins(
                    fontSize: 21.0,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ),
              title: Text('${users[index]['email']}'),
            ));
          }
          return Container(
            height: height * 0.5,
            width: width * 0.5,
            // color: Color(0xff333333).withOpacity(0.7),
            child: Dialog(
              backgroundColor: Colors.white.withOpacity(0),
              insetPadding: EdgeInsets.only(
                left: 20.0,
                right: 20.0,
                top: 60.0,
                bottom: 80.0,
              ),
              child: Container(
                width: width * 0.5,
                height: height * 0.54,
                padding: EdgeInsets.only(
                  left: 20,
                  right: 17.0,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.0),
                  border: Border.all(
                    color: Color(0xff707070),
                  ),
                ),
                child: Container(
                  // height: height * 0.2,
                  child: ListView(
                    // crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(height: 10),
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Color(0xff5AA5EF),
                            child: Image(
                              height: 24,
                              image: AssetImage('images/addPerson.png'),
                            ),
                          ),
                          SizedBox(width: 10),
                          Text(
                            'Request Access to View',
                            style: GoogleFonts.poppins(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: wids,
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        style: GoogleFonts.poppins(
                          fontSize: 15.0,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                        keyboardType: TextInputType.emailAddress,
                        // ignore: missing_return
                        onChanged: (val) async {
                          email = val;
                          var data = await ViewService().searchUser(email);
                          // print(data);
                          if (data['success'] == true) {
                            setState(() {
                              users = data['data'];
                            });
                          } else {
                            setState(() {
                              users = [];
                            });
                          }
                        },
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Color(0xffF8F9FA),
                          hintText: 'Search Email',
                          hintStyle: GoogleFonts.poppins(
                            fontSize: 15.0,
                            fontWeight: FontWeight.w400,
                            color: Color(0xff8E8E8E),
                          ),
                          border: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.white,
                              // width: 2,
                            ),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.white,
                              // width: 2,
                            ),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.white,
                              // width: 2,
                            ),
                          ),
                        ),
                      ),
                      Column(
                        children: bottom,
                      ),
                      SizedBox(height: height * 0.03),
                      Center(
                        child: Container(
                          alignment: Alignment.centerRight,
                          height: height * 0.06,
                          width: width * 0.3,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(7),
                          ),
                          child: ElevatedButton(
                            onPressed: () async {
                              setState(() {
                                loading = true;
                              });
                              var data;

                              for (var item in selectedUsers) {
                                data =
                                    await ViewService().sendViewRequest(item);
                                await UserData().setUserStarted();
                              }
                              // _scaffoldKey.currentState.removeCurrentSnackBar();
                              setState(() {
                                loading = false;
                              });
                              Navigator.pop(context, data);
                              // Navigator.pop(context, data);
                              // print('tapped');
                              // if (EmailValidator.validate(email)) {
                              //   if (users.length != 0) {
                              //     var data = await ViewService()
                              //         .sendViewRequest(users[0]['id']);
                              //     Navigator.pop(context, data);
                              //   } else {
                              //     var data = await ViewService()
                              //         .getAllViewRequestSent('1');
                              //   }
                              // }
                            },
                            child: Center(
                              child: Text(
                                'Done',
                                style: GoogleFonts.poppins(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 5)
                    ],
                  ),
                ),
              ),
            ),
          );
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    var title = 'Dashboard';

    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        drawer: DrawerList(title: title),
        body: ModalProgressHUD(
          inAsyncCall: loading,
          child: Container(
            color: Color.fromRGBO(242, 242, 242, 1),
            width: width,
            // padding: EdgeInsets.all(16.0),
            child: ListView(
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: height * 0.04),
                Padding(
                  padding: EdgeInsets.only(
                    left: 15.0,
                    right: 16.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: [
                          InkWell(
                            onTap: () {
                              _scaffoldKey.currentState.openDrawer();
                            },
                            child: Icon(
                              Icons.menu,
                              color: title == '' ? Colors.white : Colors.black,
                            ),
                          ),
                          SizedBox(width: width * 0.1),
                          InkWell(
                            onTap: () {
                              navigate(
                                context,
                                ContentViewScreen(
                                  myVideos: true,
                                  userId: '',
                                ),
                              );
                            },
                            child: Text(
                              'View My Content',
                              style: GoogleFonts.poppins(
                                fontSize: 15.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          InkWell(
                            onTap: () {
                              navigate(context, SelectVideoView());
                            },
                            child: Icon(
                              Icons.video_call,
                              size: 30,
                            ),
                          ),
                          SizedBox(width: 20),
                          InkWell(
                            onTap: () {
                              navigate(context, ViewProfilePage());
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: title == ''
                                        ? Colors.white
                                        : Colors.black),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Image(
                                  height: 20.0,
                                  color:
                                      title == '' ? Colors.white : Colors.black,
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
                ),
                Divider(
                  color: Color(0xffE5E5E5),
                  thickness: 1.0,
                ),
                SizedBox(height: height * 0.02),
                Padding(
                  padding: EdgeInsets.only(left: 16.0),
                  child: Text(
                    "Projector Dashboard",
                    style: GoogleFonts.poppins(
                      fontSize: 20.0,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),

                // FutureBuilder(
                //   future: AccountService().getProfile(),
                //   builder: (context, snapshot) {
                //     if (snapshot.hasData) {
                //       // print(snapshot.data);
                //       return Padding(
                //         padding: EdgeInsets.only(left: 16.0),
                //         child: Text(
                //           snapshot.data['email'],
                //           style: TextStyle(
                //             fontSize: 15.0,
                //             color: Colors.black,
                //             fontWeight: FontWeight.bold,
                //           ),
                //         ),
                //       );
                //     } else {
                //       return Center(
                //         child: CircularProgressIndicator(),
                //       );
                //     }
                //   },
                // ),
                SizedBox(height: height * 0.02),
                Padding(
                  padding: EdgeInsets.only(
                    left: 20.0,
                    right: 20.0,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(25.0),
                    child: Container(
                      padding: EdgeInsets.all(10),
                      child: DottedBorder(
                        dashPattern: [5, 5],
                        borderType: BorderType.RRect,
                        radius: Radius.circular(16),
                        padding: EdgeInsets.only(
                          left: 50,
                          right: 50,
                        ),
                        child: Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.video_call,
                                size: 44,
                              ),
                              Container(
                                width: width * 0.45,
                                // decoration: BoxDecoration(
                                //   border: Border.all(
                                //     color: Color(0xff1172D2),
                                //   ),
                                // ),
                                child: ElevatedButton(
                                  onPressed: () {
                                    // if (subscriptionType == 'Free') {
                                    //   Navigator.of(context).push(
                                    //     CupertinoPageRoute<Null>(
                                    //       builder: (BuildContext context) {
                                    //         return SubscriptionScreen();
                                    //       },
                                    //     ),
                                    //   );
                                    // } else
                                    Navigator.of(context).push(
                                      CupertinoPageRoute<Null>(
                                        builder: (BuildContext context) {
                                          return SelectVideoView();
                                        },
                                      ),
                                    );
                                  },
                                  child: Text(
                                    'UPLOAD VIDEO',
                                    style: GoogleFonts.poppins(
                                      fontSize: 15.0,
                                      color: Colors.white,
                                      // fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      height: height * 0.22,
                      width: width,
                      margin: const EdgeInsets.only(bottom: 6.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.0),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.29),
                            offset: Offset(0.0, 1.0), //(x,y)
                            blurRadius: 6.0,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: EdgeInsets.only(
                    left: 20.0,
                    right: 20.0,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(25.0),
                    child: Container(
                      child: Container(
                        padding: EdgeInsets.all(20),
                        // height: height * 0.22,
                        width: width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25.0),
                          color: Colors.white,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Video Analytics',
                              style: GoogleFonts.poppins(
                                fontSize: 20.0,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: height * 0.02),
                            FutureBuilder(
                              future: VideoService().getMyVideoList(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  // print(snapshot.data);
                                  return Container(
                                    // height: height * 0.08,
                                    child: snapshot.data.length == 0
                                        ? Text(
                                            'Upload the videos to see the views here',
                                            style: GoogleFonts.montserrat(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          )
                                        : Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    'Video',
                                                    style: TextStyle(
                                                      fontSize: 14.0,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  Text(
                                                    'Views',
                                                    style: TextStyle(
                                                      fontSize: 13.0,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: height * 0.01),
                                              ListView.builder(
                                                itemCount: snapshot.data.length,
                                                shrinkWrap: true,
                                                itemBuilder: (context, index) {
                                                  var title = snapshot
                                                      .data[index]['title'];
                                                  var views = snapshot
                                                      .data[index]['views'];
                                                  return Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 2),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          '$title',
                                                          style: TextStyle(
                                                            fontSize: 14.0,
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                        Text(
                                                          '$views',
                                                          style: TextStyle(
                                                            fontSize: 13.0,
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                },
                                              ),
                                            ],
                                          ),
                                  );
                                } else {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                      // height: height * 0.23,
                      width: width,
                      margin: EdgeInsets.only(bottom: 6.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25.0),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.29),
                            offset: Offset(0.0, 1.0), //(x,y)
                            blurRadius: 6.0,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: EdgeInsets.only(
                    left: 20.0,
                    right: 20.0,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(25.0),
                    child: Container(
                      child: Container(
                        padding: EdgeInsets.all(20),
                        height: height * 0.24,
                        width: width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25.0),
                          color: Colors.white,
                        ),
                        child: StreamBuilder(
                          stream: subscriptionController.stream,
                          builder: (context, data) {
                            if (data.hasData) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Storage',
                                    style: TextStyle(
                                      fontSize: 20.0,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: height * 0.01),
                                  maxStorage == null
                                      ? Text(
                                          'Projector storage: 1 TB (0 GB Available)',
                                          style: TextStyle(
                                            // fontSize: 20.0,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        )
                                      : Text(
                                          'Projector storage: 1 TB ( ${int.parse(maxStorage) / 1024} GB Available)',
                                          style: TextStyle(
                                            // fontSize: 20.0,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                  SizedBox(height: height * 0.01),
                                  Container(
                                    height: height * 0.03,
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Container(
                                            height: height * 0.03,
                                            color: Colors.blue,
                                            child: Center(
                                              child: Text(
                                                'Videos',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Container(
                                            height: height * 0.03,
                                            color: Colors.red,
                                            child: Center(
                                              child: Text(
                                                'Photos',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Container(
                                            height: height * 0.03,
                                            color: Colors.black,
                                            child: Center(
                                              child: maxStorage == null
                                                  ? Text(
                                                      '0 GB',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    )
                                                  : Text(
                                                      '${(int.parse(maxStorage) / 1024 - (diskUsed)).toStringAsFixed(0)} GB',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Center(
                                    child: Container(
                                      width: 100,
                                      height: height * 0.04,
                                      decoration: BoxDecoration(
                                        color: Color(0xffc9c9c9),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Center(
                                        child: Text(
                                          'Manage',
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  // SizedBox(height: height * 0.01),
                                ],
                              );
                            }
                            return Center(child: CircularProgressIndicator());
                          },
                        ),
                      ),
                      height: height * 0.23,
                      width: width,
                      margin: EdgeInsets.only(bottom: 6.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25.0),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.29),
                            offset: Offset(0.0, 1.0), //(x,y)
                            blurRadius: 6.0,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: EdgeInsets.only(
                    left: 20.0,
                    right: 20.0,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(25.0),
                    child: Container(
                      padding: EdgeInsets.all(20),
                      width: width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25.0),
                        color: Colors.white,
                      ),
                      child: Container(
                        padding: EdgeInsets.all(10),
                        width: width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.0),
                          color: Colors.white,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Viewers Pending',
                                  style: TextStyle(
                                    fontSize: 23.0,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    SubscriptionService()
                                        .getMySubscription()
                                        .then((data) {
                                      // print(data);
                                      if (data['subscription'] == 'Free')
                                        Navigator.of(context).push(
                                          CupertinoPageRoute<Null>(
                                            builder: (BuildContext context) {
                                              return SubscriptionScreen();
                                            },
                                          ),
                                        );
                                      else
                                        requestDialog(context, height, width);
                                    });
                                  },
                                  child: Container(
                                    height: 30,
                                    width: 25,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Color(0xff707070),
                                      ),
                                    ),
                                    child: Center(
                                      child: Icon(
                                        Icons.add,
                                        size: 18.0,
                                        color: Color(0xff5AA5EF),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            FutureBuilder(
                              future: ViewService().getAllViewRequests(0),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  var requests = [];
                                  snapshot.data.forEach((d) {
                                    if (d['status'] == '0') {
                                      requests.add(d);
                                    }
                                  });
                                  return requests.length == 0
                                      ? Container(
                                          height: height * 0.05,
                                          child: Center(
                                            child: Text(
                                              'No new requests',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        )
                                      : ListView.builder(
                                          itemCount: requests.length,
                                          shrinkWrap: true,
                                          itemBuilder: (context, index) {
                                            var userId = requests[index]['id'];
                                            var firstName =
                                                requests[index]['firstname'];
                                            var lastname =
                                                requests[index]['lastname'];
                                            var email =
                                                requests[index]['email'];
                                            return manageUserContent(
                                              name: '$firstName $lastname',
                                              email: '$email',
                                              accept: () async {
                                                setState(() {
                                                  loading = true;
                                                });
                                                var data = await ViewService()
                                                    .updateRequestStatus(
                                                        1, userId);
                                                if (data['success'] == true) {
                                                  showConfirmDialog(
                                                    context,
                                                    text: 'Request Accepted',
                                                  );
                                                }
                                                setState(() {
                                                  loading = false;
                                                });
                                              },
                                              reject: () async {
                                                setState(() {
                                                  loading = true;
                                                });
                                                var data = await ViewService()
                                                    .updateRequestStatus(
                                                        2, userId);
                                                if (data['success'] == true) {
                                                  showConfirmDialog(
                                                    context,
                                                    text: 'Request Rejected',
                                                  );
                                                }
                                                setState(() {
                                                  loading = false;
                                                });
                                              },
                                            );
                                          },
                                        );
                                } else {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                              },
                            ),
                            SizedBox(height: 20),
                            Text(
                              'All Viewers',
                              style: TextStyle(
                                fontSize: 23.0,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 10),
                            FutureBuilder(
                              future: ViewService().getAllViewRequests(1),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  var requests = [];
                                  snapshot.data.forEach((d) {
                                    if (d['status'] == '1') {
                                      requests.add(d);
                                    }
                                  });
                                  return requests.length == 0
                                      ? Container(
                                          height: height * 0.05,
                                          child: Center(
                                            child: Text(
                                              'No Viewers',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        )
                                      : ListView.builder(
                                          itemCount: requests.length,
                                          shrinkWrap: true,
                                          itemBuilder: (context, index) {
                                            var userId = requests[index]['id'];
                                            var firstName =
                                                requests[index]['firstname'];
                                            var lastname =
                                                requests[index]['lastname'];
                                            var email =
                                                requests[index]['email'];
                                            return Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "$firstName $lastname",
                                                  style: TextStyle(
                                                    fontSize: 16.0,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                Text(
                                                  email,
                                                  style: GoogleFonts.montserrat(
                                                    fontSize: 9.0,
                                                    color: Color(0xffB2B2B2),
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                } else {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                              },
                            ),
                            SizedBox(height: height * 0.05),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: height * 0.05),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
