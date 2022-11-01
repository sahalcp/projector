import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:projector/apis/authService.dart';
import 'package:projector/data/userData.dart';
import 'package:projector/emailNotVerifiedPage.dart';
// import 'package:google_fonts/google_fonts.dart';
import 'package:projector/getStartedScreen.dart';
import 'package:projector/startWatching.dart';
import 'package:projector/style.dart';
import 'package:projector/subscriptionScreen.dart';
import 'package:projector/widgets/logo.dart';
import 'package:projector/widgets/widgets.dart';
import 'package:sizer/sizer.dart';

// ignore: must_be_immutable
class CreatePasswordScreen extends StatefulWidget {
  CreatePasswordScreen({this.email, this.firstName, this.lastName});

  final String email;
  final String firstName;
  final String lastName;
  @override
  _CreatePasswordScreenState createState() => _CreatePasswordScreenState();
}

class _CreatePasswordScreenState extends State<CreatePasswordScreen> {
  bool hidePassword = false, loading = false;
  String password = '', status = 'Weak';
  Color sliderColor = Colors.red;
  double sliderValue = 0.0;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Sizer(builder: (context, orientation, deviceType) {
      return SafeArea(
        bottom: false,
        top: false,
        child: Scaffold(
          backgroundColor: appBgColor,
          key: scaffoldKey,
          body: SingleChildScrollView(
            child: Container(
              // height: height,
              width: width,
              // padding: EdgeInsets.all(14.0),
              child: Column(
                children: <Widget>[
                  SizedBox(height: height * 0.05),
                  Padding(
                    padding: EdgeInsets.all(14.0),
                    child: loginButton(context: context,width: width,deviceType: deviceType),
                  ),

                  SizedBox(height: height * 0.07),
                  Center(
                    child: Image(
                      height: deviceType == DeviceType.mobile? height * 0.09738 : 130,
                      width: width,
                      image: AssetImage('images/newLogoText.png'),
                    ),
                  ),

                  SizedBox(height: height * 0.08),
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
                  Text(
                    'Enter a password',
                    style: GoogleFonts.montserrat(
                      fontSize: deviceType == DeviceType.mobile? 16.0: 28.0,
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  // Text(
                  //   '${widget.firstName +","+ widget.lastName}',
                  //   style: GoogleFonts.montserrat(
                  //     fontSize: 16.0,
                  //     color: Colors.white,
                  //     fontWeight: FontWeight.w700,
                  //   ),
                  // ),
                  SizedBox(height: height * 0.02),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 14.0),
                   // height: height * 0.06,
                    child: TextFormField(
                      style: GoogleFonts.montserrat(
                        color: Colors.white,
                        // letterSpacing: 5.0,
                        fontSize: deviceType == DeviceType.mobile? 18.0 : 25.0,
                      ),
                      // obscuringCharacter: '.',
                      obscureText: !hidePassword,
                      onChanged: (val) {
                        password = val;
                        if (val.length <= 4) {
                          setState(() {
                            sliderValue = 0.1 * val.length;
                            // print(sliderValue);
                            status = 'Weak';
                            sliderColor = Colors.red;
                          });
                        } else if (val.length > 4 && val.length < 8) {
                          setState(() {
                            sliderValue = 0.1 * val.length;
                            // print(sliderValue);
                            status = 'Medium';
                            sliderColor = Colors.blue;
                          });
                        } else if (val.length > 8) {
                          setState(() {
                            if (sliderValue != 1.0) {
                              sliderValue = 0.1 * val.length;
                              // print(sliderValue);
                              status = 'Strong';
                              sliderColor = Colors.green;
                            }
                          });
                        }
                      },
                      // validator: (val) {},
                      decoration: InputDecoration(
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
                      ),
                    ),
                  ),

                  SliderTheme(
                    data: SliderThemeData(
                      activeTrackColor: sliderColor,
                      inactiveTrackColor: Color(0xff3D3F47),
                      thumbShape: SliderComponentShape.noThumb,
                      trackHeight: 3.0,
                    ),
                    child: Slider(
                      value: sliderValue,
                      onChanged: (val) {},
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 22.0),
                    child: Row(
                      children: <Widget>[
                        Container(
                          width: width * 0.74,
                          child: Text(
                            'Use a minimum of 6 characters (case sensitive)\nwith at lease one number and one special character.',
                            style: GoogleFonts.montserrat(
                              color: Colors.white,
                              fontSize: deviceType == DeviceType.mobile? 10.0 : 14.0,
                              height: 1.5,
                              fontWeight: FontWeight.w400,
                              // letterSpacing: 0.4
                            ),
                            textAlign: TextAlign.start,
                          ),
                        ),
                        Flexible(
                          child: Container(
                            child: Align(
                              alignment: Alignment.topRight,
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 17.0),
                                child: Text(
                                  '$status',
                                  style: TextStyle(
                                    color: Color(0xff5AA5EF),
                                    fontSize: deviceType == DeviceType.mobile? 10.0 : 14.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  // SizedBox(height: height * 0.01),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 22.0,
                      vertical: 16.0,
                    ),
                    child: Row(
                      children: <Widget>[
                        Container(
                          height: height * 0.07,
                          width: width * 0.006,
                          color: Color(0xff5AA5EF),
                        ),
                        Container(
                          padding: EdgeInsets.all(14.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Text(
                                  'You’ll be using this email to log in:',
                                  style: GoogleFonts.montserrat(
                                    color: Colors.white,
                                    fontSize: deviceType == DeviceType.mobile? 12.0 : 16.0,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Text(
                                  '${widget.email}',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: deviceType == DeviceType.mobile? 12.0 : 16.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      if (password.length >= 6) {
                        setState(() {
                          loading = true;
                        });

                        ///----From signup
                        var data = await AuthService().signUp(
                            email: widget.email,
                            password: password,
                            firstName:
                            widget.firstName != null ? widget.firstName : "",
                            lastName:
                            widget.lastName != null ? widget.lastName : "");
                        // print(data);
                        if (data['success'] == true) {
                          navigateReplace(
                              context,
                              EmailNotVerifiedScreen(
                                email: widget.email,
                                password: password,
                              ));

                        /*  ///---Do signIn after SignUp
                          var SIgnIndata =
                          await AuthService().signIn(widget.email, password);
                          if (SIgnIndata['success'] == true) {
                            FocusScope.of(context).unfocus();
                            //await UserData().setUserLogged();
                            await UserData()
                                .setUserToken(SIgnIndata['data']['token']);
                            await UserData().setUserId(SIgnIndata['data']['id']);
                            await UserData()
                                .setFirstName(SIgnIndata['data']['firstname']);
                            // navigateReplace(context, StartWatchingScreen());
                            print("sucessss");

                            if (SIgnIndata['data']['is_email_verified'] == "1") {
                              navigateReplace(context, StartWatchingScreen());

                              /// timer screen

                            } else {
                              navigateReplace(
                                  context,
                                  EmailNotVerifiedScreen(
                                    email: widget.email,
                                  ));
                            }
                          } else {
                            setState(() {
                              loading = false;
                            });
                          }
                          */
                        }

                        /* var user =
                            await AuthService().signIn(widget.email, password);
                        if(user['success'] == true){
                          await UserData().setUserToken(user['data']['token']);
                          await UserData().setUserId(user['data']['id']);
                          await UserData().setUserLogged();
                          navigateReplace(context, StartWatchingScreen());
                        }else{

                          if(user['email_verified'] == false){
                            /// timer screen
                            navigateReplace(context, EmailNotVerifiedScreen(
                              email: widget.email,
                            ));
                          }
                        }*/

                        else {
                          setState(() {
                            loading = false;
                          });
                          scaffoldKey.currentState.showSnackBar(
                            SnackBar(
                              content: Text(data['message']),
                            ),
                          );
                        }
                        setState(() {
                          loading = false;
                        });
                      } else {
                        scaffoldKey.currentState.showSnackBar(
                          SnackBar(
                            content: Text(
                                'Please enter a stronger password to complete sign-up'),
                          ),
                        );
                      }
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 22.0),
                      height: height * 0.06,
                      width: width,
                      decoration: BoxDecoration(
                        color: Color(0xff5AA5EF),
                        borderRadius: BorderRadius.circular(6.0),
                      ),
                      child: Center(
                        child: loading
                            ? CircularProgressIndicator(
                          backgroundColor: Colors.white,
                        )
                            : Text(
                          'SIGN UP',
                          style: TextStyle(
                            fontSize: deviceType == DeviceType.mobile? 14.0 : 24.0,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
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
  }
}
