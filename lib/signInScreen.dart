import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projector/apis/authService.dart';
import 'package:projector/createPasswordScreen.dart';

// import 'package:google_fonts/google_fonts.dart';
import 'package:projector/signUpScreen.dart';
import 'package:projector/enterPasswordScreen.dart';
import 'package:projector/signUpWebViewScreen.dart';
import 'package:projector/style.dart';
import 'package:projector/widgets/logo.dart';
import 'package:projector/widgets/widgets.dart';
import 'package:sizer/sizer.dart';

import 'data/checkConnection.dart';
// import 'package:projector/widgets/widgets.dart';

class SignInScreen extends StatefulWidget {
  SignInScreen({this.email});

  final String email;

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  String _authStatus = 'Unknown';
  bool loading = false;
  String email = '';
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController emailCon;
  FocusNode node = FocusNode();

  @override
  void initState() {
    //CheckConnectionService().init(scaffoldKey);
    if (widget.email != null) {
      emailCon = TextEditingController(text: widget.email);
      email = widget.email;
    }
    super.initState();
    //WidgetsBinding.instance.addPostFrameCallback((_) => initPlugin());
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  /*Future<void> initPlugin() async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      final TrackingStatus status =
      await AppTrackingTransparency.trackingAuthorizationStatus;
      setState(() => _authStatus = '$status');
      // If the system can show an authorization request dialog
      if (status == TrackingStatus.notDetermined) {
        // Show a custom explainer dialog before the system dialog



        */ /*if (await showCustomTrackingDialog(context)) {


          // Wait for dialog popping animation
          await Future.delayed(const Duration(milliseconds: 200));
          // Request system's tracking authorization dialog
          final TrackingStatus status =
          await AppTrackingTransparency.requestTrackingAuthorization();
          setState(() => _authStatus = '$status');


        }*/ /*


        // Wait for dialog popping animation
        await Future.delayed(const Duration(milliseconds: 200));
        // Request system's tracking authorization dialog
        final TrackingStatus status =
        await AppTrackingTransparency.requestTrackingAuthorization();
        setState(() => _authStatus = '$status');





      }
    } on PlatformException {
      setState(() => _authStatus = 'PlatformException was thrown');
    }

    final uuid = await AppTrackingTransparency.getAdvertisingIdentifier();
    print("UUID: $uuid");
  }

  Future<bool> showCustomTrackingDialog(BuildContext context) async =>
      await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Dear User'),
          content: const Text(
            'We care about your privacy and data security. We keep this app free by showing ads. '
                'Can we continue to use your data to tailor ads for you?\n\nYou can change your choice anytime in the app settings. '
                'Our partners will collect data and use a unique identifier on your device to show you ads.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text("I'll decide later"),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Allow tracking'),
            ),
          ],
        ),
      ) ??
          false;*/

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Sizer(builder: (context, orientation, deviceType){
      if(deviceType == DeviceType.mobile){
        SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
      }else{
        SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeRight]);
      }
    return SafeArea(
  bottom: false,
  top: false,
  child: Scaffold(
      backgroundColor: appBgColor,
      key: scaffoldKey,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: SingleChildScrollView(
          child: Container(
            height: height,
            width: width,
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

                      //     LogoExpanded(
                      //   width: width,
                      //   height: height * 0.09738,
                      // )
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
                    Center(
                      child: Text(
                        'Log in with your email',
                        style: GoogleFonts.montserrat(
                          fontSize: deviceType == DeviceType.mobile? 16.0: 28.0,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: height * 0.02),
                    Container(
                      // height: height * 0.06,
                      child: TextFormField(
                        focusNode: node,
                        controller: emailCon,
                        style: GoogleFonts.montserrat(
                          color: Colors.white,
                          fontSize: deviceType == DeviceType.mobile? 16.0 : 25.0,
                        ),
                        // validator: (val) {
                        //   if (!EmailValidator.validate(email))
                        //     return 'Not a valid email';
                        //   return null;
                        // },
                        onChanged: (val) {
                          email = val;
                        },
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Color(0xff31343E),
                          hintText: 'Enter your email',
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
                          // errorBorder: OutlineInputBorder(
                          //   borderRadius: BorderRadius.circular(5.0),
                          // ),
                        ),
                      ),
                    ),
                    SizedBox(height: height * 0.02),
                    InkWell(
                      onTap: () async {

                        if(email.isEmpty){
                          Fluttertoast.showToast(msg: 'Enter email', backgroundColor: Colors.white,textColor: Colors.black);
                        }else if (!EmailValidator.validate(email)){
                          Fluttertoast.showToast(msg: 'Enter valid email', backgroundColor: Colors.white,textColor: Colors.black);
                        }else{
                          setState(() {
                            loading = true;
                          });
                          var data =
                          await AuthService().signInEmail(email.trim());
                          if (data['success'] == true) {
                            navigateLeft(
                              context,
                              EnterPasswordScreen(email: email),
                            );
                          }else{
                          /*  navigateLeft(
                              context,
                              SignUpScreen(email: email),
                            );*/
                            navigateLeft(context, SignUpWebViewScreen());
                          }
                          setState(() {
                            loading = false;
                          });

                        }

                        /*if (formKey.currentState.validate()) {
                                setState(() {
                                  loading = true;
                                });
                                var data =
                                    await AuthService().signInEmail(email.trim());
                                if (data['success'] == true) {
                                  navigateLeft(
                                    context,
                                    EnterPasswordScreen(email: email),
                                  );
                                } else {
                                  // showAuthDialog(
                                  //   context,
                                  //   height,
                                  //   width,
                                  //   text:
                                  //       'New to Projector stream?, please signup to continue.',
                                  //   button: 'Sign Up',
                                  //   onTap: () {
                                  navigateLeft(
                                    context,
                                    //CreatePasswordScreen(email: email),
                                    SignUpScreen(email: email),
                                  );
                                  // },
                                  // );
                                  // scaffoldKey.currentState.showSnackBar(
                                  //   SnackBar(
                                  //     content: Text(
                                  //         'New to Projector stream, please signup to continue.'),
                                  //   ),
                                  // );
                                }
                                setState(() {
                                  loading = false;
                                });
                              }*/
                      },
                      child: Container(
                        margin: EdgeInsets.all(2.0),
                        height: deviceType == DeviceType.mobile? height * 0.06 : height * 0.08,
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
                            'CONTINUE',
                            style: GoogleFonts.montserrat(
                              fontSize: deviceType == DeviceType.mobile? 16.0: 25.0,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: height * 0.02),
                    InkWell(
                      onTap: () {
                        //navigateLeft(context, SignUpScreen());
                        navigateLeft(context, SignUpWebViewScreen());
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'New to Projector? ',
                            style: TextStyle(
                              fontSize:deviceType == DeviceType.mobile? 13.0 : 18.0,
                              color: Colors.white,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Text(
                            'Sign Up',
                            style: TextStyle(
                              fontSize:deviceType == DeviceType.mobile? 13.0 : 18.0,
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          )
                        ],
                      ),
                    ),
                    // SizedBox(height: 60),
                    // InkWell(
                    //   onTap: () {
                    //     Navigator.push(
                    //       context,
                    //       MaterialPageRoute(
                    //         builder: (context) => SubscriptionScreen(),
                    //       ),
                    //     );
                    //   },
                    //   child: Center(
                    //     child: Container(
                    //       height: 50,
                    //       decoration: BoxDecoration(
                    //         borderRadius: BorderRadius.circular(10),
                    //         border: Border.all(color: Colors.blue, width: 2),
                    //       ),
                    //       child: Center(
                    //         child: Text(
                    //           'Share and store Today for \$4.95/month',
                    //           style: TextStyle(
                    //             color: Colors.white,
                    //             fontSize: 15,
                    //             fontWeight: FontWeight.w500,
                    //           ),
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          ),
        ),
      )),
);
    });

  }
}
