import 'dart:async';
import 'dart:math';

import 'package:dotted_border/dotted_border.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projector/apis/accountService.dart';
import 'package:projector/apis/contentDashboardService.dart';
import 'package:projector/apis/subscriptionService.dart';
import 'package:projector/apis/viewService.dart';
import 'package:projector/constant.dart';
import 'package:projector/widgets/dialogs.dart';
import 'package:projector/widgets/uploadPopupDialog.dart';
import 'package:projector/widgets/widgets.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool loading = false;
  StreamController subscriptionController = StreamController.broadcast();
  String maxStorage = '0', maxReq = '0';

  var storageAvailable;
  var availableStorage;
  var isLaunchSubscriptionWeb = false;
  String avatarUrl;
  var currentPlan,
      totalStorage,
      usedStorage,
      videoStorage,
      albumStorage,
      totalStorageText,
      totalViewers,
      maxViewRequest,
      availableStorageTxt,
      availableStorageSubscription;

  bool spin = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  formatSizeUnits(bytes) {
    if (bytes >= 1073741824) {
      bytes = (bytes / 1073741824).toFixed(2) + " GB";
    } else if (bytes >= 1048576) {
      bytes = (bytes / 1048576).toFixed(2) + " MB";
    } else if (bytes >= 1024) {
      bytes = (bytes / 1024).toFixed(2) + " KB";
    } else if (bytes > 1) {
      bytes = bytes + " bytes";
    } else if (bytes == 1) {
      bytes = bytes + " byte";
    } else {
      bytes = "0 bytes";
    }
    return bytes;
  }

  String formatBytes(int bytes, int decimals) {
    if (bytes <= 0) return "0 B";
    const suffixes = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
    var i = (log(bytes) / log(1024)).floor();
    return ((bytes / pow(1024, i)).toStringAsFixed(decimals)) +
        ' ' +
        suffixes[i];
  }

  @override
  void initState() {
    ViewService().checkSubscription().then((response) {
      if (response['has_subsription'] == false) {
        isLaunchSubscriptionWeb = true;
      } else {
        ViewService().checkStorage().then((data) {
          var storageUsed = data['storageUsed'];
          var totalStorage = storageUsed['total_storage'];
          var usedStorage = storageUsed['used_storage'];

          availableStorage =
              double.parse(totalStorage) - double.parse(usedStorage);

          storageAvailable = double.parse(totalStorage) >= availableStorage &&
              availableStorage > 0;
        });
      }
    });

    AccountService().getProfile().then((data) {
      setState(() {
        avatarUrl = data['image'];
      });
    });

    getMySubscription().then((data) {
      subscriptionController.add(data);
      // print(data);
      var subscriptionType = data['subscription'];
      maxStorage = subscriptionType['max_storage_in_mb'];
      maxReq = subscriptionType['max_view_request_sent'];
      currentPlan = data['current_plan'];
      availableStorageTxt = data['availableStorage'];
      totalStorageText = subscriptionType['total_storage_text'];
      totalViewers = subscriptionType['total_viewers'];
      maxViewRequest = subscriptionType['max_view_request'];

      totalStorage = data['storageUsed']['total_storage'];
      usedStorage = data['storageUsed']['used_storage'];
      videoStorage = data['storageUsed']['video_storage'];
      albumStorage = data['storageUsed']['album_storage'];

      if (videoStorage == null) {
        videoStorage = "0";
      }
      if (albumStorage == null) {
        albumStorage = "0";
      }

      availableStorageSubscription = double.parse(totalStorage).round() -
          double.parse(usedStorage).round();
      print("availablee---$availableStorageSubscription");
    });

    super.initState();
  }

  Widget VerticalSeperatorView() => Center(
          child: Container(
        width: 2.0,
        height: 30,
        color: Colors.black,
      ));

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Sizer(builder: (context, orientation, deviceType) {
      if (deviceType == DeviceType.mobile) {
        SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
      } else {
        SystemChrome.setPreferredOrientations(
            [DeviceOrientation.landscapeRight]);
      }
      return Scaffold(
        backgroundColor: Color.fromRGBO(242, 242, 242, 1),
        appBar: AppBar(
            backgroundColor: Colors.white,
            centerTitle: false,
            elevation: 1,
            leading: IconButton(
              onPressed: () {
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                } else {
                  SystemNavigator.pop();
                }
              },
              icon: Icon(Icons.arrow_back_ios),
              color: Colors.black,
            ),
            titleSpacing: 0.0,
            title: Transform(
              transform: Matrix4.translationValues(0.0, 0.0, 0.0),
              child: Text(
                "Dashboard",
                style: GoogleFonts.montserrat(
                  color: Colors.black,
                  fontSize: 20.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            actions: [
              Container(
                margin: EdgeInsets.only(right: 16),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.black),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: (avatarUrl != null)
                      ? CircleAvatar(
                          radius: deviceType == DeviceType.mobile ? 18 : 47,
                          backgroundImage: NetworkImage(avatarUrl),
                        )
                      : Image(
                          width: 36.0,
                          height: 36.0,
                          color: Colors.black,
                          image: AssetImage(
                            'images/person.png',
                          ),
                        ),
                ),
              ),
            ]),
        body: Container(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: height * 0.02),

                /// Upload View
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
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.video_call,
                                    size: deviceType == DeviceType.mobile
                                        ? 44
                                        : 60,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  VerticalSeperatorView(),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Icon(
                                    Icons.camera_alt,
                                    size: deviceType == DeviceType.mobile
                                        ? 35
                                        : 50,
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                width: width * 0.45,
                                child: RaisedButton(
                                  color: Color(0xff1172D2),
                                  onPressed: () {
                                    if (isLaunchSubscriptionWeb == true) {
                                      launch(serverPlanUrl);
                                    } else {
                                      if (storageAvailable) {
                                        showPopupUpload(
                                            context: context,
                                            availableStorage: availableStorage,
                                            left: 75.0,
                                            top: 100.0,
                                            right: 75.0,
                                            bottom: 0.0);
                                      } else {
                                        storageDialog(context, height, width);
                                      }
                                    }
                                  },
                                  child: Text(
                                    'UPLOAD',
                                    style: GoogleFonts.poppins(
                                      fontSize: deviceType == DeviceType.mobile
                                          ? 15.0
                                          : 20.0,
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
                      height: deviceType == DeviceType.mobile
                          ? height * 0.22
                          : height * 0.25,
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
                SizedBox(height: 20),

                /// Current Plan View
                Padding(
                  padding: EdgeInsets.only(
                    left: 20.0,
                    right: 20.0,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(25.0),
                    child: Container(
                        padding: EdgeInsets.all(20),
                        height: 204,
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
                                    'Current Plan',
                                    style: TextStyle(
                                      fontSize: deviceType == DeviceType.mobile
                                          ? 20.0
                                          : 25.0,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: height * 0.01),
                                  Text(
                                    "$currentPlan : $totalStorageText Storage ( $availableStorageTxt Available )",
                                    style: GoogleFonts.montserrat(
                                      fontSize: deviceType == DeviceType.mobile
                                          ? 14.0
                                          : 18.0,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                    ),
                                  ),
                                  SizedBox(height: height * 0.01),
                                  if (albumStorage != null &&
                                      videoStorage != null &&
                                      totalStorage != null)
                                    Container(
                                      height: deviceType == DeviceType.mobile
                                          ? height * 0.03
                                          : height * 0.04,
                                      child: Row(
                                        children: [
                                          Container(
                                              color: Colors.blue,
                                              width: width *
                                                  0.76 *
                                                  double.parse(videoStorage) /
                                                  double.parse(totalStorage)),
                                          Container(
                                            color: Colors.red,
                                            width: width *
                                                0.8 *
                                                double.parse(albumStorage) /
                                                double.parse(totalStorage),
                                          ),
                                          Expanded(
                                            child:
                                                Container(color: Colors.black),
                                          ),
                                        ],
                                      ),
                                    ),
                                  SizedBox(height: 8),

                                  Row(
                                    children: [
                                      Container(
                                        width: 16.0,
                                        height: 12.0,
                                        color: Colors.blue,
                                      ),
                                      SizedBox(width: 8.0),
                                      Text(
                                        videoStorage != null
                                            ? "Videos : ${double.parse(videoStorage).round()} MB"
                                            : "Videos : 0 MB",
                                        style: GoogleFonts.montserrat(
                                          fontSize:
                                              deviceType == DeviceType.mobile
                                                  ? 14.0
                                                  : 18.0,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),

                                  Row(
                                    children: [
                                      Container(
                                        width: 16.0,
                                        height: 12.0,
                                        color: Colors.red,
                                      ),
                                      SizedBox(width: 8.0),
                                      Text(
                                        "Photos : ${double.parse(albumStorage).round()} MB",
                                        style: GoogleFonts.montserrat(
                                          fontSize:
                                              deviceType == DeviceType.mobile
                                                  ? 14.0
                                                  : 18.0,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),

                                  Row(
                                    children: [
                                      Container(
                                        width: 16.0,
                                        height: 12.0,
                                        color: Colors.black,
                                      ),
                                      SizedBox(width: 8.0),
                                      Text(
                                        "Free space : $availableStorageTxt",
                                        style: GoogleFonts.montserrat(
                                          fontSize:
                                              deviceType == DeviceType.mobile
                                                  ? 14.0
                                                  : 18.0,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),

                                  SizedBox(height: 10),

                                  Center(
                                    child: InkWell(
                                      child: Container(
                                        width: 100,
                                        height: deviceType == DeviceType.mobile
                                            ? height * 0.04
                                            : height * 0.05,
                                        decoration: BoxDecoration(
                                          color: Color(0xffc9c9c9),
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        child: Center(
                                          child: Text('Manage',
                                              style: GoogleFonts.montserrat(
                                                fontSize: deviceType ==
                                                        DeviceType.mobile
                                                    ? 14.0
                                                    : 18.0,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.white,
                                              )),
                                        ),
                                      ),
                                      onTap: () {
                                        launch(serverPlanUrl);
                                      },
                                    ),
                                  ),
                                  // SizedBox(height: height * 0.01),
                                ],
                              );
                            }
                            return Center(child: CircularProgressIndicator());
                          },
                        )),
                  ),
                ),
                SizedBox(height: 20),

                /// Viewers Pending
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
                                    fontSize: deviceType == DeviceType.mobile
                                        ? 23.0
                                        : 33.0,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    requestDialog(
                                      context,
                                      height * 0.80,
                                      width,
                                    ).then((value) {
                                      setState(() {});
                                    });

                                    /* getMySubscription().then((data) {
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
                                 });*/
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
                              future: ContentDashboardService()
                                  .getPendingViewersList(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return snapshot.data.length == 0
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
                                          itemCount: snapshot.data.length,
                                          shrinkWrap: true,
                                          itemBuilder: (context, index) {
                                            var userId = '',
                                                userEmail = '',
                                                firstName = '',
                                                lastName = '',
                                                type = '';

                                            if (index != snapshot.data.length) {
                                              userId =
                                                  snapshot.data[index]['id'];
                                              userEmail =
                                                  snapshot.data[index]['email'];
                                              firstName = snapshot.data[index]
                                                  ['firstname'];
                                              lastName = snapshot.data[index]
                                                  ['lastname'];
                                              type =
                                                  snapshot.data[index]['type'];
                                            }

                                            return manageUserContent(
                                                type: type,
                                                name: '$firstName $lastName',
                                                email: '$userEmail',
                                                deviceType: deviceType,
                                                accept: () async {
                                                  setState(() {
                                                    loading = true;
                                                  });

                                                  var response =
                                                      await ViewService()
                                                          .updateRequestStatus(
                                                              1, userId);
                                                  if (response['success']) {
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
                                                  var response =
                                                      await ViewService()
                                                          .updateRequestStatus(
                                                              2, userId);
                                                  if (response['success'] ==
                                                      true) {
                                                    showConfirmDialog(
                                                      context,
                                                      text: 'Request Rejected',
                                                    );
                                                  }
                                                  setState(() {
                                                    loading = false;
                                                  });
                                                },
                                                cancelInvitationClick:
                                                    () async {
                                                  var response =
                                                      await ContentDashboardService()
                                                          .cancelInvitation(
                                                              email: userEmail);

                                                  if (response["success"]) {
                                                    setState(() {
                                                      loading = false;
                                                    });
                                                  }

                                                  setState(() {
                                                    loading = false;
                                                  });
                                                });
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
                                fontSize: deviceType == DeviceType.mobile
                                    ? 23.0
                                    : 33.0,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 10),
                            FutureBuilder(
                              future:
                                  ContentDashboardService().getViewersList(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return snapshot.data.length == 0
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
                                          itemCount: snapshot.data.length,
                                          shrinkWrap: true,
                                          itemBuilder: (context, index) {
                                            var userId = '',
                                                userEmail = '',
                                                firstName = '',
                                                lastName = '';

                                            if (index != snapshot.data.length) {
                                              userId =
                                                  snapshot.data[index]['id'];
                                              userEmail =
                                                  snapshot.data[index]['email'];
                                              firstName = snapshot.data[index]
                                                  ['firstname'];
                                              lastName = snapshot.data[index]
                                                  ['lastname'];
                                            }

                                            return Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "$firstName $lastName",
                                                      style: TextStyle(
                                                        fontSize: deviceType ==
                                                                DeviceType
                                                                    .mobile
                                                            ? 16.0
                                                            : 18.0,
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                    Text(
                                                      userEmail,
                                                      style: GoogleFonts
                                                          .montserrat(
                                                        fontSize: deviceType ==
                                                                DeviceType
                                                                    .mobile
                                                            ? 9.0
                                                            : 14.0,
                                                        color:
                                                            Color(0xffB2B2B2),
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                InkWell(
                                                  child: Container(
                                                    child: Text(
                                                      "Remove",
                                                      style: GoogleFonts
                                                          .montserrat(
                                                        fontSize: 11.0,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color:
                                                            Color(0xffFF0000),
                                                      ),
                                                    ),
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: Colors.black,
                                                          width: 1),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5.0),
                                                    ),
                                                    padding:
                                                        const EdgeInsets.all(
                                                            4.0),
                                                  ),
                                                  onTap: () async {
                                                    setState(() {
                                                      loading = true;
                                                    });

                                                    var response =
                                                        await ContentDashboardService()
                                                            .deleteViewer(
                                                                userId: userId);

                                                    if (response["success"]) {
                                                      setState(() {
                                                        loading = false;
                                                      });
                                                    } else {
                                                      setState(() {
                                                        loading = false;
                                                      });
                                                    }
                                                  },
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
      );
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
      barrierColor: Color(0xff333333).withOpacity(0.7),
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          List<Widget> bottom = [];

          if (users != null && users.length > 0) {
            for (var index = 0; index < users.length; index++) {
              bottom.add(
                ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 5),
                  onTap: () {
                    if (selectedUsers.contains(users[index]['id'])) {
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
                                            'Invite New Viewer',
                                            style: GoogleFonts.poppins(
                                              fontSize: 20.0,
                                              fontWeight: FontWeight.w600,
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
                                            var data =
                                                await ContentDashboardService()
                                                    .searchUserInvite(
                                                        email: email);
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
                                    ],
                                  ),
                                ),
                              ),
                            ),
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
                                  if (email.isEmpty || email == "") {
                                    Fluttertoast.showToast(
                                        msg: 'Enter email',
                                        backgroundColor: Colors.white,
                                        textColor: Colors.black);
                                  } else {
                                    setState(() {
                                      spin = true;
                                    });

                                    var data = await ContentDashboardService()
                                        .addViewers(data: users);

                                    setState(() {
                                      spin = false;
                                    });

                                    reqDataCon.text = '';
                                    Navigator.pop(context, data);
                                  }
                                },
                                child: Center(
                                  child: spin
                                      ? CircularProgressIndicator(
                                          color: Colors.white)
                                      : Text(
                                          'Done',
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
}
