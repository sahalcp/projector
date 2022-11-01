import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projector/apis/authService.dart';
import 'package:projector/enterPasswordScreen.dart';
import 'package:projector/style.dart';
import 'package:projector/widgets/widgets.dart';
import 'package:sizer/sizer.dart';

class ResetPasswordScreen extends StatefulWidget {
  ResetPasswordScreen({@required this.email});
  final String email;
  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  String code = '', password = '';
  bool loading = false;
  bool sendAgainLoading = false;
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    //print("forgot -->"+widget.email);
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Sizer(builder: (context, orientation, deviceType) {
      return Scaffold(
        backgroundColor: appBgColor,
        appBar: AppBar(
          centerTitle: false,
          //backgroundColor: Color(0xff1A1D2A),
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
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(width * 0.05),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Image(
                          height:deviceType == DeviceType.mobile? height * 0.09738 : 130,
                          width: width *0.7,
                          image: AssetImage('images/newLogoText.png'),
                        ),
                      ],
                    ),
                    SizedBox(height: height * 0.05),
                    Center(
                      child: Text(
                        'Enter Your Reset Code',
                        style: GoogleFonts.montserrat(
                          fontSize: deviceType == DeviceType.mobile? 18.0: 28.0,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: height * 0.02),
                    TextFormField(
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: deviceType == DeviceType.mobile? 13.0 : 20.0,
                      ),
                      onChanged: (val) {
                        code = val;
                      },
                      maxLength: 5,
                      validator: (val) {
                        if (code.length != 5) return 'Enter a valid code';
                      },
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Color(0xff31343E),
                        hintText: 'Enter your Reset Code',
                        hintStyle: GoogleFonts.montserrat(
                          color: Color(0xff8E8E8E),
                          fontSize: deviceType == DeviceType.mobile? 13.0 : 20.0,
                          fontWeight: FontWeight.w400,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xff6D6F76),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                    ),
                    SizedBox(height: height * 0.03),
                    Center(
                      child: Text(
                        'Enter New Password',
                        style: GoogleFonts.montserrat(
                          fontSize: deviceType == DeviceType.mobile? 18.0: 28.0,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: height * 0.02),
                    TextFormField(
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: deviceType == DeviceType.mobile? 13.0 : 20.0,
                      ),
                      onChanged: (val) {
                        password = val;
                      },
                      validator: (val) {
                        if (password.length < 6)
                          return 'Please enter a strong password';
                      },
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Color(0xff31343E),
                        hintText: 'Enter New Password',
                        hintStyle: GoogleFonts.montserrat(
                          color: Color(0xff8E8E8E),
                          fontSize: deviceType == DeviceType.mobile? 13.0 : 20.0,
                          fontWeight: FontWeight.w400,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xff6D6F76),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(5.0),
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
                          var data = await AuthService()
                              .updatePassword(widget.email, code, password);
                          if (data['success'] == true) {
                            /*showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                content: Text(
                                  'The password is updated',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 13.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              );
                            },
                          );*/
                            Fluttertoast.showToast(msg: 'The password is updated', backgroundColor: Colors.white,textColor: Colors.black);
                            navigateRemoveLeft(context, EnterPasswordScreen(email: widget.email));
                          } else {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  content: Text(
                                    data['message'],
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 13.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                );
                              },
                            );
                          }
                          setState(() {
                            loading = false;
                          });
                        }
                      },
                      child: Container(
                        margin: EdgeInsets.all(2.0),
                        height: deviceType == DeviceType.mobile? height * 0.06 : height * 0.07,
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
                            style: TextStyle(
                              fontSize: deviceType == DeviceType.mobile? 16.0 : 23.0,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: height * 0.02),
                    InkWell(
                      onTap: () async {

                        setState(() {
                          sendAgainLoading = true;
                        });
                        var data = await AuthService()
                            .forgotPassword(widget.email);
                        if (data['success'] == true) {
                          setState(() {
                            sendAgainLoading = false;
                          });
                          Fluttertoast.showToast(
                            msg: data['message'],
                            textColor: Colors.black,
                            backgroundColor: Colors.white,
                          );
                        } else {
                          setState(() {
                            sendAgainLoading = false;
                          });
                        }
                        setState(() {
                          sendAgainLoading = false;
                        });

                      },
                      child: Container(
                        margin: EdgeInsets.all(2.0),
                        height: deviceType == DeviceType.mobile? height * 0.06 : height * 0.07,
                        width: width,
                        decoration: BoxDecoration(
                          color: Color(0xff5AA5EF),
                          borderRadius: BorderRadius.circular(6.0),
                        ),
                        child: Center(
                          child: sendAgainLoading
                              ? CircularProgressIndicator(
                            backgroundColor: Colors.white,
                          )
                              : Text(
                            'SEND AGAIN ?',
                            style: TextStyle(
                              fontSize: deviceType == DeviceType.mobile? 16.0 : 23.0,
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
        ),
      );
    });
  }
}
