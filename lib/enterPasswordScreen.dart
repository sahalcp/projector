import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:projector/apis/authService.dart';
import 'package:projector/data/userData.dart';
import 'package:projector/forgotPasswordPage.dart';
// import 'package:google_fonts/google_fonts.dart';
import 'package:projector/getStartedScreen.dart';
import 'package:projector/sideDrawer/dashboard.dart';
import 'package:projector/sideDrawer/listVideo.dart';
import 'package:projector/startWatching.dart';
import 'package:projector/style.dart';
import 'package:projector/subscriptionScreen.dart';
import 'package:projector/widgets/logo.dart';
import 'package:projector/widgets/widgets.dart';
import 'package:sizer/sizer.dart';

import 'emailNotVerifiedPage.dart';

// import '../createPasswordScreen.dart';

class EnterPasswordScreen extends StatefulWidget {
  EnterPasswordScreen({@required this.email});
  final String email;
  @override
  _EnterPasswordScreenState createState() => _EnterPasswordScreenState();
}

class _EnterPasswordScreenState extends State<EnterPasswordScreen> {
  bool hidePassword = false, loading = false;
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  String password = '';
  FocusNode node = FocusNode();
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
        bottom: false,
        top: false,
        child: Scaffold(
          key: scaffoldKey,
          // backgroundColor: Color(0xff1A1D2A),
          backgroundColor: appBgColor,
          body: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(width * 0.05),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: height * 0.15),
                    Center(
                      child: Image(
                        height: deviceType == DeviceType.mobile? height * 0.09738 : 130,
                        width: width,
                        image: AssetImage('images/newLogoText.png'),
                      ),
                    ),
                    SizedBox(height: height * 0.085),
                    // Center(
                    //   child: Text(
                    //     'STEP 2 OF 2',
                    //     style: GoogleFonts.montserrat(
                    //       color: Colors.white,
                    //       fontSize: 16.0,
                    //     ),
                    //   ),
                    // ),
                    // SizedBox(height: 20),
                    Center(
                      child: Text(
                        'Enter a password',
                        style: GoogleFonts.montserrat(
                          fontSize: deviceType == DeviceType.mobile? 16.0: 28.0,
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    SizedBox(height: height * 0.02),
                    Container(
                      //height: height * 0.06,
                      child: TextFormField(
                        focusNode: node,
                        style: GoogleFonts.montserrat(
                          color: Colors.white,
                          // letterSpacing: 5.0,
                          fontSize: deviceType == DeviceType.mobile? 18.0 : 25.0,
                        ),
                        validator: (val) {
                          if (val.length < 6)
                            return 'Should have minimum 6 characters';
                        },
                        onChanged: (val) {
                          password = val;
                        },
                        obscureText: !hidePassword,
                        decoration: InputDecoration(
                          // contentPadding: EdgeInsets.all(6),
                          suffixIcon: FlatButton(
                            child: hidePassword
                                ? Icon(
                              Icons.visibility,
                              color: Colors.white.withOpacity(0.6),
                            )
                                : Icon(
                              Icons.visibility_off,
                              color: Colors.white.withOpacity(0.6),
                            ),
                            onPressed: () {
                              setState(() {
                                hidePassword = !hidePassword;
                              });
                            },
                          ),
                          filled: true,
                          fillColor: Color(0xff31343E),
                          hintText: 'Password',
                          hintStyle: GoogleFonts.montserrat(
                            color: Color(0xff8E8E8E),
                            fontSize: deviceType == DeviceType.mobile? 13.0 : 20.0,
                            fontWeight: FontWeight.w400,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.transparent,
                            ),
                            borderRadius: BorderRadius.circular(6.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xff6D6F76),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(6.0),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xff6D6F76),
                            ),
                            borderRadius: BorderRadius.circular(6.0),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.only(left: 12.0),
                      child: Text(
                        '( Case Sensitive )',
                        style: GoogleFonts.montserrat(
                          fontSize: deviceType == DeviceType.mobile? 10.0 : 14.0,
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 2),
                      child: InkWell(
                        onTap: () async {
                          if (formKey.currentState.validate()) {
                            setState(() {
                              loading = true;
                            });
                            var data = await AuthService()
                                .signIn(widget.email, password);
                            if (data['success'] == true) {
                              FocusScope.of(context).unfocus();
                              await UserData()
                                  .setUserToken(data['data']['token']);
                              await UserData().setUserId(data['data']['id']);
                              await UserData()
                                  .setFirstName(data['data']['firstname']);
                              // await UserData().setUserStarted(started: true);
                              // if (data['isNewUser'])
                              //   navigateRemoveLeft(context, GetStartedScreen());
                              // else
                              if (data['data']['is_email_verified'] == "1") {
                                navigateReplace(context, StartWatchingScreen());
                                await UserData().setUserLogged();
                              } else {
                                navigateReplace(
                                    context,
                                    EmailNotVerifiedScreen(
                                      email: widget.email,
                                    ));
                              }
                              print("sucessss");
                            } else {
                              setState(() {
                                loading = false;
                              });
                              //Passwords are case sensitive, your entered password is incorrect. Please re enter

                              scaffoldKey.currentState.showSnackBar(
                                SnackBar(
                                  content: Text(
                                      '${data['message']}'),
                                ),
                              );
                            }
                            setState(() {
                              loading = false;
                            });
                          }
                        },
                        child: Container(
                          height:deviceType == DeviceType.mobile? height * 0.06 : height * 0.08,
                          width: width,
                          decoration: BoxDecoration(
                            color: Color(0xff5AA5EF),
                            borderRadius: BorderRadius.circular(6.0),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Center(
                              child: loading
                                  ? CircularProgressIndicator(
                                backgroundColor: Colors.white,
                              )
                                  : Text(
                                'LOG IN',
                                style: GoogleFonts.montserrat(
                                  fontSize: deviceType == DeviceType.mobile? 14.0 : 20.0,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 12.0,
                        top: 10.0,
                      ),
                      child: InkWell(
                        onTap: () {
                          navigate(
                              context,
                              ForgotPasswordScreen(
                                passedEmail: widget.email,
                              ));
                        },
                        child: Text(
                          'Forgot Password?',
                          style: GoogleFonts.montserrat(
                            fontSize: deviceType == DeviceType.mobile? 10.0 : 14.0,
                            color: Color(0xff85868F),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });

  }
}
