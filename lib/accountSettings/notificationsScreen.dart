import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';
import 'package:projector/apis/accountService.dart';
// import 'package:projector/widgets/widgets.dart';

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  showDropDown(context, height, width) {
    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        width,
        height,
        0,
        0,
      ),
      items: [
        PopupMenuItem(
          child: Text(
            'Yes',
            style: GoogleFonts.montserrat(
              fontSize: 13.0,
              fontWeight: FontWeight.w400,
              color: Color(0xffB9B8B8),
            ),
          ),
        ),
        PopupMenuItem(
          child: Text(
            'No',
            style: GoogleFonts.montserrat(
              fontSize: 13.0,
              fontWeight: FontWeight.w400,
              color: Color(0xffB9B8B8),
            ),
          ),
        ),
      ],
    );
  }

  // setNotify(index, notify) {
  //   setState(() {});
  //   if (index == 0) {
  //     notify[0] = true;
  //     notify[1] = false;
  //   } else {
  //     notify[1] = true;
  //     notify[0] = false;
  //   }
  // }

  // List<bool> phoneNotify = [false, false],
  //     emailNotify = [false, false],
  //     pushNotify = [false, false],
  //     subNotify = [false, false];

  changeNotification({
    emailNotification,
    subNotification,
    phoneNotification,
    pushNotification,
    type,
  }) async {
    var res = await AccountService().updateNotifications(
      email: emailNotification,
      sub: subNotification,
      phone: phoneNotification,
      push: pushNotification,
    );
    if (res['success'] == true) {
      Fluttertoast.showToast(
        msg: '$type Notification Updated',
        backgroundColor: Colors.black,
      );
    } else {
      Fluttertoast.showToast(
        msg: 'Try Again',
        backgroundColor: Colors.black,
      );
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    var style = GoogleFonts.poppins(
      fontSize: 18.0,
      color: Color(0xff696969),
      fontWeight: FontWeight.w700,
    );
    return SafeArea(
      child: Scaffold(
        body: Container(
          // color: Color(0xff1A1D2A),
          padding: EdgeInsets.only(right: 10.0),
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // newAppBar(height),
              // SizedBox(height: 25),
              SizedBox(height: height * 0.03),
              Padding(
                padding: EdgeInsets.only(
                  left: 16,
                  top: 10,
                  right: 15.0,
                ),
                child: Row(
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.arrow_back_ios,
                      ),
                    ),
                    SizedBox(
                      width: width * 0.02,
                    ),
                    Text(
                      'Notifications',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(width: width * 0.06)
                  ],
                ),
              ),
              SizedBox(height: 20),
              // Padding(
              //   padding: EdgeInsets.only(left: 30.0),
              //   child: Text(
              //     'Notifications',
              //     style: GoogleFonts.poppins(
              //       fontSize: 24.0,
              //       fontWeight: FontWeight.w700,
              //     ),
              //   ),
              // ),
              // Padding(
              //   padding: EdgeInsets.only(left: 15.0),
              //   child: Text(
              //     'Notifications',
              //     style: GoogleFonts.poppins(
              //       fontSize: 13.0,
              //       fontWeight: FontWeight.w700,
              //       color: Color(0xff32CE71),
              //     ),
              //   ),
              // ),
              SizedBox(height: 10),
              FutureBuilder(
                future: AccountService().getProfile(),
                builder: (contetx, snapshot) {
                  if (snapshot.hasData) {
                    //print(snapshot.data);
                    var emailNotification = snapshot.data['email_notification'];
                    var phoneNotification = snapshot.data['phone_notification'];
                    var subNotification = snapshot.data['sub_notification'];
                    var pushNotification = snapshot.data['push_notification'];

                    return Expanded(
                      child: Container(
                        width: width,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 35),
                            Container(
                              padding: EdgeInsets.only(left: 30.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Phone notifications',
                                        maxLines: 2,
                                        style: style,
                                      ),
                                      Container(
                                        width: width * 0.34,
                                        height: 36,
                                        child: LiteRollingSwitch(
                                          value: phoneNotification == '1'
                                              ? true
                                              : false,
                                          textOn: 'Yes',
                                          textOff: 'No',
                                          colorOn: Color(0xff5AA5EF),
                                          colorOff: Color(0xff5AA5EF),
                                          iconOn: Icons.done,
                                          iconOff: Icons.close,
                                          textSize: 15.0,
                                          onChanged: (bool state) async {
                                            changeNotification(
                                                emailNotification:
                                                    emailNotification,
                                                phoneNotification:
                                                    state ? "1" : "0",
                                                subNotification:
                                                    subNotification,
                                                pushNotification:
                                                    pushNotification,
                                                type: 'Phone');
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 50),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Email notifications',
                                        maxLines: 2,
                                        style: style,
                                      ),
                                      SizedBox(width: 6),
                                      // InkWell(
                                      //   onTap: () {
                                      //     showDropDown(context, height * 0.45, width);
                                      //   },
                                      //   child: Icon(
                                      //     Icons.arrow_drop_down_circle_outlined,
                                      //   ),
                                      // ),
                                      // ToggleButtons(
                                      //   children: [
                                      //     Text('Yes'),
                                      //     Text('No'),
                                      //   ],
                                      //   isSelected: emailNotify,
                                      //   onPressed: (index) {
                                      //     setNotify(index, emailNotify);
                                      //   },
                                      // ),
                                      Container(
                                        width: width * 0.34,
                                        height: 36,
                                        child: LiteRollingSwitch(
                                          //initial value
                                          value: emailNotification == '1'
                                              ? true
                                              : false,
                                          textOn: 'Yes',
                                          textOff: 'No',
                                          colorOn: Color(0xff5AA5EF),
                                          colorOff: Color(0xff5AA5EF),
                                          iconOn: Icons.done,
                                          iconOff: Icons.close,
                                          textSize: 15.0,
                                          onChanged: (bool state) {
                                            changeNotification(
                                                emailNotification:
                                                    state ? "1" : "0",
                                                phoneNotification:
                                                    phoneNotification,
                                                subNotification:
                                                    subNotification,
                                                pushNotification:
                                                    pushNotification,
                                                type: 'Email');
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 50),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Push notifications',
                                        maxLines: 2,
                                        style: style,
                                      ),
                                      SizedBox(width: 6),
                                      Container(
                                        width: width * 0.34,
                                        height: 36,
                                        child: LiteRollingSwitch(
                                          //initial value
                                          value: pushNotification == '1'
                                              ? true
                                              : false,
                                          textOn: 'Yes',
                                          textOff: 'No',
                                          colorOn: Color(0xff5AA5EF),
                                          colorOff: Color(0xff5AA5EF),
                                          iconOn: Icons.done,
                                          iconOff: Icons.close,
                                          textSize: 15.0,
                                          onChanged: (bool state) {
                                            changeNotification(
                                                emailNotification:
                                                    emailNotification,
                                                phoneNotification:
                                                    phoneNotification,
                                                subNotification:
                                                    subNotification,
                                                pushNotification:
                                                    state ? "1" : "0",
                                                type: 'Push Notification');
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 50),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        width: width * 0.5,
                                        child: Text(
                                          'Subscription notifications',
                                          maxLines: 2,
                                          textAlign: TextAlign.start,
                                          style: style,
                                        ),
                                      ),
                                      // SizedBox(width: 10),
                                      // InkWell(
                                      //   onTap: () {
                                      //     showDropDown(context, height * 0.66, width);
                                      //   },
                                      //   child: Icon(
                                      //     Icons.arrow_drop_down_circle_outlined,
                                      //   ),
                                      // ),
                                      // ToggleButtons(
                                      //   children: [
                                      //     Text('Yes'),
                                      //     Text('No'),
                                      //   ],
                                      //   isSelected: subNotify,
                                      //   onPressed: (index) {
                                      //     setNotify(index, subNotify);
                                      //   },
                                      // ),
                                      Container(
                                        width: width * 0.34,
                                        height: 36,
                                        child: LiteRollingSwitch(
                                          //initial value
                                          value: subNotification == '1'
                                              ? true
                                              : false,
                                          textOn: 'Yes',
                                          textOff: 'No',
                                          colorOn: Color(0xff5AA5EF),
                                          colorOff: Color(0xff5AA5EF),
                                          iconOn: Icons.done,
                                          iconOff: Icons.close,
                                          textSize: 15.0,
                                          onChanged: (bool state) {
                                            changeNotification(
                                                emailNotification:
                                                    emailNotification,
                                                phoneNotification:
                                                    phoneNotification,
                                                subNotification:
                                                    state ? "1" : "0",
                                                pushNotification:
                                                    pushNotification,
                                                type:
                                                    'Subscription Notification');
                                          },
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            )
                          ],
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
            ],
          ),
        ),
      ),
    );
  }
}

//  SizedBox(height: height * 0.01),
//               Row(children: <Widget>[
//                 InkWell(
//                   onTap: () {
//                     Navigator.pop(context);
//                   },
//                   child: Icon(
//                     Icons.arrow_back_ios,
//                   ),
//                 ),
//                 SizedBox(
//                   width: width * 0.02,
//                 ),
//                 Text(
//                   'Account Settings',
//                   style: TextStyle(
//                     fontSize: 20,
//                     color: Colors.black,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//                 SizedBox(width: width * 0.06)
//               ]),
//               SizedBox(height: 20),
//               Text(
//                 'Notifications',
//                 style: GoogleFonts.poppins(
//                   fontSize: 24.0,
//                   fontWeight: FontWeight.w700,
//                 ),
//               ),
//               SizedBox(height: 50),
//               Text(
//                 'Phone notifications',
//                 maxLines: 2,
//                 style: GoogleFonts.poppins(
//                   fontSize: 22.0,
//                   fontWeight: FontWeight.w700,
//                 ),
//               ),
//               SizedBox(height: 50),
//               Text(
//                 'Email notifications',
//                 maxLines: 2,
//                 style: GoogleFonts.poppins(
//                   fontSize: 22.0,
//                   fontWeight: FontWeight.w700,
//                 ),
//               ),
//               SizedBox(height: 50),
//               Text(
//                 'Push notifications',
//                 maxLines: 2,
//                 style: GoogleFonts.poppins(
//                   fontSize: 22.0,
//                   fontWeight: FontWeight.w700,
//                 ),
//               ),
//               SizedBox(height: 50),
//               Text(
//                 'Subscription notifications',
//                 maxLines: 2,
//                 style: GoogleFonts.poppins(
//                   fontSize: 22.0,
//                   fontWeight: FontWeight.w700,
//                 ),
//               )
