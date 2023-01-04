import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projector/apis/authService.dart';
import 'package:projector/style.dart';
import 'package:sizer/sizer.dart';

class TVLoginScreen extends StatefulWidget {
  @override
  _TVLoginScreenState createState() => _TVLoginScreenState();
}

class _TVLoginScreenState extends State<TVLoginScreen> {
  bool loading = false;
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  String tvCode = '';
  FocusNode node = FocusNode();
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
      return SafeArea(
        bottom: false,
        top: false,
        child: Scaffold(
          key: scaffoldKey,
          backgroundColor: appBgColor,
          appBar: AppBar(
            centerTitle: false,
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
                  fontSize: 20.0,
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
                    SizedBox(height: height * 0.10),
                    Center(
                      child: Image(
                        height: deviceType == DeviceType.mobile
                            ? height * 0.09738
                            : 130,
                        width: width,
                        image: AssetImage('images/newLogoText.png'),
                      ),
                    ),
                    SizedBox(height: height * 0.085),
                    Center(
                      child: Text(
                        'Enter QR Code',
                        style: GoogleFonts.montserrat(
                          fontSize:
                              deviceType == DeviceType.mobile ? 16.0 : 28.0,
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
                          fontSize:
                              deviceType == DeviceType.mobile ? 18.0 : 25.0,
                        ),
                        onChanged: (val) {
                          tvCode = val;
                        },
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Color(0xff31343E),
                          hintText: 'QR Code',
                          hintStyle: GoogleFonts.montserrat(
                            color: Color(0xff8E8E8E),
                            fontSize:
                                deviceType == DeviceType.mobile ? 13.0 : 20.0,
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
                    SizedBox(height: 20),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 2),
                      child: InkWell(
                        onTap: () async {
                          if (formKey.currentState.validate()) {
                            setState(() {
                              loading = true;
                            });
                            var data =
                                await AuthService().tvLogin(code: tvCode);
                            if (data['success'] == true) {
                            } else {
                              setState(() {
                                loading = false;
                              });

                              // scaffoldKey.currentState.showSnackBar(
                              //   SnackBar(
                              //     content: Text('${data['message']}'),
                              //   ),
                              // );
                            }
                            setState(() {
                              loading = false;
                            });
                          }
                        },
                        child: Container(
                          height: deviceType == DeviceType.mobile
                              ? height * 0.06
                              : height * 0.08,
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
                                      'ADD DEVICE',
                                      style: GoogleFonts.montserrat(
                                        fontSize:
                                            deviceType == DeviceType.mobile
                                                ? 14.0
                                                : 20.0,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
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
