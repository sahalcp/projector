import 'dart:async';
import 'dart:math';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projector/accountSettings/NotificationInvitationScreen.dart';
import 'package:projector/apis/accountService.dart';
import 'package:projector/apis/viewService.dart';
import 'package:projector/common/customShowCaseWidget.dart';
import 'package:projector/constant.dart';
import 'package:projector/contents/newContentViewScreen.dart';
import 'package:projector/data/userData.dart';
import 'package:projector/sideDrawer/dashboard.dart';
import 'package:projector/sideDrawer/viewProfiePage.dart';
import 'package:projector/widgets/dialogs.dart';
import 'package:projector/widgets/info_toast.dart';
import 'package:projector/widgets/uploadPopupDialog.dart';
import 'package:projector/widgets/widgets.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

class StartWatchingScreen extends StatefulWidget {
  const StartWatchingScreen({Key key, this.showPromoDialog = false})
      : super(key: key);

  final bool showPromoDialog;

  @override
  _StartWatchingScreenState createState() => _StartWatchingScreenState();
}

class _StartWatchingScreenState extends State<StartWatchingScreen> {
  final key1 = GlobalKey();
  final key2 = GlobalKey();
  final key3 = GlobalKey();
  final key4 = GlobalKey();
  final key5 = GlobalKey();
  BuildContext myContext;

  var images = ['plus'];
  var names = ['Request New Access'];
  bool spin = false;
  bool removeButtonEnabled = false;
  String manageProjectorText = "Manage Projectors";
  bool manageProjectorButtonEnabled = false;
  bool removeUserProgress = false;
  String _loginedUserId;
  String _loginedFirstName;
  int notificationBadge = 0;

  var uploadCount;
  var isLaunchSubscriptionWeb = false;

  var req = int.parse(maxReq) - reqSent;

