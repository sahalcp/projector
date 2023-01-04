import 'dart:developer';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:projector/apis/authService.dart';

// import 'package:google_fonts/google_fonts.dart';
import 'package:projector/createPasswordScreen.dart';
import 'package:projector/enterPasswordScreen.dart';
import 'package:projector/signInScreen.dart';
import 'package:projector/style.dart';
import 'package:projector/widgets/dialogs.dart';
import 'package:projector/widgets/logo.dart';

// import 'package:projector/signInScreen.dart';
import 'package:projector/widgets/widgets.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

import 'constant.dart';

class SignUpScreen extends StatefulWidget {
  SignUpScreen({this.email});

  final String email;

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool checked = false, loading = false;
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldMessengerState>();
  String email = '';
  String firstName = '';
  String lastName = '';
  // final textController = TextEditingController();
  TextEditingController textController;

  @override
  void initState() {
    textController = TextEditingController(text: widget.email);
    email = widget.email;
    super.initState();
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //textController.text = widget.email!=null?widget.email:"";
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Sizer(builder: (context, orientation, deviceType) {
      if (deviceType == DeviceType.mobile) {
        SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
      } else {
        SystemChrome.setPreferredOrientations(
            [DeviceOrientation.landscapeRight]);
      }
      return SafeArea(
        top: false,
        bottom: false,
        child: Scaffold(
            backgroundColor: appBgColor,
            key: scaffoldKey,
            body: GestureDetector(
              onTap: () {
                FocusScope.of(context).requestFocus(new FocusNode());
              },
              child: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.all(14.0),
                  width: width,
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: height * 0.05),
                      loginButton(
                          context: context,
                          width: width,
                          deviceType: deviceType),
                      SizedBox(height: height * 0.08),
                      Center(
                        child: Image(
                          height: deviceType == DeviceType.mobile
                              ? height * 0.09738
                              : 130,
                          width: width,
                          image: AssetImage('images/newLogoText.png'),
                        ),
                      ),
                      SizedBox(height: height * 0.08),
                      // Center(
                      //   child: Text(
                      //     'STEP 1 OF 2',
                      //     style: GoogleFonts.montserrat(
                      //       color: Colors.white,
                      //       fontSize: 16.0,
                      //     ),
                      //   ),
                      // ),
                      // SizedBox(height: 20),
                      Text(
                        'Enter your email',
                        style: GoogleFonts.montserrat(
                          fontSize:
                              deviceType == DeviceType.mobile ? 18.0 : 28.0,
                          color: Color(0xffEFEFF0),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: height * 0.02),
                      Form(
                        key: formKey,
                        child: Container(
                          // height: height * 0.08,
                          child: TextFormField(
                            controller: textController,
                            style: GoogleFonts.montserrat(
                              color: Colors.white,
                              fontSize:
                                  deviceType == DeviceType.mobile ? 16.0 : 25.0,
                            ),
                            validator: (val) {
                              if (!EmailValidator.validate(
                                  textController.text.trim()))
                                return 'Enter valid Email';
                              return null;
                            },
                            onChanged: (val) {
                              email = val;
                            },
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Color(0xff31343E),
                              hintText: 'Email',
                              hintStyle: GoogleFonts.montserrat(
                                color: Color(0xff8E8E8E),
                                fontSize: deviceType == DeviceType.mobile
                                    ? 13.0
                                    : 20.0,
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
                                borderRadius: BorderRadius.circular(6.0),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: height * 0.016),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            child: Flexible(
                              child: TextFormField(
                                //focusNode: _focusNodeFirstName,
                                //controller: emailCon,
                                style: GoogleFonts.montserrat(
                                  color: Colors.white,
                                  fontSize: deviceType == DeviceType.mobile
                                      ? 16.0
                                      : 25.0,
                                ),
                                onChanged: (val) {
                                  firstName = val;
                                },
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Color(0xff31343E),
                                  hintText: 'First Name',
                                  hintStyle: GoogleFonts.montserrat(
                                    color: Color(0xff8E8E8E),
                                    fontSize: deviceType == DeviceType.mobile
                                        ? 13.0
                                        : 20.0,
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
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          Container(
                            child: Flexible(
                              child: TextFormField(
                                //focusNode: _focusNodeFirstName,
                                //controller: emailCon,
                                style: GoogleFonts.montserrat(
                                  color: Colors.white,
                                  fontSize: deviceType == DeviceType.mobile
                                      ? 16.0
                                      : 25.0,
                                ),
                                onChanged: (val) {
                                  lastName = val;
                                },
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Color(0xff31343E),
                                  hintText: 'Last Name',
                                  hintStyle: GoogleFonts.montserrat(
                                    color: Color(0xff8E8E8E),
                                    fontSize: deviceType == DeviceType.mobile
                                        ? 13.0
                                        : 20.0,
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
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: height * 0.016),
                      Row(
                        children: <Widget>[
                          InkWell(
                            onTap: () {
                              setState(() {
                                checked = !checked;
                              });
                            },
                            child: Container(
                              margin: EdgeInsets.only(
                                  left: 25, top: 14, bottom: 14, right: 12),
                              height: height * 0.03,
                              width: width * 0.06,
                              decoration: BoxDecoration(
                                color: Colors.black,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  width: 3.0,
                                  color: Color(0xff5AA5EF),
                                ),
                              ),
                              child: checked
                                  ? Center(
                                      child: Icon(
                                        Icons.done,
                                        size: 20,
                                        color: Color(0xff5AA5EF),
                                      ),
                                    )
                                  : SizedBox(),
                            ),
                          ),
                          Text(
                            'I have read and understood the Terms of Use, \nSubscriber Agreement  and Privacy Policy.',
                            style: GoogleFonts.montserrat(
                              fontSize:
                                  deviceType == DeviceType.mobile ? 10.0 : 14.0,
                              color: Colors.white,
                              height: 1.5,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: height * 0.04),
                      Container(
                        width: width,
                        padding: EdgeInsets.only(
                          left: width * 0.03,
                          right: width * 0.03,
                          top: height * 0.03,
                          bottom: height * 0.02,
                        ),
                        // height: height * 0.22,
                        decoration: BoxDecoration(
                          color: Color(0xff31343E),
                          borderRadius: BorderRadius.circular(6.0),
                        ),
                        child: Column(
                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            RichText(
                                text: TextSpan(children: [
                              TextSpan(
                                  text:
                                      'Projector will use your data to personalize and improve your Projector experience and to send you information about Projector.  You can change your communication preferences anytime.  We may use your data as described in our ',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: deviceType == DeviceType.mobile
                                        ? 10.0
                                        : 14.0,
                                    height: 1.5,
                                    fontWeight: FontWeight.w400,
                                  )),
                              TextSpan(
                                text: 'Privacy Policy',
                                style: TextStyle(
                                  fontSize: deviceType == DeviceType.mobile
                                      ? 10.0
                                      : 14.0,
                                  height: 1.5,
                                  color: Colors.blue,
                                  fontWeight: FontWeight.w600,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    launch(privacyUrl);
                                  },
                              ),
                              TextSpan(
                                  text:
                                      ', including sharing it with the family of companies.  By clicking “Agree & Continue”, you agree to our  Subscriber Agreement and acknowledge that you have read our Privacy Policy.',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: deviceType == DeviceType.mobile
                                        ? 10.0
                                        : 14.0,
                                    height: 1.5,
                                    fontWeight: FontWeight.w400,
                                  )),
                              TextSpan(
                                text: 'Terms of Use',
                                style: TextStyle(
                                  fontSize: deviceType == DeviceType.mobile
                                      ? 10.0
                                      : 14.0,
                                  height: 1.5,
                                  color: Colors.blue,
                                  fontWeight: FontWeight.w600,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    launch(termsAndConditionsUrl);
                                  },
                              ),
                              TextSpan(
                                  text: ', ',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10.0,
                                    height: 1.5,
                                    fontWeight: FontWeight.w400,
                                  )),
                              TextSpan(
                                text: 'Subscriber Agreement',
                                style: TextStyle(
                                  fontSize: deviceType == DeviceType.mobile
                                      ? 10.0
                                      : 14.0,
                                  height: 1.5,
                                  color: Colors.blue,
                                  fontWeight: FontWeight.w600,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    launch(subscriberAgreementUrl);
                                  },
                              ),
                              TextSpan(
                                  text:
                                      ' and acknowledge that you have read our Privacy Policy.',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: deviceType == DeviceType.mobile
                                        ? 10.0
                                        : 14.0,
                                    height: 1.5,
                                    fontWeight: FontWeight.w400,
                                  )),
                            ])),
                            SizedBox(height: height * 0.03),
                            InkWell(
                              onTap: () async {
                                if (formKey.currentState.validate()) {
                                  setState(() {
                                    loading = true;
                                  });
                                  var data =
                                      await AuthService().signUpEmail(email);
                                  if (data['success'] == true) {
                                    // scaffoldKey.currentState.showSnackBar(
                                    //   SnackBar(
                                    //     content: Text('${data['message']}'),
                                    //   ),
                                    // );
                                    navigateLeft(
                                      context,
                                      CreatePasswordScreen(
                                        email: email,
                                        firstName: firstName,
                                        lastName: lastName,
                                      ),
                                    );
                                  } else {
                                    // showAuthDialog(
                                    //   context,
                                    //   height,
                                    //   width,
                                    //   text:
                                    //       'You seem to have an existing projector account, Login instead?',
                                    //   button: 'Log In',
                                    //   onTap: () {
                                    log('not valid');
                                    // navigateLeft(
                                    //   context,
                                    //   EnterPasswordScreen(email: email),
                                    // );

                                    // scaffoldKey.currentState.showSnackBar(
                                    //   SnackBar(
                                    //     content: Text(
                                    //         'You seem to have an existing projector account, Login instead?'),
                                    //   ),
                                    // );
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                            "You seem to have an existing projector account, Login instead?"),
                                      ),
                                    );
                                    scaffoldKey.currentState.showSnackBar(
                                      SnackBar(
                                        content: Text(
                                            "You seem to have an existing projector account, Login instead?"),
                                      ),
                                    );
                                    // navigate(
                                    //   context,
                                    //   CreatePasswordScreen(
                                    //     email: email,
                                    //   ),
                                    // );
                                  }
                                  setState(() {
                                    loading = false;
                                  });
                                }
                                // else {
                                //   scaffoldKey.currentState.showSnackBar(
                                //     SnackBar(
                                //       content: Text(
                                //           'Subscribe For The Updates From Projector'),
                                //     ),
                                //   );
                                // }
                              },
                              child: Container(
                                height: deviceType == DeviceType.mobile
                                    ? height * 0.06
                                    : height * 0.07,
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
                                          'AGREE AND CONTINUE',
                                          style: TextStyle(
                                              fontSize: deviceType ==
                                                      DeviceType.mobile
                                                  ? 13.0
                                                  : 20.0,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600),
                                        ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )),
      );
    });
  }
}
