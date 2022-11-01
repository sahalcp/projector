import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projector/apis/accountService.dart';
import 'package:projector/apis/viewService.dart';
import 'package:projector/data/checkConnection.dart';
import 'package:projector/startWatching.dart';
import 'package:projector/widgets/widgets.dart';

class NotificationInvitationScreen extends StatefulWidget {
  @override
  _NotificationInvitationScreenState createState() =>
      _NotificationInvitationScreenState();
}

class _NotificationInvitationScreenState
    extends State<NotificationInvitationScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  StreamController streamControllerRequest = StreamController.broadcast();
  StreamController streamController = StreamController.broadcast();
  StreamController streamNotificationController = StreamController.broadcast();
  //bool userButtonProgress = false;
  bool invitationTextEnabled = false;
  bool requestTextEnabled = false;
  bool centerProgressIndicator = false;
  // int counter = 0;


  setLength(int listLength) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
       if(listLength>0){
         invitationTextEnabled = true;
       }else{
         invitationTextEnabled = false;
       }
      });
    });
  }

  setLengthRequest(int listLength) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        if(listLength>0){
          requestTextEnabled = true;
        }else{
          requestTextEnabled = false;
        }
      });
    });
  }


  // checkLength(int listLength) {
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     setState(() {
  //       if(counter>0){
  //         counter = 1;
  //       }else{
  //         counter = 0;
  //       }
  //     });
  //   });
  // }

  @override
  void initState() {
    //CheckConnectionService().init(_scaffoldKey);

    ViewService().readNotification();

    ViewService().getAllViewRequests('0').then((val) {
      streamControllerRequest.add(val);

    });

    ViewService().getAllViewRequestSentNotification('3',context).then((val) {
      streamController.add(val);

    });

    ViewService().getMyNotifications().then((val) {
      streamNotificationController.add(val);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return SafeArea(
      bottom: false,
      top: false,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          key: _scaffoldKey,
          elevation: 2,
          leading: IconButton(
            onPressed: () {
              navigateRemoveLeft(context, StartWatchingScreen());
              // if (Navigator.canPop(context)) {
              //   Navigator.pop(context);
              // } else {
              //   SystemNavigator.pop();
              // }
            },
            icon: Icon(Icons.arrow_back_ios),
            color: Colors.black,
          ),
          titleSpacing: 0.0,
          title: Transform(
            transform: Matrix4.translationValues(-15.0, 0.0, 0.0),
            child: Text(
              "Notifications",
              style: GoogleFonts.montserrat(
                color: Colors.black,
                fontSize: 25.0,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          actions: [
            Container(
              margin: EdgeInsets.only(right: 16),
              child: new Stack(
                children: <Widget>[
                  Icon(Icons.notifications,size: 40,color: Colors.black,),

                  // counter != 0 ? new Positioned(
                  //   right: 5,
                  //   top: 5,
                  //   child: new Container(
                  //     padding: EdgeInsets.all(2),
                  //     decoration: new BoxDecoration(
                  //       color: Colors.red,
                  //       borderRadius: BorderRadius.circular(6),
                  //     ),
                  //     constraints: BoxConstraints(
                  //       minWidth: 14,
                  //       minHeight: 14,
                  //     ),
                  //     child: Text(
                  //       '$counter',
                  //       style: TextStyle(
                  //         color: Colors.red,
                  //         fontSize: 8,
                  //       ),
                  //       textAlign: TextAlign.center,
                  //     ),
                  //   ),
                  // ) : new Container()
                ],
              ),
            ),
          ],
        ),
        body: Container(
          margin: EdgeInsets.only(left: 16, right: 16),
          child: Stack(
            children: [
              ListView(
                children: [
                  Column(
                    children: [
                      //Todo: Request list start
                      Visibility(
                          visible: requestTextEnabled,
                          child: Column(
                            children: [
                              SizedBox(
                                height: 20,
                              ),
                              Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  "Requests",
                                  style: GoogleFonts.montserrat(
                                    color: Colors.black,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                            ],
                          )),

                      StreamBuilder(
                        stream: streamControllerRequest.stream,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            setLengthRequest(snapshot.data.length);

                            return SingleChildScrollView(
                              child: ListView.builder(
                                itemCount: snapshot.data.length,
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  var userId = '',
                                      userEmail = '',
                                      firstName = '',
                                      lastName = '';

                                  if (index != snapshot.data.length) {
                                    userId = snapshot.data[index]['id'];
                                    userEmail = snapshot.data[index]['email'];
                                    firstName =
                                    snapshot.data[index]['firstname'];
                                    lastName = snapshot.data[index]['lastname'];
                                  }


                                  return Stack(
                                    children: [
                                      Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                            children: [
                                              Flexible(
                                                child: Column(
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "$firstName" +
                                                          " $lastName",
                                                      style: GoogleFonts
                                                          .montserrat(
                                                        fontSize: 18.0,
                                                        fontWeight:
                                                        FontWeight.w600,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 3,
                                                    ),
                                                    Align(
                                                      alignment:
                                                      Alignment.topLeft,
                                                      child: Text(
                                                        "$userEmail",
                                                        style: GoogleFonts
                                                            .montserrat(
                                                          fontSize: 13.0,
                                                          fontWeight:
                                                          FontWeight.w400,
                                                          color:
                                                          Color(0xffB2B2B2),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  ButtonTheme(
                                                    shape:
                                                    new RoundedRectangleBorder(
                                                        borderRadius:
                                                        BorderRadius
                                                            .circular(
                                                            5.0),
                                                        side: BorderSide(
                                                            color: Color(
                                                                0xff5AA5EF),
                                                            width: 2.0)),
                                                    child: RaisedButton(
                                                      elevation: 0,
                                                      color: Colors.white,
                                                      child: Padding(
                                                        padding:
                                                        EdgeInsets.all(5),
                                                        child: Text(
                                                          "Accept",
                                                          style: GoogleFonts
                                                              .montserrat(
                                                            fontSize: 16.0,
                                                            fontWeight:
                                                            FontWeight.w600,
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                      ),
                                                      onPressed: () async {
                                                        setState(() {
                                                          centerProgressIndicator =
                                                          true;
                                                        });

                                                        var response =
                                                        await ViewService()
                                                            .updateRequestStatus(
                                                            1, userId);


                                                        if (response[
                                                        "success"]) {
                                                          setState(() {
                                                            centerProgressIndicator =
                                                            false;
                                                          });
                                                          ViewService()
                                                              .getAllViewRequests(
                                                              '0')
                                                              .then((val) {
                                                            streamControllerRequest
                                                                .add(val);

                                                            ViewService().getMyNotifications().then((val) {
                                                              streamNotificationController.add(val);
                                                            });

                                                          });

                                                        } else {
                                                          setState(() {
                                                            centerProgressIndicator =
                                                            false;
                                                          });
                                                        }
                                                      },
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  ButtonTheme(
                                                    shape:
                                                    new RoundedRectangleBorder(
                                                        borderRadius:
                                                        BorderRadius
                                                            .circular(
                                                            5.0),
                                                        side: BorderSide(
                                                            color: Colors
                                                                .black,
                                                            width: 2.0)),
                                                    child: RaisedButton(
                                                      elevation: 0,
                                                      color: Colors.white,
                                                      child: Padding(
                                                        padding:
                                                        EdgeInsets.all(5),
                                                        child: Text(
                                                          "Decline",
                                                          style: GoogleFonts
                                                              .montserrat(
                                                            fontSize: 16.0,
                                                            fontWeight:
                                                            FontWeight.w600,
                                                            color: Color(
                                                                0xffFF0000),
                                                          ),
                                                        ),
                                                      ),
                                                      onPressed: () async {
                                                        setState(() {
                                                          centerProgressIndicator =
                                                          true;
                                                        });

                                                        var response =
                                                        await ViewService()
                                                            .updateRequestStatus(
                                                            2, userId);

                                                        if (response[
                                                        "success"]) {
                                                          setState(() {
                                                            centerProgressIndicator =
                                                            false;
                                                          });

                                                          ViewService()
                                                              .getAllViewRequests(
                                                              '0')
                                                              .then((val) {
                                                            streamControllerRequest
                                                                .add(val);

                                                            ViewService().getMyNotifications().then((val) {
                                                              streamNotificationController.add(val);
                                                            });

                                                          });
                                                        } else {
                                                          setState(() {
                                                            centerProgressIndicator =
                                                            false;
                                                          });
                                                        }
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 30,
                                          ),
                                        ],
                                      ),
                                      Visibility(
                                        visible: false,
                                        child: Positioned(
                                          top: 0,
                                          left: 0,
                                          right: 0,
                                          child: Center(
                                            child: Container(
                                              height: 30,
                                              width: 30,
                                              margin: EdgeInsets.all(5),
                                              child:
                                              CircularProgressIndicator(),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            );
                          } else {
                            return Center();
                          }
                        },
                      ),

                      //Todo: Request list end
                      SizedBox(
                        height: 30,
                      ),
                    //Todo: Invitation list start

                      Visibility(
                          visible: invitationTextEnabled,
                          child: Column(
                            children: [
                              SizedBox(
                                height: 20,
                              ),
                              Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  "Invitations",
                                  style: GoogleFonts.montserrat(
                                    color: Colors.black,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                            ],
                          )),

                      StreamBuilder(
                        stream: streamController.stream,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            //counter = counter +snapshot.data.length;
                            setLength(snapshot.data.length);
                            //checkLength(snapshot.data.length);

                            return SingleChildScrollView(
                              // margin: EdgeInsets.symmetric(horizontal: width * 0.04),
                              // margin: EdgeInsets.only(bottom: 30),
                              child: ListView.builder(
                                //  padding: EdgeInsets.only(bottom: 30),
                                // reverse: true,
                                itemCount: snapshot.data.length,
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  var userId = '',
                                      userEmail = '',
                                      firstName = '',
                                      lastName = '',
                                      image;

                                  if (index != snapshot.data.length) {
                                    userId = snapshot.data[index]['id'];
                                    userEmail = snapshot.data[index]['email'];
                                    firstName =
                                        snapshot.data[index]['firstname'];
                                    lastName = snapshot.data[index]['lastname'];
                                    image = snapshot.data[index]['image'];
                                  }


                                  return Stack(
                                    children: [
                                      Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Flexible(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "$firstName" +
                                                          " $lastName",
                                                      style: GoogleFonts
                                                          .montserrat(
                                                        fontSize: 18.0,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 3,
                                                    ),
                                                    Align(
                                                      alignment:
                                                          Alignment.topLeft,
                                                      child: Text(
                                                        "$userEmail",
                                                        style: GoogleFonts
                                                            .montserrat(
                                                          fontSize: 13.0,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color:
                                                              Color(0xffB2B2B2),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  ButtonTheme(
                                                    shape:
                                                        new RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5.0),
                                                            side: BorderSide(
                                                                color: Color(
                                                                    0xff5AA5EF),
                                                                width: 2.0)),
                                                    child: RaisedButton(
                                                      elevation: 0,
                                                      color: Colors.white,
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsets.all(5),
                                                        child: Text(
                                                          "Accept",
                                                          style: GoogleFonts
                                                              .montserrat(
                                                            fontSize: 16.0,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                      ),
                                                      onPressed: () async {
                                                        setState(() {
                                                          centerProgressIndicator =
                                                              true;
                                                        });

                                                        var response =
                                                            await AccountService()
                                                                .acceptOrDeclineUser(
                                                                    userId:
                                                                        userId,
                                                                    status:
                                                                        '1');


                                                        if (response[
                                                            "success"]) {
                                                          setState(() {
                                                            centerProgressIndicator =
                                                                false;
                                                          });

                                                          ViewService()
                                                              .getAllViewRequestSentNotification(
                                                                  '3',context)
                                                              .then((val) {
                                                            streamController
                                                                .add(val);

                                                            ViewService().getMyNotifications().then((val) {
                                                              streamNotificationController.add(val);
                                                            });

                                                          });
                                                        } else {
                                                          setState(() {
                                                            centerProgressIndicator =
                                                                false;
                                                          });
                                                        }
                                                      },
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  ButtonTheme(
                                                    shape:
                                                        new RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5.0),
                                                            side: BorderSide(
                                                                color: Colors
                                                                    .black,
                                                                width: 2.0)),
                                                    child: RaisedButton(
                                                      elevation: 0,
                                                      color: Colors.white,
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsets.all(5),
                                                        child: Text(
                                                          "Decline",
                                                          style: GoogleFonts
                                                              .montserrat(
                                                            fontSize: 16.0,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color: Color(
                                                                0xffFF0000),
                                                          ),
                                                        ),
                                                      ),
                                                      onPressed: () async {
                                                        setState(() {
                                                          centerProgressIndicator =
                                                              true;
                                                        });

                                                        var response =
                                                            await AccountService()
                                                                .acceptOrDeclineUser(
                                                                    userId:
                                                                        userId,
                                                                    status:
                                                                        '2');

                                                        if (response[
                                                            "success"]) {
                                                          setState(() {
                                                            centerProgressIndicator =
                                                                false;
                                                          });

                                                          ViewService()
                                                              .getAllViewRequestSentNotification(
                                                                  '3',context)
                                                              .then((val) {
                                                            streamController
                                                                .add(val);

                                                            ViewService().getMyNotifications().then((val) {
                                                              streamNotificationController.add(val);
                                                            });

                                                          });
                                                        } else {
                                                          setState(() {
                                                            centerProgressIndicator =
                                                                false;
                                                          });
                                                        }
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 30,
                                          ),
                                        ],
                                      ),
                                      Visibility(
                                        visible: false,
                                        child: Positioned(
                                          top: 0,
                                          left: 0,
                                          right: 0,
                                          child: Center(
                                            child: Container(
                                              height: 30,
                                              width: 30,
                                              margin: EdgeInsets.all(5),
                                              child:
                                                  CircularProgressIndicator(),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            );
                          } else {
                            return Center();
                          }
                        },
                      ),

                      //Todo: Invitation list end
                      SizedBox(
                        height: 30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "General",
                            style: GoogleFonts.montserrat(
                              fontSize: 20.0,
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                            ),
                          ),
                          InkWell(
                            onTap: () async {
                              setState(() {
                                centerProgressIndicator = true;
                              });

                              var response = await AccountService()
                                  .removeAllNotification();
                              if (response['success']) {
                                setState(() {
                                  centerProgressIndicator = false;
                                });

                                Fluttertoast.showToast(
                                  backgroundColor: Colors.black,
                                  msg: response['message'],
                                  textColor: Colors.white,
                                );

                                ViewService()
                                    .getAllViewRequestSentNotification('3',context)
                                    .then((val) {
                                  streamController.add(val);
                                });

                                ViewService().getMyNotifications().then((val) {
                                  streamNotificationController.add(val);
                                });
                              } else {
                                setState(() {
                                  centerProgressIndicator = false;
                                });
                              }
                            },
                            child: Text(
                              "Clear All",
                              style: GoogleFonts.montserrat(
                                fontSize: 12.0,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      StreamBuilder(
                        stream: streamNotificationController.stream,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                           // counter = counter +snapshot.data.length;
                            //checkLength(snapshot.data.length);
                            return SingleChildScrollView(
                              // margin: EdgeInsets.symmetric(horizontal: width * 0.04),
                              // margin: EdgeInsets.only(bottom: 30),
                              child: ListView.builder(
                                //  padding: EdgeInsets.only(bottom: 30),
                                // reverse: true,
                                itemCount: snapshot.data.length,
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  var userId = '', message = '';
                                  if (index != snapshot.data.length) {
                                    userId = snapshot.data[index]['id'];
                                    message = snapshot.data[index]['message'];
                                  }

                                  return Stack(
                                    children: [
                                      Container(
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Flexible(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        "$message",
                                                        style: GoogleFonts
                                                            .montserrat(
                                                          fontSize: 17.0,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                InkWell(
                                                  onTap: () async {
                                                    setState(() {
                                                      centerProgressIndicator =
                                                          true;
                                                    });

                                                    var response =
                                                        await AccountService()
                                                            .removeNotification(
                                                                id: userId,
                                                                status: "2");

                                                    if (response['success']) {
                                                      setState(() {
                                                        centerProgressIndicator =
                                                            false;
                                                      });

                                                      Fluttertoast.showToast(
                                                        backgroundColor:
                                                            Colors.black,
                                                        msg:
                                                            response['message'],
                                                        textColor: Colors.white,
                                                      );

                                                      ViewService()
                                                          .getAllViewRequestSentNotification(
                                                              '3',context)
                                                          .then((val) {
                                                        streamController
                                                            .add(val);
                                                      });

                                                      ViewService()
                                                          .getMyNotifications()
                                                          .then((val) {
                                                        streamNotificationController
                                                            .add(val);
                                                      });
                                                    } else {
                                                      setState(() {
                                                        centerProgressIndicator =
                                                            false;
                                                      });
                                                    }
                                                  },
                                                  child: Text(
                                                    "Clear",
                                                    style:
                                                        GoogleFonts.montserrat(
                                                      fontSize: 12.0,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Divider(
                                              color: Colors.grey[600],
                                              thickness: 1,
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Visibility(
                                        visible: false,
                                        child: Positioned(
                                          top: 0,
                                          left: 0,
                                          right: 0,
                                          child: Center(
                                            child: Container(
                                              height: 30,
                                              width: 30,
                                              margin: EdgeInsets.all(5),
                                              child:
                                                  CircularProgressIndicator(),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
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
                    ],
                  ),
                ],
              ),
              Visibility(
                visible: centerProgressIndicator,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
