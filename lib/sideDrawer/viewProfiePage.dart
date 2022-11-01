import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projector/accountSettings/billsPaymentScreen.dart';
import 'package:projector/accountSettings/connectedAccountsScreen.dart';
import 'package:projector/accountSettings/notificationsScreen.dart';
import 'package:projector/accountSettings/profileScreen.dart';
import 'package:projector/apis/accountService.dart';
import 'package:projector/apis/subscriptionService.dart';
import 'package:projector/apis/viewService.dart';
import 'package:projector/constant.dart';
import 'package:projector/contentDashboard/contentDashboard.dart';
import 'package:projector/contents/contentViewScreen.dart';
import 'package:projector/contents/newContentViewScreen.dart';
import 'package:projector/login/GuideScreen.dart';
import 'package:projector/provider/spriteView.dart';
import 'package:projector/data/checkConnection.dart';
import 'package:projector/data/userData.dart';
import 'package:projector/shimmer/shimmerLoadingClass.dart';
import 'package:projector/sideDrawer/contentLayoutScreen.dart';
import 'package:projector/sideDrawer/dashboard.dart';
import 'package:projector/sideDrawer/newListVideo.dart';
import 'package:projector/signInScreen.dart';
import 'package:projector/style.dart';
import 'package:projector/widgets/dialogs.dart';
import 'package:projector/widgets/logo.dart';
import 'package:projector/widgets/widgets.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../subscriptionScreen.dart';

class ViewProfilePage extends StatefulWidget {
  @override
  _ViewProfilePageState createState() => _ViewProfilePageState();
}

class _ViewProfilePageState extends State<ViewProfilePage> {
  var images = ['female', 'male', 'female', 'plus'];
  var names = ['Request'];
  bool spin = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  String _loginedUserId;
  String image;

