import 'dart:async';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projector/accountSettings/NotificationInvitationScreen.dart';
import 'package:projector/apis/accountService.dart';
import 'package:projector/apis/viewService.dart';
import 'package:projector/common/customShowCaseWidget.dart';
import 'package:projector/constant.dart';
import 'package:projector/contents/contentViewScreen.dart';
import 'package:projector/contents/newContentViewScreen.dart';
import 'package:projector/provider/spriteView.dart';
import 'package:projector/data/userData.dart';
import 'package:projector/sideDrawer/dashboard.dart';
import 'package:projector/sideDrawer/viewProfiePage.dart';
import 'package:projector/style.dart';
import 'package:projector/uploading/createCategoryScreen.dart';
import 'package:projector/uploading/selectFileMainScreen.dart';
import 'package:projector/uploading/selectVideo.dart';
import 'package:projector/widgets/commingSoon.dart';
import 'package:projector/widgets/dialogs.dart';
import 'package:projector/widgets/uploadPopupDialog.dart';
import 'package:projector/widgets/widgets.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

class StartWatchingScreen extends StatefulWidget {
  @override
  _StartWatchingScreenState createState() => _StartWatchingScreenState();
}

class _StartWatchingScreenState extends State<StartWatchingScreen> {
  final key1 = GlobalKey();
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
  var storageAvailable;
  var availableStorage;
  var isLaunchSubscriptionWeb = false;

  var req = int.parse(maxReq) - reqSent;

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
                                  _scaffoldKey.currentState
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

