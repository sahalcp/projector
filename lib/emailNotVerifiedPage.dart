import 'dart:async';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projector/apis/authService.dart';
import 'package:projector/resetPasswordScreen.dart';
import 'package:projector/signInScreen.dart';
import 'package:projector/data/userData.dart';

// import 'package:google_fonts/google_fonts.dart';
import 'package:projector/signUpScreen.dart';
import 'package:projector/style.dart';
import 'package:projector/widgets/widgets.dart';

import 'package:projector/getStartedScreen.dart';
import 'package:projector/startWatching.dart';
// import 'package:projector/widgets/widgets.dart';

class EmailNotVerifiedScreen extends StatefulWidget {
  EmailNotVerifiedScreen({
    this.email,
    this.password
  });

  final String email;
  final String password;

  @override
  _EmailNotVerifiedScreenState createState() => _EmailNotVerifiedScreenState();
}

class _EmailNotVerifiedScreenState extends State<EmailNotVerifiedScreen> {
  bool loading = false;
  Timer _timer;
  Timer expirytimer;
  //int _expireTime = 20;
  var expireTimeGlobal;
  var _convertedTime = "00:00";
  var message;

  void startExpiryTimer(var _expireTime) {
    expireTimeGlobal = _expireTime;
    if (expirytimer != null) {
      expirytimer.cancel();
      expirytimer = null;
    }
    const oneSec = const Duration(seconds: 1);
    expirytimer = new Timer.periodic(
      oneSec,
      (Timer timer) {
        print("timer6 --->");
        if (expireTimeGlobal == 0) {
          print("timer2 --->");
          setState(() {
            print("timer3 --->");
            timer.cancel();
          });
        } else {
          print("timer4 --->");
          //setState(() {
          print("timer5 --->");
          expireTimeGlobal--;
          _convertedTime = intToTimeLeft(expireTimeGlobal);
          //});
        }
      },
    );
  }

