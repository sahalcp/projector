import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projector/apis/authService.dart';
import 'package:projector/resetPasswordScreen.dart';
// import 'package:google_fonts/google_fonts.dart';
import 'package:projector/signUpScreen.dart';
import 'package:projector/style.dart';
import 'package:projector/widgets/widgets.dart';
import 'package:sizer/sizer.dart';
// import 'package:projector/widgets/widgets.dart';

class ForgotPasswordScreen extends StatefulWidget {
  ForgotPasswordScreen({
    this.passedEmail,
  });

  final String passedEmail;
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  String email = '';
  bool loading = false;

  final formKey = GlobalKey<FormState>();

  final textController = TextEditingController();
@override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
  textController.text = widget.passedEmail!=null?widget.passedEmail:"";
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Sizer(builder: (context, orientation, deviceType) {
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
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                } else {
                  SystemNavigator.pop();
                }
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
                  fontSize: deviceType == DeviceType.mobile? 20.0 : 25.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(width * 0.05),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Image(
                          height: deviceType == DeviceType.mobile? height * 0.09738 : 130,
                          width: width *0.7,
                          image: AssetImage('images/newLogoText.png'),
                        ),
                      ],
                    ),
                    SizedBox(height: height * 0.05),
                    Center(
                      child: Text(
                        'Confirm your email',
                        style: GoogleFonts.montserrat(
                          fontSize: deviceType == DeviceType.mobile? 18.0: 28.0,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: height * 0.02),
                    Container(
                      // height: height * 0.06,
                      child: TextFormField(
                        style: GoogleFonts.montserrat(
                          color: Colors.white,
                          fontSize: deviceType == DeviceType.mobile? 13.0 : 20.0,
                        ),
                        controller: textController,
                        // controller: TextEditingController(text: widget.passedEmail!=null?widget.passedEmail:""),

                        onChanged: (val) {
                          email = val;
                        },
                        validator: (val) {
                          if (val.length == 0)
                            return 'Enter the email';
                          else if (!EmailValidator.validate(textController.text.trim()))
                            return 'Not a valid email';
                        },
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Color(0xff31343E),
                          hintText: 'Enter your email',
                          hintStyle: TextStyle(
                            color: Color(0xff8E8E8E),
                            fontSize: deviceType == DeviceType.mobile? 13.0 : 20.0,
                            fontWeight: FontWeight.w400,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xff6D6F76),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(5.0),
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
                    SizedBox(height: 10),
                    Center(
                      child: Text(
                        'We will send an email where you can reset your password',
                        style: GoogleFonts.montserrat(
                          fontSize: deviceType == DeviceType.mobile? 14.0 : 20.0,
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    SizedBox(height: height * 0.02),
                    InkWell(
                      onTap: () async {
                        if (formKey.currentState.validate()) {
                          setState(() {
                            loading = true;
                          });
                          var data = await AuthService().forgotPassword(textController.text);
                          setState(() {
                            loading = false;
                          });
                          // print(data);
                          if (data['success'] == true) {
                            navigate(
                              context,
                              ResetPasswordScreen(
                                email: textController.text,
                              ),
                            );
                          } else {
                            Fluttertoast.showToast(
                                msg: 'Email is not registered');
                          }
                          // showDialog(
                          //   context: context,
                          //   builder: (context) {
                          //     return AlertDialog(
                          //       content: Text(
                          //         'An email has been sent to your registered email, please verify to reset your password.',
                          //         style: TextStyle(
                          //           color: Colors.black,
                          //           fontSize: 13.0,
                          //           fontWeight: FontWeight.w600,
                          //         ),
                          //       ),
                          //     );
                          //   },
                          // );
                        }
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
                            'RESET PASSWORD',
                            style: GoogleFonts.montserrat(
                              fontSize: deviceType == DeviceType.mobile? 13.0 : 25.0,
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
                        navigate(context, SignUpScreen());
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'New to Projector? ',
                            style: GoogleFonts.montserrat(
                              fontSize: deviceType == DeviceType.mobile? 13.0 : 18.0,
                              color: Colors.white,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Text(
                            'Sign Up',
                            style: GoogleFonts.montserrat(
                              fontSize: deviceType == DeviceType.mobile? 13.0 : 18.0,
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          )
                        ],
                      ),
                    )
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