  removeDialog(context, height, width, String userName, String userId,DeviceType deviceType) {
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
                                        fontSize: deviceType == DeviceType.mobile? 17.0 : 20.0,
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
                                                    top: deviceType == DeviceType.mobile? 5 : 8,
                                                    bottom: deviceType == DeviceType.mobile? 5 : 8),
                                                child: Text(
                                                  "Remove",
                                                  style: GoogleFonts.montserrat(
                                                    fontSize: deviceType == DeviceType.mobile? 16.0 : 18.0,
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
                                                  top: deviceType == DeviceType.mobile? 5 : 8,
                                                  bottom: deviceType == DeviceType.mobile?  5 : 8),
                                              child: Text(
                                                "Go Back",
                                                style: GoogleFonts.montserrat(
                                                  fontSize: deviceType == DeviceType.mobile? 16.0 : 18.0,
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

  startShowCase() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      UserData().isFirstLaunchShowCaseChooseProjectorPage().then((data){
        if(data){
          ShowCaseWidget.of(myContext).startShowCase([
            key1,
          ]);
        }
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
    startShowCase();
    getUserId();
    getLognedFirstName();


    ViewService().checkSubscription().then((response) {
     if (response['has_subsription'] == false) {
       isLaunchSubscriptionWeb = true;
     }else{
       ViewService().checkStorage().then((data) {

         var storageUsed = data['storageUsed'];
         var totalStorage = storageUsed['total_storage'];
         var usedStorage = storageUsed['used_storage'];

         print("total storage--->$totalStorage");
         print("used storage--->$usedStorage");

          availableStorage =
             double.parse(totalStorage) - double.parse(usedStorage);

         storageAvailable = double.parse(totalStorage) >= availableStorage &&
             availableStorage > 0;

         print("available storage--->$availableStorage");
         print("available storag--->$storageAvailable");
       });

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
      });
    });

    ViewService().getAllViewRequestSent('1', context).then((val) {
      reqCon.add(val);
      len = val.length;
    });
    super.initState();
  }

  bool viewAll = false;
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
      return ShowCaseWidget(builder: Builder(
        builder: (context){
          myContext = context;
         return SafeArea(
            bottom: false,
            top: false,
            child: Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                elevation: 0,
                // backgroundColor: Color(0xff1A1D2A),
                backgroundColor: appBgColor,
                title: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image(
                          width: deviceType == DeviceType.mobile? 45 : 55,
                          height: deviceType == DeviceType.mobile? 45 : 55,
                          image: AssetImage('images/logoTransparent.png'),
                        ),
                        Spacer(),
                        InkWell(
                          onTap: () async {
                            //commingSoonDialog(context);
                            // navigateLeft(context, SelectFileMainScreen());


                            if(isLaunchSubscriptionWeb == true){
                              launch(serverPlanUrl);
                            }else{
                              if(storageAvailable){
                                showPopupUpload(context: context,availableStorage: availableStorage,
                                left: 25.0,top: 100,right: 0.0,bottom: 0.0);
                              }else{
                                storageDialog(context, height, width);
                              }
                            }


                            /* var response = await ViewService().checkSubscription();
                  if (response['has_subsription'] == false) {
                    launch(serverPlanUrl);
                  } else {
                    var response = await ViewService().checkStorage();
                    var storageUsed = response['storageUsed'];
                    var totalStorage = storageUsed['total_storage'];
                    var usedStorage = storageUsed['used_storage'];

                    var availableStorage =
                        double.parse(totalStorage) - double.parse(usedStorage);

                    storageAvailable = double.parse(totalStorage) >= availableStorage &&
                        availableStorage > 0;

                    *//*if (double.parse(totalStorage) >= availableStorage &&
                        availableStorage > 0) {
                      showPopupUpload(context);
                    } else {
                      storageDialog(context, height, width);
                    }*//*

                    if(storageAvailable){
                      showPopupUpload(context);
                    }else{
                      storageDialog(context, height, width);
                    }
                  }*/
                          },
                          child: CustomShowcaseWidget(
                            globalKey: key1,
                            title: "Start Uploading!",
                            description: "Upload all your videos and photos to share on your Projector!",
                            child: Icon(
                              Icons.video_call,
                              size: deviceType == DeviceType.mobile? 35 : 45,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(width: deviceType == DeviceType.mobile? 10 : 15),
                        InkWell(
                          onTap: () {
                            //navigate(context, NotificationInvitationScreen());
                          },
                          child: new Stack(
                            children: <Widget>[
                              new IconButton(
                                  icon: Icon(
                                    Icons.notifications,
                                    size: deviceType == DeviceType.mobile? 31 : 31,
                                  ),
                                  onPressed: () {
                                    navigate(context, NotificationInvitationScreen());
                                    //navigate(context, SpriteView());
                                  }),
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
                        SizedBox(width: deviceType == DeviceType.mobile? 10 : 15),
                        InkWell(
                          onTap: () {
                            navigate(context, ViewProfilePage());
                          },
                          child: image != null
                              ? CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: deviceType == DeviceType.mobile? 21 : 21,
                            child: CircleAvatar(
                              radius: deviceType == DeviceType.mobile? 20 : 20,
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
                                width: deviceType == DeviceType.mobile? 20 : 20,
                                height: deviceType == DeviceType.mobile? 20.0 : 20,
                                color: Colors.white,
                                image: AssetImage(
                                  'images/person.png',
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )),
              ),
              // backgroundColor: Color(0xff1A1D2A),
              backgroundColor: appBgColor,
              key: _scaffoldKey,
              //TODO: drawer
              /* drawer: DrawerList(
          title: '',
        ),*/
              body: Container(
                padding: EdgeInsets.all(16.0),
                child: Stack(
                  children: [
                    ListView(
                      children: [
                        SizedBox(height: height * 0.01),
                        Center(
                          child: Text(
                            'START\n WATCHING',
                            style: GoogleFonts.montserrat(
                              color: Colors.white,
                              fontSize: deviceType == DeviceType.mobile? 33.0 : 45.0,
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
                                return snapshot.data.length == 0
                                    ? InkWell(
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
                                  child: Center(
                                    child: Container(
                                      margin: EdgeInsets.all(6.0),
                                      height: height * 0.15,
                                      width:  width * 0.33,
                                      decoration: BoxDecoration(
                                        color: Colors.transparent,
                                        border: Border.all(
                                          color: Color(0xff5AA5EF),
                                          width: 3.0,
                                        ),
                                        borderRadius:
                                        BorderRadius.circular(10.0),
                                      ),
                                      child: Center(
                                        child: Text(
                                          'View My Projector',
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.montserrat(
                                              color: Colors.white,
                                              fontSize: deviceType == DeviceType.mobile? 11 : 17,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                                    : Container(
                                  margin: EdgeInsets.symmetric(horizontal: deviceType == DeviceType.mobile?25 : 80),
                                  child: GridView.builder(
                                    itemCount: viewAll
                                        ? snapshot.data.length + 1
                                        : snapshot.data.length > 3
                                        ? 4
                                        : snapshot.data.length + 1,
                                    gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: deviceType == DeviceType.mobile? 2 : 3,
                                      childAspectRatio: deviceType == DeviceType.mobile? 0.85 : 1,
                                      crossAxisSpacing: 1,
                                      mainAxisSpacing: 1,
                                    ),
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) {
                                      var userId = '',
                                          userEmail = '',
                                          userName = '',
                                          responseImage;
                                      if (index != 0) {
                                        userId = snapshot.data[index - 1]['id'];
                                        userEmail =
                                        snapshot.data[index - 1]['email'];
                                        userName = snapshot.data[index - 1]
                                        ['firstname'];
                                        responseImage =
                                        snapshot.data[index - 1]['image'];
                                      }
                                      if (index == 0) {
                                        manageProjectorButtonEnabled = false;
                                      } else {
                                        manageProjectorButtonEnabled = true;
                                      }

                                      return Container(
                                          child: index == 0
                                              ? InkWell(
                                            onTap: () {
                                              navigate(
                                                context,
                                                NewContentViewScreen(
                                                  myVideos: true,
                                                  userId: _loginedUserId,
                                                  userEmail:
                                                  _loginedFirstName,
                                                  userImage: image,
                                                ),
                                              );
                                            },
                                            child: Column(
                                              children: [
                                                Container(
                                                  margin:
                                                  EdgeInsets.all(6.0),
                                                  height: deviceType == DeviceType.mobile? height * 0.15 : 200,
                                                  width: deviceType == DeviceType.mobile? width * 0.33 : 200,
                                                  decoration:
                                                  BoxDecoration(
                                                    color: Colors
                                                        .transparent,
                                                    border: Border.all(
                                                      color: Color(
                                                          0xff5AA5EF),
                                                      width: 3.0,
                                                    ),
                                                    borderRadius:
                                                    BorderRadius
                                                        .circular(
                                                        10.0),
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      'View My Projector',
                                                      textAlign: TextAlign.center,
                                                      style: GoogleFonts
                                                          .montserrat(
                                                        color:
                                                        Colors.white,
                                                        fontWeight:
                                                        FontWeight
                                                            .w500,
                                                        fontSize: deviceType == DeviceType.mobile? 11 : 17,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(height: 16),
                                              ],
                                            ),
                                          )
                                              : InkWell(
                                            onTap: () {
                                              navigate(
                                                context,
                                                NewContentViewScreen(
                                                  myVideos: false,
                                                  userId: userId,
                                                  userEmail: userName,
                                                  userImage:
                                                  responseImage,
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
                                                        height: deviceType == DeviceType.mobile? height * 0.15 : 200,
                                                        width: deviceType == DeviceType.mobile? width * 0.33 : 200,
                                                        decoration:
                                                        BoxDecoration(
                                                          color: Colors
                                                              .transparent,
                                                          border:
                                                          Border.all(
                                                            color: Color(
                                                                0xff5AA5EF),
                                                            width: 3.0,
                                                          ),
                                                          borderRadius:
                                                          BorderRadius
                                                              .circular(
                                                              10.0),
                                                        ),
                                                        child: Padding(
                                                          padding:
                                                          EdgeInsets
                                                              .all(
                                                            deviceType == DeviceType.mobile?  width * 0.07 : width * 0.00,
                                                          ),
                                                          child: Center(
                                                            child: responseImage !=
                                                                null
                                                                ? CircleAvatar(
                                                              backgroundColor:
                                                              Colors.white,
                                                              radius:
                                                              deviceType == DeviceType.mobile? 30 : 48,
                                                              child:
                                                              CircleAvatar(
                                                                radius:
                                                                deviceType == DeviceType.mobile? 28 : 47,
                                                                backgroundImage:
                                                                NetworkImage(responseImage),
                                                              ),
                                                            )
                                                                : Container(
                                                              decoration:
                                                              BoxDecoration(
                                                                shape:
                                                                BoxShape.circle,
                                                                border:
                                                                Border.all(color: Colors.white),
                                                              ),
                                                              child:
                                                              Image(
                                                                height:
                                                                height * 0.08,
                                                                image:
                                                                AssetImage('images/person.png'),
                                                              ),
                                                            ),
                                                            // child: Image(
                                                            //   image: AssetImage(
                                                            //       'images/male.png'),
                                                            // ),
                                                          ),
                                                        ),
                                                      ),
                                                      Container(
                                                        margin:
                                                        EdgeInsets.only(
                                                            left: 15,
                                                            right: 15),
                                                        child: Text(
                                                          userName == ""
                                                              ? userEmail
                                                              : userName,
                                                          maxLines: 2,
                                                          overflow:
                                                          TextOverflow
                                                              .ellipsis,
                                                          style: GoogleFonts
                                                              .montserrat(
                                                            color: Colors
                                                                .white,
                                                            fontSize: deviceType == DeviceType.mobile? 11.0 : 17.0,
                                                            fontWeight:
                                                            FontWeight
                                                                .w600,
                                                          ),
                                                          textAlign:
                                                          TextAlign
                                                              .center,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Visibility(
                                                    visible:
                                                    removeButtonEnabled,
                                                    child: Positioned(
                                                      top: 15.0,
                                                      right: 15.0,
                                                      child: InkWell(
                                                        onTap: () {
                                                          removeDialog(
                                                              context,
                                                              height,
                                                              width,
                                                              userName == ""
                                                                  ? userEmail
                                                                  : userName,
                                                              userId,deviceType);
                                                        },
                                                        child: Image.asset(
                                                          "images/icon_remove.png",
                                                          width: deviceType == DeviceType.mobile? 25 : 38,
                                                          height:  deviceType == DeviceType.mobile? 25 : 38,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ));
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
                        ),
                        // SizedBox(height: height * 0.03),
                        /*    InkWell(
                    onTap: () {
                      // getMySubscription().then((data) {
                      //   // print(data);
                      //   if (data['subscription'] == 'Free')
                      //     Navigator.of(context).push(
                      //       CupertinoPageRoute<Null>(
                      //         builder: (BuildContext context) {
                      //           return SubscriptionScreen();
                      //         },
                      //       ),
                      //     );
                      //   else
                      requestDialog(context, height, width).then((data) {
                        if (data != null) {
                          _scaffoldKey.currentState.showSnackBar(
                            SnackBar(
                              content: Text('${data['message']}'),
                            ),
                          );
                        }
                      });
                      // });
                    },
                    child: Column(
                      children: [
                        Container(
                          //margin: EdgeInsets.all(6.0),
                          //height: height * 0.15,
                          // width: width * 0.32,
                          */ /*  decoration: BoxDecoration(
                            color: Color(0xff31343E),
                            borderRadius: BorderRadius.circular(10.0),
                          ),*/ /*
                          */ /* child: Padding(
                            padding: EdgeInsets.all(width * 0.1),
                            child: Center(
                              child: Image(
                                image: AssetImage('images/plus.png'),
                              ),
                            ),
                          ),*/ /*
                        ),
                        */ /* Text(
                          names[0],
                          style: GoogleFonts.montserrat(
                            color: Color(0xff5AA5EF),
                            fontSize: 11.0,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        )*/ /*
                      ],
                    ),
                  ),*/
                        // SizedBox(height: height * 0.05),
                        InkWell(
                          onTap: () {
                            setState(() {
                              viewAll = !viewAll;
                              if (viewAll) {
                                viewAllText = 'View less';
                              } else {
                                viewAllText = 'View all';
                              }
                            });
                          },
                          child: Container(
                            // height: height * 0.06,
                            width: width * 0.5,
                            child: Center(
                              child: deviceType == DeviceType.mobile? Text(
                                len <= 3 ? '' : viewAllText,
                                style: GoogleFonts.montserrat(
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xff6D6F76),
                                ),
                              ) :
                              Text(
                                len <= 6 ? '' : viewAllText,
                                style: GoogleFonts.montserrat(
                                  fontSize:  18.0,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xff6D6F76),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 40,),

                        Visibility(
                          visible: manageProjectorButtonEnabled,
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: SizedBox(
                              // width: 210,
                              child: InkWell(
                                  onTap : () {
                                    removeButtonEnabled = !removeButtonEnabled;

                                    setState(() {
                                      if (removeButtonEnabled) {
                                        manageProjectorText = "Cancel";
                                      } else {
                                        manageProjectorText = "Manage Projectors";
                                      }
                                    });
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(deviceType == DeviceType.mobile? 7.0 : 10.0),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Color(0xff6D6F76),
                                        width: 2,
                                      ),
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                    child: Text(
                                      manageProjectorText,
                                      style: GoogleFonts.montserrat(
                                        color: Color(0xff6D6F76),
                                        fontSize: deviceType == DeviceType.mobile? 14.0 : 20.0,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  )
                                // borderSide: BorderSide(
                                //   color: Color(0xff6D6F76),
                                //   width: 2.0,
                                // ),
                              ),
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
                                requestDialog(context, height, width).then((data) {
                                  if (data != null) {
                                    //content: Text('${data['message']}'),
                                    String messageText;
                                    if (data['message'] == "View Request Sent...") {
                                      messageText = "Request Sent Successfully";
                                    } else {
                                      messageText = data['message'];
                                    }
                                    _scaffoldKey.currentState.showSnackBar(
                                      SnackBar(
                                        content: Text('$messageText'),
                                      ),
                                    );
                                  }
                                });
                              },
                              child: Icon(
                                Icons.add,
                                color: Colors.white,
                                size: deviceType == DeviceType.mobile? 40 : 50,
                              ),
                              backgroundColor: Color(0xff31343E),
                            ),
                            SizedBox(height: 10),
                            Text(
                              "Request Access",
                              style: GoogleFonts.montserrat(
                                color: Color(0xff5AA5EF),
                                fontSize: deviceType == DeviceType.mobile? 11.0 : 18.0,
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
            ),
          );
        },
      ));
    });

  }
}