  void getCallBackTime() async {
    var data =
        await AuthService().generateVerificationCode(email: widget.email);
    if (data['success'] == true) {
      var _expireTime = data['expire_in'];
      startExpiryTimer(_expireTime);
    }
  }

  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 10), (timer) async {
      var emailData = await AuthService().getEmailVerifyStatus(email: widget.email);
      if (emailData['success'] == true) {
        if (emailData['is_email_verified'] == '1') {

          /// call the signIn Api for getting user data and token
          var signInData =
          await AuthService().signIn(widget.email, widget.password);
          if (signInData['success'] == true) {
            FocusScope.of(context).unfocus();
            await UserData().setUserLogged();
            await UserData()
                .setUserToken(signInData['data']['token']);
            await UserData().setUserId(signInData['data']['id']);
            await UserData()
                .setFirstName(signInData['data']['firstname']);


            if (signInData['data']['is_email_verified'] == "1") {
              navigateReplace(context, StartWatchingScreen());

            }
          } else {
            setState(() {
              loading = false;
            });
          }

          _timer.cancel();
        } else {}
      }
    });
  }

  String intToTimeLeft(int value) {
    int h, m, s;

    h = value ~/ 3600;

    m = ((value - h * 3600)) ~/ 60;

    s = value - (h * 3600) - (m * 60);

    String hourLeft =
        h.toString().length < 2 ? "0" + h.toString() : h.toString();

    String minuteLeft =
        m.toString().length < 2 ? "0" + m.toString() : m.toString();

    String secondsLeft =
        s.toString().length < 2 ? "0" + s.toString() : s.toString();

    String result = "$minuteLeft:$secondsLeft";

    return result;
  }

  @override
  void initState() {
    getCallBackTime();
    startTimer();
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    expirytimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return SafeArea(
      bottom: false,
      top: false,
      child: Scaffold(
        backgroundColor: appBgColor,
        appBar: AppBar(
          centerTitle: false,
          // backgroundColor: Color(0xff1A1D2A),
          backgroundColor: appBgColor,
          elevation: 0,
          leading: IconButton(
            onPressed: () {
              navigateRemoveLeft(
                  context,
                  SignInScreen(
                    email: "",
                  ));
              // if (Navigator.canPop(context)) {
              //   Navigator.pop(context);
              // } else {
              //   SystemNavigator.pop();
              // }
            },
            icon: Icon(Icons.arrow_back_ios),
            color: Colors.white,
          ),
          titleSpacing: 0.0,
          title: Transform(
            transform: Matrix4.translationValues(-15.0, 0.0, 0.0),
            child: Text(
              "Back",
              style: GoogleFonts.montserrat(
                color: Colors.white,
                fontSize: 20.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(width * 0.05),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image(
                      height: height * 0.09738,
                      width: width * 0.7,
                      image: AssetImage('images/newLogoText.png'),
                    ),
                  ],
                ),
                SizedBox(height: height * 0.05),
                SizedBox(height: height * 0.02),
                SizedBox(height: 50),
                Container(
                  child: FutureBuilder(
                    future: AuthService()
                        .generateVerificationCode(email: widget.email),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        print("timer1 --->${widget.email}");
                        if (snapshot.data['success'] == true) {
                          message = snapshot.data['message'];

                          ///---Call expiry timer
                          return Container(
                              child: Column(children: [
                            Text(
                              '$message',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.montserrat(
                                fontSize: 14.0,
                                color: Colors.white,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            SizedBox(height: height * 0.02),
                            Container(
                              child: expireTimeGlobal == 0
                                  ? InkWell(
                                      onTap: () async {
                                        var data = await AuthService()
                                            .generateVerificationCode(
                                                email: widget.email);
                                        if (data['success'] == true) {
                                          message = snapshot.data['message'];
                                          expireTimeGlobal =
                                              snapshot.data['expire_in'];
                                          startExpiryTimer(expireTimeGlobal);
                                        } else {
                                          message = snapshot.data['message'];
                                          expireTimeGlobal =
                                              snapshot.data['expire_in'];
                                        }
                                      },
                                      child: Container(
                                          margin: EdgeInsets.all(2.0),
                                          height: height * 0.06,
                                          width: 100,
                                          decoration: BoxDecoration(
                                            color: Color(0xff5AA5EF),
                                            borderRadius:
                                                BorderRadius.circular(6.0),
                                          ),
                                          child: Center(
                                            child: Text(
                                              'Resend',
                                              style: GoogleFonts.montserrat(
                                                fontSize: 16.0,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          )),
                                    )
                                  : Text(
                                      //'Link expires in : $_convertedTime',
                                      'Link expires in : 15 minutes ',
                                      style: GoogleFonts.montserrat(
                                        fontSize: 14.0,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                            ),
                          ]));
                        } else {
                          if (snapshot.data['success'] == false) {
                            message = snapshot.data['message'];
                            var _expireTime = snapshot.data['expire_in'];
                            return Container(
                                child: Column(
                              children: [
                                Text(
                                  '$message',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.montserrat(
                                    fontSize: 14.0,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                SizedBox(height: height * 0.04),
                                InkWell(
                                  onTap: () async {
                                    var data = await AuthService()
                                        .generateVerificationCode(
                                            email: widget.email);
                                    if (data['success'] == true) {
                                      message = snapshot.data['message'];
                                      _expireTime = snapshot.data['expire_in'];
                                      startExpiryTimer(_expireTime);
                                    } else {
                                      message = snapshot.data['message'];
                                      _expireTime = snapshot.data['expire_in'];
                                    }
                                  },
                                  child: Container(
                                      margin: EdgeInsets.all(2.0),
                                      height: height * 0.06,
                                      width: 100,
                                      decoration: BoxDecoration(
                                        color: Color(0xff5AA5EF),
                                        borderRadius:
                                            BorderRadius.circular(6.0),
                                      ),
                                      child: Center(
                                        child: Text(
                                          'Resend',
                                          style: GoogleFonts.montserrat(
                                            fontSize: 16.0,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      )),
                                ),
                              ],
                            ));
                          }
                          return Container();
                        }
                      } else {
                        return Container();
                      }
                    },
                  ),
                ),
                SizedBox(height: height * 0.02),
                SizedBox(height: height * 0.02),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