  startShowCase() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      UserData().isFirstLaunchShowCaseChooseProjectorPage().then((data) {
        if (data) {
          ShowCaseWidget.of(myContext).startShowCase([key1]);
        }
      });
    });
  }

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
          if (users != null && users.length > 0) {
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
                          text:
                              "You already have an connection with the user ");
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
                  leading: selectedUsers.contains(users[index]['id'])
                      ? Container()
                      : CircleAvatar(
                          backgroundColor:
                              selectedUsers.contains(users[index]['id'])
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
                  title: selectedUsers.contains(users[index]['id'])
                      ? Container()
                      : Text(
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
                  subtitle: selectedUsers.contains(users[index]['id'])
                      ? Container()
                      : Text(
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
                                          if (EmailValidator.validate(
                                              email.trim())) {
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
                        //bottom: node.hasFocus ? height * 0.18 : 10,
                        bottom: node.hasFocus ? 10 : 10,
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
                                    //await UserData().setUserStarted();
                                    // ViewService()
                                    //     .getAllViewRequests('1')
                                    //     .then((val) {
                                    //   reqCon.add(val);
                                    //   len = val.length;
                                    // });
                                  }
                                  ScaffoldMessenger.of(context)
                                      .removeCurrentSnackBar();

                                  setState(() {
                                    spin = false;
                                  });
                                  reqDataCon.text = '';
                                  Navigator.pop(context, data);
                                  //Navigator.pop(context);
                                },
                                child: Center(
                                  child: spin
                                      ? CircularProgressIndicator(
                                          color: Colors.white)
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
                      )
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

  removeDialog(context, height, width, String userName, String userId,
      DeviceType deviceType) {
    return showDialog(
      context: context,
      barrierColor: Color(0xff333333).withOpacity(0.7),
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return Container(
            height: height * 0.5,
            color: Color(0xff333333).withOpacity(0.3),
            child: Dialog(
              backgroundColor: Colors.white.withOpacity(0),
              insetPadding: EdgeInsets.only(
                left: 26.0,
                right: 25.0,
                top: 60.0,
                bottom: 50.0,
              ),
              child: Container(
                //height: height * 0.6,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30.0),
                  border: Border.all(
                    color: Color(0xff707070),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Stack(
                    children: [
                      Container(
                        child: Column(
                          children: [
                            Container(
                              padding: EdgeInsets.only(
                                left: 20,
                                right: 17.0,
                                bottom: 50,
                              ),
                              child: Container(
                                child: Column(
                                  children: [
                                    SizedBox(height: 40),
                                    Text(
                                      "Remove " + userName + "?",
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.montserrat(
                                        fontSize: 35.0,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black,
                                      ),
                                    ),
                                    SizedBox(height: 30),
                                    Text(
                                      "Once you remove a Projector you will have to request to view again.",
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.montserrat(
                                        fontSize:
                                            deviceType == DeviceType.mobile
                                                ? 17.0
                                                : 20.0,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xff0A112B),
                                      ),
                                    ),
                                    SizedBox(height: 50),
                                    Align(
                                      alignment: FractionalOffset.center,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          ButtonTheme(
                                            shape: new RoundedRectangleBorder(
                                                side: BorderSide(
                                                    color: Colors.grey[600],
                                                    width: 1.0)),
                                            child: RaisedButton(
                                              elevation: 5.0,
                                              color: Colors.white,
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                    left: 10,
                                                    right: 10,
                                                    top: deviceType ==
                                                            DeviceType.mobile
                                                        ? 5
                                                        : 8,
                                                    bottom: deviceType ==
                                                            DeviceType.mobile
                                                        ? 5
                                                        : 8),
                                                child: Text(
                                                  "Remove",
                                                  style: GoogleFonts.montserrat(
                                                    fontSize: deviceType ==
                                                            DeviceType.mobile
                                                        ? 16.0
                                                        : 18.0,
                                                    fontWeight: FontWeight.w500,
                                                    color: Color(0xffFF0000),
                                                  ),
                                                ),
                                              ),
                                              onPressed: () async {
                                                setState(() {
                                                  removeUserProgress = true;
                                                });

                                                var response =
                                                    await AccountService()
                                                        .removeUser(id: userId);

                                                setState(() {
                                                  removeButtonEnabled = false;
                                                  manageProjectorText =
                                                      "Manage Projectors";
                                                });

                                                if (response["success"]) {
                                                  setState(() {
                                                    removeUserProgress = false;
                                                  });

                                                  Navigator.pop(context);

                                                  ViewService()
                                                      .getAllViewRequestSent(
                                                          '1', context)
                                                      .then((val) {
                                                    reqCon.add(val);
                                                    len = val.length;
                                                  });
                                                } else {
                                                  setState(() {
                                                    removeUserProgress = false;
                                                  });
                                                }
                                              },
                                            ),
                                          ),
                                          SizedBox(
                                            width: 20,
                                          ),
                                          RaisedButton(
                                            elevation: 5.0,
                                            color: Color(0xffDEDEDE),
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                  left: 10,
                                                  right: 10,
                                                  top: deviceType ==
                                                          DeviceType.mobile
                                                      ? 5
                                                      : 8,
                                                  bottom: deviceType ==
                                                          DeviceType.mobile
                                                      ? 5
                                                      : 8),
                                              child: Text(
                                                "Go Back",
                                                style: GoogleFonts.montserrat(
                                                  fontSize: deviceType ==
                                                          DeviceType.mobile
                                                      ? 16.0
                                                      : 18.0,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                            onPressed: () {
                                              Navigator.pop(context);
                                              setState(() {
                                                removeUserProgress = false;
                                                removeButtonEnabled = false;
                                                manageProjectorText =
                                                    "Manage Projectors";
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Visibility(
                        visible: removeUserProgress,
                        child: Positioned(
                          top: 100,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: Container(
                              height: 30,
                              width: 30,
                              margin: EdgeInsets.all(5),
                              child: CircularProgressIndicator(),
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

  StreamController reqCon = StreamController.broadcast();
  int len = 0;

  setLength(int i) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        len = i;
      });
    });
  }

  Future<void> getUserId() async {
    var userId = await UserData().getUserId();

    setState(() {
      _loginedUserId = userId;
      print("loginUserId--->$_loginedUserId");
    });
  }

  Future<void> getLognedFirstName() async {
    var firstName = await UserData().getFirstName();

    setState(() {
      _loginedFirstName = firstName;
    });
  }

  String image;

  @override
  void initState() {
    getUserId();
    getLognedFirstName();
    startShowCase();

    ViewService().checkSubscription().then((response) {
      if (response['has_subsription'] == false) {
        isLaunchSubscriptionWeb = true;
      }
    });

    ViewService().getAllViewRequestSentNotification('3', context).then((val) {
      notificationBadge = notificationBadge + val.length;

      setState(() {
        if (notificationBadge > 0) {
          notificationBadge = 1;
        } else {
          notificationBadge = 0;
        }
      });
    });

    ViewService().getMyNotificationsLandingPage().then((data) {
      if (data['success'] == true) {
        var unreadCount = data['unread_count'];
        notificationBadge = unreadCount;
        setState(() {
          if (notificationBadge > 0) {
            notificationBadge = 1;
          } else {
            notificationBadge = 0;
          }
        });
      }
    });

    AccountService().getProfile().then((data) {
      // print(data);
      setState(() {
        image = data['image'];
        if (data['subscription'] == null) {
          uploadCount = data['totalContentUploaded'];
        }
      });
    });

    ViewService().getAllViewRequestSent('1', context).then((val) {
      reqCon.add(val);
      len = val.length;
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (widget.showPromoDialog) {
      Future.delayed(Duration(seconds: 3), () {
        showPromotionDialog(context: context);
      });
    }
    super.didChangeDependencies();
  }

  bool viewAll = true;
  String viewAllText = 'View all';
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Sizer(builder: (context, orientation, deviceType) {
      /*if(deviceType == DeviceType.mobile){
        SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
      }else{
        SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeRight]);
      }*/
      return SafeArea(
        bottom: false,
        top: false,
        child: ShowCaseWidget(builder: Builder(
          builder: (context) {
            myContext = context;
            return Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                elevation: 0,
                // backgroundColor: Color(0xff1A1D2A),
                // backgroundColor: appBgColor,
                backgroundColor: Colors.black,
                title: Container(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image(
                      width: deviceType == DeviceType.mobile ? 45 : 55,
                      height: deviceType == DeviceType.mobile ? 45 : 55,
                      image: AssetImage('images/logoTransparent.png'),
                    ),
                    Spacer(),
                    InkWell(
                      onTap: () async {
                        //commingSoonDialog(context);
                        // navigateLeft(context, SelectFileMainScreen());

                        if (isLaunchSubscriptionWeb == true) {
                          launch(serverPlanUrl);
                        } else {
                          showPopupUpload(
                              context: context,
                              uploadCount: uploadCount,
                              left: 25.0,
                              top: 100,
                              right: 0.0,
                              bottom: 0.0);

                          //storageDialog(context, height, width);

                        }
                      },
                      child: CustomShowcaseWidget(
                        globalKey: key1,
                        title: "Start Uploading!",
                        description:
                            "Upload all your videos and photos to share on your Projector!",
                        child: Icon(
                          Icons.video_call,
                          size: deviceType == DeviceType.mobile ? 35 : 45,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(width: deviceType == DeviceType.mobile ? 10 : 15),
                    InkWell(
                      onTap: () {
                        //navigate(context, NotificationInvitationScreen());
                      },
                      child: new Stack(
                        children: <Widget>[
                          CustomShowcaseWidget(
                            globalKey: key2,
                            description: "Notifications",
                            child: new IconButton(
                                icon: Icon(
                                  Icons.notifications,
                                  size:
                                      deviceType == DeviceType.mobile ? 31 : 31,
                                ),
                                onPressed: () {
                                  navigate(
                                      context, NotificationInvitationScreen());
                                  //navigate(context, SpriteView());
                                }),
                          ),
                          notificationBadge != 0
                              ? new Positioned(
                                  right: 11,
                                  top: 11,
                                  child: new Container(
                                    padding: EdgeInsets.all(2),
                                    decoration: new BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    constraints: BoxConstraints(
                                      minWidth: 11,
                                      minHeight: 11,
                                    ),
                                    child: Text(
                                      '$notificationBadge',
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 5,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                )
                              : new Container()
                        ],
                      ),
                    ),
                    SizedBox(width: deviceType == DeviceType.mobile ? 10 : 15),
                    InkWell(
                      onTap: () {
                        navigate(context, ViewProfilePage());
                      },
                      child: CustomShowcaseWidget(
                        globalKey: key3,
                        description: "Profile",
                        child: Container(
                          child: image != null
                              ? CircleAvatar(
                                  backgroundColor: Colors.white,
                                  radius:
                                      deviceType == DeviceType.mobile ? 21 : 21,
                                  child: CircleAvatar(
                                    radius: deviceType == DeviceType.mobile
                                        ? 20
                                        : 20,
                                    backgroundImage: NetworkImage(image),
                                  ),
                                )
                              : Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.white),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Image(
                                      width: deviceType == DeviceType.mobile
                                          ? 20
                                          : 20,
                                      height: deviceType == DeviceType.mobile
                                          ? 20.0
                                          : 20,
                                      color: Colors.white,
                                      image: AssetImage(
                                        'images/person.png',
                                      ),
                                    ),
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ],
                )),
              ),
              // backgroundColor: Color(0xff1A1D2A),
              //backgroundColor: appBgColor,
              backgroundColor: Colors.black,
              key: _scaffoldKey,
              body: Container(
                // decoration: BoxDecoration(
                //     gradient: RadialGradient(
                //   radius: 0.5,
                //   center: Alignment.bottomCenter,
                //   colors: [
                //     Color.fromARGB(255, 0, 30, 71),
                //     Colors.black,
                //   ],
                // )),
                padding: EdgeInsets.all(16.0),
                child: Stack(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * 0.5,
                      // decoration: BoxDecoration(
                      //     gradient: RadialGradient(
                      //   radius: 0.5,
                      //   center: Alignment.topCenter,
                      //   colors: [
                      //     Color.fromARGB(255, 0, 30, 71),
                      //     Colors.black,
                      //   ],
                      // )),
                    ),
                    ListView(
                      children: [
                        SizedBox(height: height * 0.01),
                        Center(
                          child: Text(
                            'START\n WATCHING',
                            style: GoogleFonts.montserrat(
                              color: Colors.white,
                              fontSize:
                                  deviceType == DeviceType.mobile ? 33.0 : 45.0,
                              fontWeight: FontWeight.w900,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(height: height * 0.055),
                        Container(
                          // height: height * 0.35,
                          child: StreamBuilder(
                            stream: reqCon.stream,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                setLength(snapshot.data.length);

                                if (snapshot.data.length == 0)
                                  return _indexProfileItem(
                                      deviceType: deviceType,
                                      width: width,
                                      height: height);

                                return viewAll
                                    ? Container(
                                        margin: EdgeInsets.symmetric(
                                            horizontal:
                                                deviceType == DeviceType.mobile
                                                    ? 25
                                                    : 80),
                                        child: GridView.builder(
                                          itemCount: viewAll
                                              ? snapshot.data.length + 1
                                              : snapshot.data.length > 3
                                                  ? 4
                                                  : snapshot.data.length + 1,
                                          gridDelegate:
                                              SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount:
                                                deviceType == DeviceType.mobile
                                                    ? 2
                                                    : 3,
                                            childAspectRatio:
                                                deviceType == DeviceType.mobile
                                                    ? 0.85
                                                    : 1,
                                            crossAxisSpacing: 1,
                                            mainAxisSpacing: 1,
                                          ),
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          itemBuilder: (context, index) {
                                            if (index == 0) {
                                              manageProjectorButtonEnabled =
                                                  false;
                                              return _indexProfileItem(
                                                  deviceType: deviceType,
                                                  width: width,
                                                  height: height);
                                            } else {
                                              final userId = snapshot
                                                      .data[index - 1]['id'] ??
                                                  "";
                                              final userEmail =
                                                  snapshot.data[index - 1]
                                                          ['email'] ??
                                                      "";
                                              final userName =
                                                  snapshot.data[index - 1]
                                                          ['firstname'] ??
                                                      "";
                                              final responseImage = snapshot
                                                  .data[index - 1]['image'];

                                              manageProjectorButtonEnabled =
                                                  true;

                                              return _profileItem(
                                                  userId: userId,
                                                  userName: userName,
                                                  userEmail: userEmail,
                                                  responseImage: responseImage,
                                                  deviceType: deviceType,
                                                  width: width,
                                                  height: height);
                                            }
                                          },
                                        ),
                                      )
                                    : Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: (height * 0.05)),
                                        child: SizedBox(
                                          height: max(height * 0.24, 120),
                                          child: ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            itemCount:
                                                (snapshot.data.length ?? 0) + 1,
                                            itemBuilder: (context, index) {
                                              if (index == 0) {
                                                manageProjectorButtonEnabled =
                                                    false;
                                                return _indexProfileItem(
                                                  deviceType: deviceType,
                                                  width: width,
                                                  height: height,
                                                  isList: true,
                                                );
                                              } else {
                                                final userId =
                                                    snapshot.data[index - 1]
                                                            ['id'] ??
                                                        "";
                                                final userEmail =
                                                    snapshot.data[index - 1]
                                                            ['email'] ??
                                                        "";
                                                final userName =
                                                    snapshot.data[index - 1]
                                                            ['firstname'] ??
                                                        "";
                                                final responseImage = snapshot
                                                    .data[index - 1]['image'];

                                                manageProjectorButtonEnabled =
                                                    true;

                                                return _listProfileItem(
                                                    userId: userId,
                                                    userName: userName,
                                                    userEmail: userEmail,
                                                    responseImage:
                                                        responseImage,
                                                    deviceType: deviceType,
                                                    width: width,
                                                    height: height);
                                              }
                                            },
                                          ),
                                        ),
                                      );
                              } else {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                            },
                          ),
                        ),
                        // InkWell(
                        //   onTap: () {
                        //     if (len < 3) return;
                        //     setState(() {
                        //       viewAll = !viewAll;
                        //       if (viewAll) {
                        //         viewAllText = 'View less';
                        //       } else {
                        //         viewAllText = 'View all';
                        //       }
                        //     });
                        //   },
                        //   child: Container(
                        //     // height: height * 0.06,
                        //     width: width * 0.5,
                        //     child: Center(
                        //       child: deviceType == DeviceType.mobile
                        //           ? Text(
                        //               len < 3 ? '' : viewAllText,
                        //               style: GoogleFonts.montserrat(
                        //                 fontSize: 12.0,
                        //                 fontWeight: FontWeight.w600,
                        //                 color: Color(0xff6D6F76),
                        //               ),
                        //             )
                        //           : Text(
                        //               len <= 6 ? '' : viewAllText,
                        //               style: GoogleFonts.montserrat(
                        //                 fontSize: 18.0,
                        //                 fontWeight: FontWeight.w600,
                        //                 color: Color(0xff6D6F76),
                        //               ),
                        //             ),
                        //     ),
                        //   ),
                        // ),
                        SizedBox(
                          height: 40,
                        ),
                        Visibility(
                          visible: manageProjectorButtonEnabled,
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: SizedBox(
                              // width: 210,
                              child: InkWell(
                                  onTap: () {
                                    removeButtonEnabled = !removeButtonEnabled;

                                    setState(() {
                                      if (removeButtonEnabled) {
                                        manageProjectorText = "Cancel";
                                      } else {
                                        manageProjectorText =
                                            "Manage Projectors";
                                      }
                                    });
                                  },
                                  child: CustomShowcaseWidget(
                                    globalKey: key5,
                                    description: "Manage your projectors",
                                    child: Container(
                                      padding: EdgeInsets.all(
                                          deviceType == DeviceType.mobile
                                              ? 7.0
                                              : 10.0),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Color(0xff6D6F76),
                                          width: 2,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                      ),
                                      child: Text(
                                        manageProjectorText,
                                        style: GoogleFonts.montserrat(
                                          color: Color(0xff6D6F76),
                                          fontSize:
                                              deviceType == DeviceType.mobile
                                                  ? 14.0
                                                  : 20.0,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  )),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        bottom: 20,
                      ),
                      child: Align(
                        alignment: FractionalOffset.bottomRight,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            FloatingActionButton(
                              onPressed: () {
                                requestDialog(context, height, width)
                                    .then((data) {
                                  if (data != null) {
                                    //content: Text('${data['message']}'),
                                    String messageText;
                                    if (data['message'] ==
                                        "View Request Sent...") {
                                      messageText = "Request Sent Successfully";
                                    } else {
                                      messageText = data['message'];
                                    }
                                    InfoToast.showSnackBar(context,
                                        message: messageText);
                                  }
                                });
                              },
                              child: CustomShowcaseWidget(
                                globalKey: key4,
                                description: "Request New Access",
                                child: Icon(
                                  Icons.add,
                                  color: Colors.white,
                                  size:
                                      deviceType == DeviceType.mobile ? 40 : 50,
                                ),
                              ),
                              backgroundColor: Color(0xff31343E),
                            ),
                            SizedBox(height: 10),
                            Text(
                              "Request Access",
                              style: GoogleFonts.montserrat(
                                color: Color(0xff5AA5EF),
                                fontSize: deviceType == DeviceType.mobile
                                    ? 11.0
                                    : 18.0,
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.center,
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        )),
      );
    });
  }

  // Index profile
  Widget _indexProfileItem(
      {DeviceType deviceType,
      double width,
      double height,
      bool isList = false}) {
    return InkWell(
      onTap: () {
        navigate(
          context,
          NewContentViewScreen(
            myVideos: true,
            userId: _loginedUserId,
            userEmail: _loginedFirstName,
            userImage: image,
          ),
        );
      },
      child: Column(
        children: [
          Container(
            margin: (isList) ? null : EdgeInsets.all(6.0),
            height: deviceType == DeviceType.mobile
                ? ((isList) ? height * 0.18 : height * 0.15)
                : 200,
            width: deviceType == DeviceType.mobile
                ? ((isList) ? width * 0.36 : width * 0.33)
                : 200,
            child: Padding(
              padding: EdgeInsets.only(
                  left: deviceType == DeviceType.mobile ? width * 0.07 : 0,
                  right: deviceType == DeviceType.mobile ? width * 0.07 : 0,
                  top: deviceType == DeviceType.mobile ? width * 0.07 : 0,
                  bottom: (!isList && deviceType == DeviceType.mobile)
                      ? width * 0.07
                      : 0),
              child: Center(
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white),
                  ),
                  child: Image(
                    height: (isList) ? height * 0.10 : height * 0.08,
                    image: AssetImage('images/person.png'),
                  ),
                ),
              ),
            ),
          ),
          Container(
            child: Text(
              "Your Projector",
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.montserrat(
                color: Colors.white,
                fontSize: deviceType == DeviceType.mobile ? 12.5 : 17.0,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  // Grid View's Profile item
  Widget _profileItem({
    String userId,
    String userName,
    String userEmail,
    String responseImage,
    DeviceType deviceType,
    double width,
    double height,
  }) {
    return InkWell(
      onTap: () {
        navigate(
          context,
          NewContentViewScreen(
            myVideos: false,
            userId: userId,
            userEmail: userName,
            userImage: responseImage,
          ),
        );
      },
      child: Center(
        child: Stack(
          children: [
            Column(
              children: [
                Container(
                  margin: EdgeInsets.all(6.0),
                  height: deviceType == DeviceType.mobile ? height * 0.15 : 200,
                  width: deviceType == DeviceType.mobile ? width * 0.33 : 200,
                  child: Padding(
                    padding: EdgeInsets.all(
                      deviceType == DeviceType.mobile
                          ? width * 0.07
                          : width * 0.00,
                    ),
                    child: Center(
                      child: responseImage != null
                          ? CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: deviceType == DeviceType.mobile ? 30 : 48,
                              child: CircleAvatar(
                                radius:
                                    deviceType == DeviceType.mobile ? 28 : 47,
                                backgroundImage: NetworkImage(responseImage),
                              ),
                            )
                          : Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white),
                              ),
                              child: Image(
                                height: height * 0.08,
                                image: AssetImage('images/person.png'),
                              ),
                            ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 15),
                  child: Text(
                    userName == "" ? userEmail : userName,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.montserrat(
                      color: Colors.white,
                      fontSize: deviceType == DeviceType.mobile ? 12.5 : 17.0,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            Visibility(
              visible: removeButtonEnabled,
              child: Positioned(
                top: 15.0,
                right: 15.0,
                child: InkWell(
                  onTap: () {
                    removeDialog(
                        context,
                        height,
                        width,
                        userName == "" ? userEmail : userName,
                        userId,
                        deviceType);
                  },
                  child: Image.asset(
                    "images/icon_remove.png",
                    width: deviceType == DeviceType.mobile ? 25 : 38,
                    height: deviceType == DeviceType.mobile ? 25 : 38,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // List View's profile item
  Widget _listProfileItem({
    String userId,
    String userName,
    String userEmail,
    String responseImage,
    DeviceType deviceType,
    double width,
    double height,
  }) {
    return InkWell(
      onTap: () {
        navigate(
          context,
          NewContentViewScreen(
            myVideos: false,
            userId: userId,
            userEmail: userName,
            userImage: responseImage,
          ),
        );
      },
      child: Center(
        child: Stack(
          children: [
            Column(
              children: [
                Container(
                  //margin: EdgeInsets.all(6.0),
                  height: deviceType == DeviceType.mobile ? height * 0.18 : 200,
                  width: deviceType == DeviceType.mobile ? width * 0.36 : 200,
                  child: Padding(
                    padding: EdgeInsets.only(
                        left:
                            deviceType == DeviceType.mobile ? width * 0.07 : 0,
                        right:
                            deviceType == DeviceType.mobile ? width * 0.07 : 0,
                        top:
                            deviceType == DeviceType.mobile ? width * 0.07 : 0),
                    child: Center(
                      child: responseImage != null
                          ? CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: deviceType == DeviceType.mobile ? 36 : 48,
                              child: CircleAvatar(
                                radius:
                                    deviceType == DeviceType.mobile ? 34 : 47,
                                backgroundImage: NetworkImage(responseImage),
                              ),
                            )
                          : Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white),
                              ),
                              child: Image(
                                height: height * 0.10,
                                image: AssetImage('images/person.png'),
                              ),
                            ),
                    ),
                  ),
                ),
                Container(
                  child: Text(
                    userName == "" ? userEmail : userName,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.montserrat(
                      color: Colors.white,
                      fontSize: deviceType == DeviceType.mobile ? 12.5 : 17.0,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            Visibility(
              visible: removeButtonEnabled,
              child: Positioned(
                top: 15.0,
                right: 15.0,
                child: InkWell(
                  onTap: () {
                    removeDialog(
                        context,
                        height,
                        width,
                        userName == "" ? userEmail : userName,
                        userId,
                        deviceType);
                  },
                  child: Image.asset(
                    "images/icon_remove.png",
                    width: deviceType == DeviceType.mobile ? 25 : 38,
                    height: deviceType == DeviceType.mobile ? 25 : 38,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
