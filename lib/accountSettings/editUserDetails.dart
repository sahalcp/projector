import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:projector/apis/accountService.dart';
import 'package:projector/forgotPasswordPage.dart';
import 'package:projector/widgets/dialogs.dart';
import 'package:projector/widgets/widgets.dart';

class EditUserDetailsPage extends StatefulWidget {
  EditUserDetailsPage({@required this.text});
  final String text;

  @override
  _EditUserDetailsPageState createState() => _EditUserDetailsPageState();
}

class _EditUserDetailsPageState extends State<EditUserDetailsPage> {
  String current, newValue;
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        key: scaffoldKey,
        body: ModalProgressHUD(
          inAsyncCall: loading,
          child: Container(
            color: Colors.white,
            width: width,
            padding: EdgeInsets.only(
              left: 14.0,
              right: 14.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: height * 0.03),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Cancel',
                        style: GoogleFonts.poppins(
                          fontSize: 13.0,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    Text(
                      'Change ${widget.text}',
                      style: GoogleFonts.poppins(
                        fontSize: 15.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        print(widget.text);
                        if (current != null && newValue != null) {
                          if (current != newValue) {
                            if (widget.text == 'Password') {
                              setState(() {
                                loading = true;
                              });
                              var data = await AccountService()
                                  .updatePassword(current, newValue);
                              if (data['success'] == true)
                                Navigator.pop(context);
                              else {
                                scaffoldKey.currentState.showSnackBar(
                                  SnackBar(
                                    content:
                                        Text('Old password is not correct'),
                                  ),
                                );
                              }
                              setState(() {
                                loading = false;
                              });
                            } else if (widget.text == 'Email') {
                              setState(() {
                                loading = true;
                              });
                              var data =
                                  await AccountService().updateEmailRequest();
                              if (data['success'] == true) {
                                showConfirmDialog(
                                  context,
                                  text: data['message'],
                                );
                              } else {
                                scaffoldKey.currentState.showSnackBar(
                                  SnackBar(
                                    content: Text('Old Email is not correct'),
                                  ),
                                );
                              }
                              setState(() {
                                loading = false;
                              });
                            } else if (widget.text == 'Phone Number') {
                              setState(() {
                                loading = true;
                              });
                              var data = await AccountService()
                                  .updateProfile(mobile:newValue);
                              if (data['success'] == true) {
                                showConfirmDialog(
                                  context,
                                  text: 'Phone Number Updated',
                                );
                              } else {
                                scaffoldKey.currentState.showSnackBar(
                                  SnackBar(
                                    content:
                                        Text('Old Phone Number is not correct'),
                                  ),
                                );
                              }
                              setState(() {
                                loading = false;
                              });
                            }
                          } else {
                            scaffoldKey.currentState.showSnackBar(
                              SnackBar(
                                content: Text('Both values cannot be same'),
                              ),
                            );
                          }
                        } else {
                          scaffoldKey.currentState.showSnackBar(
                            SnackBar(
                              content: Text('All fileds are required'),
                            ),
                          );
                        }
                        // Navigator.pop(context);
                      },
                      child: Text(
                        'Save',
                        style: GoogleFonts.poppins(
                          fontSize: 13.0,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Text(
                  'This will replace the ${widget.text} you use to log in to Projector.',
                  style: GoogleFonts.poppins(
                    fontSize: 11.0,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'CURRENT ${widget.text.toUpperCase()}',
                  style: GoogleFonts.poppins(
                    fontSize: 11.0,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 5),
                TextFormField(
                  onChanged: (val) {
                    current = val;
                  },
                  keyboardType: widget.text == 'Phone Number'
                      ? TextInputType.number
                      : TextInputType.text,
                  decoration: InputDecoration(
                    suffixIcon: Icon(
                      Icons.remove_red_eye,
                      color: Colors.black,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  '( Case Sensitive )',
                  style: TextStyle(
                    fontSize: 10.0,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'NEW ${widget.text.toUpperCase()}',
                  style: GoogleFonts.poppins(
                    fontSize: 11.0,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 5),
                TextFormField(
                  onChanged: (val) {
                    newValue = val;
                  },
                  keyboardType: widget.text == 'Phone Number'
                      ? TextInputType.number
                      : TextInputType.text,
                  decoration: InputDecoration(
                    suffixIcon: Icon(
                      Icons.remove_red_eye,
                      color: Colors.black,
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                ),
                SizedBox(height: 30),
                InkWell(
                  onTap: () {
                    if (widget.text == 'Password') {
                      navigate(context, ForgotPasswordScreen());
                    }
                  },
                  child: Text(
                    'Forgot ${widget.text}?',
                    style: TextStyle(
                      fontSize: 10.0,
                      color: Color(0xff5AA5EF),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