  var req = int.parse(maxReq ?? '0') - reqSent;
  requestDialog(context, height, width) {
    FocusNode node = FocusNode();
    TextEditingController reqDataCon = TextEditingController();
    String email = '';
    List users = [];
    List selectedUsers = [];
    List selectedUsersEmail = [], userNames = [];
    return showDialog(
      context: context,
      // barrierLabel: 'LABEL',
      barrierColor: Color(0xff333333).withOpacity(0.7),
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          // List<Widget> wids = [];
          List<Widget> bottom = [];

          // for (var i = 0; i < selectedUsers.length; i++) {
          //   wids.add(ListTile(
          //     leading: CircleAvatar(
          //       child: Text(
          //         selectedUsersEmail[i]
          //             .toString()
          //             .substring(0, 1)
          //             .toUpperCase(),
          //         style: GoogleFonts.poppins(
          //           fontSize: 15.0,
          //           fontWeight: FontWeight.w500,
          //           color: Colors.white,
          //         ),
          //       ),
          //     ),
          //     title: Text('${selectedUsers[i]}'),
          //     subtitle: Text('${selectedUsersEmail[i]}'),
          //   ));
          // }

          for (var index = 0; index < users.length; index++) {
            bottom.add(
              ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 5),
                onTap: () {
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
                    setState(() {
                      reqDataCon = TextEditingController(text: '');
                      selectedUsers.remove(users[index]['id']);
                      selectedUsersEmail.remove(users[index]['email']);
                      userNames.remove(users[index]['firstname']);
                    });
                  } else {
                    setState(() {
                      reqDataCon = TextEditingController(text: '');
                      selectedUsers.add(users[index]['id']);
                      selectedUsersEmail.add(users[index]['email']);
                      userNames.add(users[index]['firstname']);
                    });
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
                      fontSize: 15.0,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
                title: Text(
                  // 'Anuj Sharma',
                  '${users[index]['firstname']}' +
                      " " +
                      '${users[index]['lastname']}',
                  style: GoogleFonts.poppins(
                    fontSize: 15.0,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                subtitle: Text(
                  '${users[index]['email']}',
                  style: GoogleFonts.poppins(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[500],
                  ),
                ),
                // trailing: selectedUsers.contains(users[index]['id'])
                //     ? InkWell(
                //         onTap: () {
                //           setState(() {
                //             selectedUsers.remove(users[index]['id']);
                //             selectedUsersEmail.remove(users[index]['email']);
                //             userNames.remove(users[index]['firstname']);
                //           });
                //         },
                //         child: Icon(
                //           Icons.close,
                //           size: 18,
                //           color: Colors.black,
                //         ),
                //       )
                //     : Container(height: 0, width: 0),
              ),
            );
          }
          return Container(
            height: height * 0.5,
            // width: width * 0.5,
            color: Color(0xff333333).withOpacity(0.3),
            child: Dialog(
              backgroundColor: Colors.white.withOpacity(0),
              insetPadding: EdgeInsets.only(
                left: 26.0,
                right: 25.0,
                top: 60.0,
                bottom: 80.0,
              ),
              child: Container(
                height: height * 0.6,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.0),
                  border: Border.all(
                    color: Color(0xff707070),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Stack(
                    children: [
                      Container(
                        height: height * 0.58,
                        child: Column(
                          children: [
                            Container(
                              // width: width * 0.5,
                              height: height * 0.5,
                              padding: EdgeInsets.only(
                                left: 20,
                                right: 17.0,
                              ),
                              // decoration: BoxDecoration(
                              //   color: Colors.white,
                              //   borderRadius: BorderRadius.circular(12.0),
                              //   border: Border.all(
                              //     color: Color(0xff707070),
                              //   ),
                              // ),
                              child: Container(
                                // height: height * 0.2,
                                child: SingleChildScrollView(
                                  child: Column(
                                    // crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      SizedBox(height: 10),
                                      Align(
                                        alignment: Alignment.topRight,
                                        child: InkWell(
                                          onTap: () {
                                            Navigator.pop(context);
                                          },
                                          child: CircleAvatar(
                                            radius: 10,
                                            backgroundColor: Color(0xff333333),
                                            child: Icon(
                                              Icons.close,
                                              size: 11,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 20),
                                      Row(
                                        children: [
                                          CircleAvatar(
                                            backgroundColor: Color(0xff5AA5EF),
                                            child: Image(
                                              height: 24,
                                              image: AssetImage(
                                                  'images/addPerson.png'),
                                            ),
                                          ),
                                          SizedBox(width: 10),
                                          Text(
                                            'Request Access to View',
                                            style: GoogleFonts.poppins(
                                              fontSize: 16.0,
                                              // fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 10),
                                      ListView.builder(
                                        itemCount: userNames.length,
                                        shrinkWrap: true,
                                        itemBuilder: (context, index) {
                                          return InkWell(
                                            onTap: () {
                                              setState(() {
                                                selectedUsers
                                                    .remove(users[index]['id']);
                                                selectedUsersEmail.remove(
                                                    users[index]['email']);
                                                userNames.remove(
                                                    users[index]['firstname']);
                                              });
                                            },
                                            child: FittedBox(
                                              fit: BoxFit.scaleDown,
                                              alignment: Alignment.topLeft,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(16),
                                                  border: Border.all(
                                                      color: Colors.grey),
                                                ),
                                                // width: width * 0.5,
                                                margin: EdgeInsets.symmetric(
                                                    horizontal: 2, vertical: 4),
                                                padding: EdgeInsets.all(6),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      selectedUsersEmail[index],
                                                      style:
                                                          GoogleFonts.poppins(
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                    SizedBox(width: 5),
                                                    CircleAvatar(
                                                      radius: 8,
                                                      backgroundColor:
                                                          Colors.grey,
                                                      child: Center(
                                                        child: Icon(
                                                          Icons.close,
                                                          size: 14,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                      SizedBox(height: 10),
                                      TextFormField(
                                        focusNode: node,
                                        style: GoogleFonts.poppins(
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black,
                                        ),
                                        controller: reqDataCon,
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        // ignore: missing_return
                                        onTap: () {
                                          setState(() {});
                                        },
                                        onFieldSubmitted: (val) {
                                          setState(() {});
                                        },
                                        onChanged: (val) async {
                                          email = val;
                                          var data = await ViewService()
                                              .searchUser(email);
                                          // print(data);
                                          if (data != null &&
                                              data['success'] == true) {
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
                                          hintText: 'Search Users',
                                          hintStyle: GoogleFonts.poppins(
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.w500,
                                            color: Color(0xff8E8E8E),
                                          ),
                                          // suffix: Container(
                                          //   height: 20,
                                          //   child: ListView.builder(
                                          //     itemCount: userNames.length,
                                          //     shrinkWrap: true,
                                          //     scrollDirection: Axis.horizontal,
                                          //     itemBuilder: (context, index) {
                                          //       return InkWell(
                                          //         onTap: () {
                                          //           setState(() {
                                          //             selectedUsers.remove(
                                          //                 users[index]['id']);
                                          //             selectedUsersEmail.remove(
                                          //                 users[index]
                                          //                     ['email']);
                                          //             userNames.remove(
                                          //                 users[index]
                                          //                     ['firstname']);
                                          //           });
                                          //         },
                                          //         child: Container(
                                          //           margin:
                                          //               EdgeInsets.symmetric(
                                          //                   horizontal: 2),
                                          //           child: Text(
                                          //             userNames[index] ?? '',
                                          //           ),
                                          //         ),
                                          //       );
                                          //     },
                                          //   ),
                                          // ),
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
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: 2.5,
                                        color: Color(0xff5AA5EF),
                                      ),
                                      Container(
                                        // color: Colors.green,
                                        height: height * 0.3,
                                        child: ListView(
                                          shrinkWrap: true,
                                          children: bottom,
                                        ),
                                      ),
                                      // Column(
                                      //   children: bottom,
                                      // ),
                                      // SizedBox(height: height * 0.03),

                                      // SizedBox(height: 15)
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            // Center(
                            //   child: Container(
                            //     alignment: Alignment.center,
                            //     height: height * 0.055,
                            //     width: width * 0.45,
                            //     decoration: BoxDecoration(
                            //       borderRadius: BorderRadius.circular(7),
                            //     ),
                            //     child: RaisedButton(
                            //       shape: RoundedRectangleBorder(
                            //         borderRadius: BorderRadius.circular(7),
                            //       ),
                            //       color: Color(0xff5AA5EF),
                            //       onPressed: () async {
                            //         setState(() {
                            //           spin = true;
                            //         });
                            //         var data;

                            //         for (var item in selectedUsers) {
                            //           data = await ViewService()
                            //               .sendViewRequest(item);
                            //           await UserData().setUserStarted();
                            //           ViewService()
                            //               .getAllViewRequests('1')
                            //               .then((val) {
                            //             reqCon.add(val);
                            //           });
                            //         }
                            //         _scaffoldKey.currentState
                            //             .removeCurrentSnackBar();

                            //         setState(() {
                            //           spin = false;
                            //         });
                            //         reqDataCon.text = '';
                            //         Navigator.pop(context, data);
                            //       },
                            //       child: Center(
                            //         child: spin
                            //             ? CircularProgressIndicator()
                            //             : Text(
                            //                 'Request Access',
                            //                 style: GoogleFonts.poppins(
                            //                   fontSize: 15.0,
                            //                   fontWeight: FontWeight.w400,
                            //                   color: Colors.white,
                            //                 ),
                            //               ),
                            //       ),
                            //     ),
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                      Positioned(
                        bottom: node.hasFocus ? height * 0.18 : 10,
                        left: width * 0.22,
                        child: Container(
                          // alignment: Alignment.bottomCenter,
                          child: Center(
                            child: Container(
                              alignment: Alignment.center,
                              height: height * 0.055,
                              width: width * 0.45,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(7),
                              ),
                              child: RaisedButton(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(7),
                                ),
                                color: Color(0xff5AA5EF),
                                onPressed: () async {
                                  setState(() {
                                    spin = true;
                                  });
                                  var data;

                                  for (var item in selectedUsers) {
                                    data = await ViewService()
                                        .sendViewRequest(item);
                                    await UserData().setUserStarted();
                                    // ViewService()
                                    //     .getAllViewRequests('1')
                                    //     .then((val) {
                                    //   reqCon.add(val);
                                    // });
                                  }
                                  _scaffoldKey.currentState
                                      .removeCurrentSnackBar();

                                  setState(() {
                                    spin = false;
                                  });
                                  reqDataCon.text = '';
                                  Navigator.pop(context, data);
                                },
                                child: Center(
                                  child: spin
                                      ? CircularProgressIndicator()
                                      : Text(
                                          'Request Access',
                                          style: GoogleFonts.poppins(
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.white,
                                          ),
                                        ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
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

  bool viewAll = false;

  StreamController reqCon = StreamController.broadcast();

  Future<void> getUserId() async {
    var userId = await UserData().getUserId();

    setState(() {
      _loginedUserId = userId;
    });
  }

  @override
  void initState() {
    //CheckConnectionService().init(_scaffoldKey);
    getUserId();

    ViewService().getAllViewRequestSent('1',context).then((val) {
      reqCon.add(val);
    });

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
    return Sizer(builder: (context, orientation, deviceType) {
      if(deviceType == DeviceType.mobile){
        SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
      }else{
        SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeRight]);
      }
      return SafeArea(
        top: false,
        bottom: false,
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: appBgColor,
            //backgroundColor: Color(0xff1A1D2A),
            actions: [
              Image(
                width: deviceType == DeviceType.mobile ? 40 : 55,
                height: deviceType == DeviceType.mobile ? 40 : 55,
                image: AssetImage('images/logoTransparent.png'),
              ),
              SizedBox(width: 10),
            ],
          ),
          //backgroundColor: Color(0xff1A1A26),
          backgroundColor: appBgColor,
          key: _scaffoldKey,
          body: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.only(
                left: 18.0,
                right: 10.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: height * 0.02),
                  StreamBuilder(
                    stream: reqCon.stream,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Container(
                          // color:Colors.green
                          height: deviceType == DeviceType.mobile ? height * 0.14 : height * 0.23,
                          // color: Colors.green,
                          width: width * 0.90,
                          margin: EdgeInsets.symmetric(horizontal: width * 0.04),
                          child: ListView.builder(
                            // gridDelegate:
                            //     SliverGridDelegateWithFixedCrossAxisCount(
                            //   crossAxisCount: 4,
                            //   childAspectRatio: 0.8,
                            // ),
                            padding: EdgeInsets.all(0),
                            // reverse: true,
                            itemCount: snapshot.data.length + 1,
                            // gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            //   crossAxisCount: 2,
                            //   childAspectRatio: 0.75,
                            // ),
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              var userId = '',
                                  userEmail = '',
                                  userName = '',
                                  image;
                              if (index != snapshot.data.length) {
                                userId = snapshot.data[index]['id'];
                                userEmail = snapshot.data[index]['email'];
                                userName = snapshot.data[index]['firstname'];
                                image = snapshot.data[index]['image'];
                              }
                              return InkWell(
                                onTap: () {
                                  if (index == snapshot.data.length) {
                                    //   getMySubscription().then((data) {
                                    //     print(data);
                                    //     if (data['subscription'] == 'Free')
                                    //       Navigator.of(context).push(
                                    //         CupertinoPageRoute<Null>(
                                    //           builder: (BuildContext context) {
                                    //             return SubscriptionScreen();
                                    //           },
                                    //         ),
                                    //       );
                                    //     else
                                    requestDialog(context, height, width)
                                        .then((data) {
                                      if (data != null) {
                                        _scaffoldKey.currentState.showSnackBar(
                                          SnackBar(
                                            content: Text('${data['message']}'),
                                          ),
                                        );
                                      }
                                    });
                                    // });
                                  } else {
                                    navigate(
                                      context,
                                      NewContentViewScreen(
                                        myVideos: false,
                                        userId: userId,
                                        userEmail: userName,
                                        userImage: image,

                                      ),
                                    );
                                  }
                                },
                                child: Column(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.all(6.0),
                                      height: deviceType == DeviceType.mobile ? height * 0.10 : 130,
                                      width: deviceType == DeviceType.mobile ? width * 0.21 : 130,
                                      decoration: BoxDecoration(
                                        color: Colors.transparent,
                                        border: Border.all(
                                          color: Color(0xff51515D),
                                          width: 3.0,
                                        ),
                                        borderRadius: BorderRadius.circular(20.0),
                                      ),
                                      child: Center(
                                        child: snapshot.data.length == index
                                            ? CircleAvatar(
                                          radius: deviceType == DeviceType.mobile ? 16.0 : 20,
                                          backgroundColor: Colors.white70,
                                          child: Icon(
                                            Icons.add,
                                            color: Colors.black,
                                          ),
                                        )
                                            : image != null
                                            ? CircleAvatar(
                                          radius: deviceType == DeviceType.mobile ? 20 : 30,
                                          backgroundImage:
                                          NetworkImage(image),
                                        )
                                            : Container(
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                                color: Colors.white70),
                                          ),
                                          child: Padding(
                                            padding:
                                            const EdgeInsets.all(
                                                4.0),
                                            child: Image(
                                              height: deviceType == DeviceType.mobile ? 20.0 : 30,
                                              image: AssetImage(
                                                  'images/person.png'),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),

                                    Container(
                                      //  margin: EdgeInsets.only(left: 30,right: 30),
                                      child: Text(
                                        index == snapshot.data.length
                                            ? names[0]
                                            : userName,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.montserrat(
                                          color: Colors.white,
                                          fontSize: deviceType == DeviceType.mobile ? 11.0 : 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      //width: width * 0.15,
                                    ),

                                  ],
                                ),
                              );
                            },
                          ),
                        );
                      } else {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    },
                  ),
                  // Container(
                  //   height: height * 0.14,
                  //   child: ListView.builder(
                  //     itemCount: 4,
                  //     scrollDirection: Axis.horizontal,
                  //     shrinkWrap: true,
                  //     itemBuilder: (context, index) {
                  //       return Column(
                  //         children: [
                  //           Container(
                  //             margin: EdgeInsets.all(6.0),
                  //             height: height * 0.1,
                  //             width: width * 0.22,
                  //             decoration: BoxDecoration(
                  //               color: Color(0xff1A1D2A),
                  //               border: Border.all(
                  //                 color: Colors.white,
                  //                 width: 2.0,
                  //               ),
                  //               borderRadius: BorderRadius.circular(14.0),
                  //             ),
                  //             child: Center(
                  //               child: index == 3
                  //                   ? CircleAvatar(
                  //                       radius: 16.0,
                  //                       backgroundColor: Colors.white,
                  //                       child: Icon(
                  //                         Icons.add,
                  //                         color: Color(0xff1A1D2A),
                  //                       ),
                  //                     )
                  //                   : Image(
                  //                       height: 40,
                  //                       width: 40,
                  //                       image: AssetImage(
                  //                           'images/${images[index]}.png'),
                  //                     ),
                  //             ),
                  //           ),
                  //           Text(
                  //             names[index],
                  //             style: GoogleFonts.montserrat(
                  //               color: Colors.white,
                  //               fontSize: 11.0,
                  //               fontWeight: FontWeight.w600,
                  //             ),
                  //           )
                  //         ],
                  //       );
                  //     },
                  //   ),
                  // ),

                  // InkWell(
                  //   onTap: () {
                  //     setState(() {
                  //       viewAll = !viewAll;
                  //     });
                  //   },
                  //   child: Center(
                  //     child: Container(
                  //       height: height * 0.06,
                  //       width: width * 0.3,
                  //       child: Center(
                  //         child: Text(
                  //           'View All',
                  //           // '',
                  //           style: TextStyle(
                  //             fontSize: 12.0,
                  //             fontWeight: FontWeight.w600,
                  //             color: Color(0xff5AA5EF),
                  //           ),
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  Center(
                    child: InkWell(
                      onTap: () {
                        navigate(
                          context,
                          NewContentViewScreen(
                            myVideos: true,
                            userId: _loginedUserId,
                            userImage: image,
                          ),
                        );
                      },
                      child: Container(
                        height: height * 0.06,
                        width: width * 0.65,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Color(0xff6D6F76),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Center(
                          child: Text(
                            'View My Projector',
                            style: GoogleFonts.montserrat(
                              fontSize: deviceType == DeviceType.mobile ? 13.0 : 18.0,
                              color: Colors.white30,
                              fontWeight: FontWeight.bold,
                              // color: Color(0xff6D6F76),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: height * 0.080),
                  Container(
                    padding: EdgeInsets.only(
                      right: 8.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () {
                            navigate(context, NewListVideo());
                          },
                          child: Container(
                            height: height * 0.05,
                            decoration: BoxDecoration(
                              color: Color(0xff2E2E2E),
                              border: Border.all(
                                color: Color(0xff3E4243),
                                width: 2,
                              ),
                            ),
                            padding: EdgeInsets.only(left: 10, right: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Content",
                                  textAlign: TextAlign.left,
                                  style: GoogleFonts.montserrat(
                                    color: Colors.white70,
                                    fontSize: deviceType == DeviceType.mobile ? 13 : 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                      right: MediaQuery.of(context).size.width *
                                          0.01),
                                  child: Icon(
                                    Icons.arrow_forward_ios,
                                    size: deviceType == DeviceType.mobile ? 20 : 25,
                                    color: Colors.white.withOpacity(0.5),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: MediaQuery.of(context).size.height * 0.007),
                        /*InkWell(
                          onTap: () {
                            //NewListVideo()
                            //ContentDashboardScreen()

                            navigate(context, ContentDashboardScreen());
                          },
                          child: Container(
                            height: height * 0.05,
                            decoration: BoxDecoration(
                              color: Color(0xff2E2E2E),
                              border: Border.all(
                                color: Color(0xff3E4243),
                                width: 2,
                              ),
                            ),
                            padding: EdgeInsets.only(left: 10, right: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                   "Content Dashboard",
                                  textAlign: TextAlign.left,
                                  style: GoogleFonts.montserrat(
                                    color: Colors.white70,
                                    fontSize: deviceType == DeviceType.mobile ? 13 : 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                      right: MediaQuery.of(context).size.width *
                                          0.01),
                                  child: Icon(
                                    Icons.arrow_forward_ios,
                                    size: deviceType == DeviceType.mobile ? 20 : 25,
                                    color: Colors.white.withOpacity(0.5),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: MediaQuery.of(context).size.height * 0.007),*/


                        InkWell(
                          onTap: () {
                            navigate(context, ProfileScreen());
                          },
                          child: Container(
                            height: height * 0.05,
                            decoration: BoxDecoration(
                              color: Color(0xff2E2E2E),
                              border: Border.all(
                                color: Color(0xff3E4243),
                                width: 2,
                              ),
                            ),
                            padding: EdgeInsets.only(left: 10, right: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "App Settings",
                                  textAlign: TextAlign.left,
                                  style: GoogleFonts.montserrat(
                                    color: Colors.white70,
                                    fontSize: deviceType == DeviceType.mobile ? 13 :18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                      right: MediaQuery.of(context).size.width *
                                          0.01),
                                  child: Icon(
                                    Icons.arrow_forward_ios,
                                    size: deviceType == DeviceType.mobile ? 20 : 25,
                                    color: Colors.white.withOpacity(0.5),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // SizedBox(height: 10),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.007),
                        // InkWell(
                        //   onTap: () {
                        //     navigate(context, NotificationScreen());
                        //   },
                        //   child: Text(
                        //     "Notifications",
                        //     textAlign: TextAlign.right,
                        //     style: GoogleFonts.montserrat(
                        //       color: Colors.white,
                        //       fontSize: 15,
                        //       fontWeight: FontWeight.w600,
                        //     ),
                        //   ),
                        // ),
                        // SizedBox(height: 20),
                        InkWell(
                          onTap: () {
                            launch(helpUrl);
                          },
                          child: Container(
                            height: height * 0.05,
                            decoration: BoxDecoration(
                              color: Color(0xff2E2E2E),
                              border: Border.all(
                                color: Color(0xff3E4243),
                                width: 2,
                              ),
                            ),
                            padding: EdgeInsets.only(left: 10, right: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Help",
                                  textAlign: TextAlign.right,
                                  style: GoogleFonts.montserrat(
                                    color: Colors.white70,
                                    fontSize: deviceType == DeviceType.mobile ? 13 : 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                      right: MediaQuery.of(context).size.width *
                                          0.01),
                                  child: Icon(
                                    Icons.arrow_forward_ios,
                                    size: deviceType == DeviceType.mobile ? 20 :25,
                                    color: Colors.white.withOpacity(0.5),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.007),
                        InkWell(
                          onTap: () {
                            launch(
                                privacyUrl);
                            // navigate(context, ProfileScreen());
                          },
                          child: Container(
                            height: height * 0.05,
                            decoration: BoxDecoration(
                              color: Color(0xff2E2E2E),
                              border: Border.all(
                                color: Color(0xff3E4243),
                                width: 2,
                              ),
                            ),
                            padding: EdgeInsets.only(left: 10, right: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Privacy",
                                  textAlign: TextAlign.right,
                                  style: GoogleFonts.montserrat(
                                    color: Colors.white70,
                                    fontSize: deviceType == DeviceType.mobile ? 13 :18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                      right: MediaQuery.of(context).size.width *
                                          0.01),
                                  child: Icon(
                                    Icons.arrow_forward_ios,
                                    size: deviceType == DeviceType.mobile ? 20 : 25,
                                    color: Colors.white.withOpacity(0.5),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // InkWell(
                        //   onTap: () {
                        //     navigate(context, ConnectedAccountScreen());
                        //   },
                        //   child: Text(
                        //     "Connected Accounts",
                        //     textAlign: TextAlign.right,
                        //     style: GoogleFonts.montserrat(
                        //       color: Colors.white,
                        //       fontSize: 15,
                        //       fontWeight: FontWeight.w600,
                        //     ),
                        //   ),
                        // ),
                        // SizedBox(height: 10),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.007),

                        InkWell(
                          onTap: () {
                            launch(termsOfUseUrl);
                          },
                          child: Container(
                            height: height * 0.05,
                            decoration: BoxDecoration(
                              color: Color(0xff2E2E2E),
                              border: Border.all(
                                color: Color(0xff3E4243),
                                width: 2,
                              ),
                            ),
                            padding: EdgeInsets.only(left: 10, right: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Terms of Use",
                                  textAlign: TextAlign.right,
                                  style: GoogleFonts.montserrat(
                                    color: Colors.white70,
                                    fontSize: deviceType == DeviceType.mobile ? 13 : 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                      right: MediaQuery.of(context).size.width *
                                          0.01),
                                  child: Icon(
                                    Icons.arrow_forward_ios,
                                    size: deviceType == DeviceType.mobile ? 20 : 25,
                                    color: Colors.white.withOpacity(0.5),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        /*InkWell(
                        onTap: () {
                          launch(serverPlanUrl);
                          // navigate(context, BillPaymentScreen());
                        },
                        child: Container(
                          height: height * 0.05,
                          decoration: BoxDecoration(
                            color: Color(0xff2E2E2E),
                            border: Border.all(
                              color: Color(0xff3E4243),
                              width: 2,
                            ),
                          ),
                          padding: EdgeInsets.only(left: 10, right: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Billing And Payments",
                                textAlign: TextAlign.right,
                                style: GoogleFonts.montserrat(
                                  color: Colors.white70,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                    right: MediaQuery.of(context).size.width *
                                        0.01),
                                child: Icon(
                                  Icons.arrow_forward_ios,
                                  size: 20,
                                  color: Colors.white.withOpacity(0.5),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),*/
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.03),
                        SizedBox(height: deviceType == DeviceType.mobile ? 20 : 1.0),
                        InkWell(
                          onTap: ()  {
                            UserData().deleteUserLogged();
                            //navigateReplace(context, SignInScreen());
                            navigateReplace(context, GuideScreens());
                          },
                          child: Center(
                            child: Text(
                              "Log Out",
                              textAlign: TextAlign.right,
                              style: GoogleFonts.montserrat(
                                color: Colors.white70,
                                fontSize: deviceType == DeviceType.mobile ? 15 : 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: deviceType == DeviceType.mobile ? 50 : 10),


                        // Center(
                        //     child: LogoExpanded(
                        //   // width: width * 0.3,
                        //   height: MediaQuery.of(context).size.height * 0.05,
                        // )

                        Center(
                          child: Image(
                            height: deviceType == DeviceType.mobile ? height * 0.05 : height * 0.07,
                            image: AssetImage('images/newLogoText.png'),
                          ),

                          //Image(
                          // height: height * 0.04,
                          //image: AssetImage('images/logo.png'),
                          //),
                        ),

                        SizedBox(height: 10),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
