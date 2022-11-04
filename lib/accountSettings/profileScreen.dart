import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:projector/accountSettings/editUserDetails.dart';
import 'package:projector/apis/accountService.dart';
import 'package:projector/data/userData.dart';
import 'package:projector/login/GuideScreen.dart';
import 'package:projector/widgets/widgets.dart';
// import 'package:projector/widgets/widgets.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String userImage;
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return SafeArea(
      top: false,
      bottom: false,
      child: Scaffold(
        body: Container(
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: height * 0.07),
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
                      'Account Settings',
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
              SizedBox(height: 50),
              Padding(
                padding: EdgeInsets.only(left: 15.0),
                child: Text(
                  'Profile',
                  style: GoogleFonts.poppins(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              FutureBuilder(
                future: AccountService().getProfile(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    print(snapshot.data);
                    var email = snapshot.data['email'];
                    //var countryCode = snapshot.data['country_code'];
                   // var mobile = snapshot.data['mobile'];
                    var countryCode = "";
                    var mobile = "";
                    userImage=snapshot.data['image'];
                    return Column(
                      children: [
                        Center(
                          child: userImage != null
                              ? CircleAvatar(
                                  radius: width * 0.11,
                                  backgroundImage: userImage.contains('http')
                                      ? NetworkImage(userImage)
                                      : FileImage(File(userImage)),
                                )
                              : Container(
                                  height: height * 0.14,
                                  width: width * 0.22,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(color: Colors.black),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Icon(
                                      Icons.person_add,
                                      size: 32.0,
                                    ),
                                  ),
                                ),
                        ),
                        Center(
                          child: InkWell(
                            onTap: () async {
                              final image = await ImagePicker()
                                  .getImage(source: ImageSource.gallery);
                              List<int> imageBytes;
                              String base64Image;
                              if (image != null) {
                                setState(() {
                                  userImage = image.path;
                                });
                                imageBytes = File(image.path).readAsBytesSync();
                                base64Image =
                                    // Base64Encoder().convert(imageBytes);
                                    base64Encode(imageBytes);
                                var res = await AccountService().updateProfileImage(
                                  image: base64Image,
                                );

                                if (res["success"] == true){

                                  setState(() {
                                  });
_showToast(context);
                                 /* Fluttertoast.showToast(
                                    msg: 'Profile Updated',
                                    textColor: Colors.white,
                                    backgroundColor: Colors.black,
                                  );*/
                                }
                                else{
                                  Fluttertoast.showToast(
                                    msg: 'Try Again',
                                    backgroundColor: Colors.black,
                                  );
                                }
                              }
                            },
                            child: Text(
                              'Edit Profile Picture',
                              style: GoogleFonts.montserrat(
                                fontSize: 20.0,
                                fontWeight: FontWeight.w700,
                                color: Color(0xff5AA5EF),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 50),
                        Container(
                          padding: EdgeInsets.only(
                            left: 20,
                            right: 15.0,
                          ),
                          child: Column(
                            children: [
                              userDataRow(
                                  context, 'Email settings', '$email', 'Email'),
                              SizedBox(height: 30),
                              userDataRow(context, 'Phone number settings',
                                  '$countryCode $mobile', 'Phone Number'),
                              SizedBox(height: 30),
                              userDataRow(context, 'Password',
                                  '***************', 'Password'),
                              SizedBox(height: 80),

                              InkWell(
                                onTap: (){
                                  deActivateDialog(context, height, width);
                                },
                                child:  Text(
                                  'Deactivate Account',
                                  style: GoogleFonts.montserrat(
                                    color: Colors.red,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  } else {
                    return Container();
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

userDataRow(context, title, data, heading) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$title',
            style: GoogleFonts.poppins(
              fontSize: 18.0,
              // color: Color(0xff696969),
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            '$data',
            style: GoogleFonts.montserrat(
              fontSize: 12.0,
              fontWeight: FontWeight.w700,
            ),
          )
        ],
      ),
      InkWell(
        onTap: () {
          navigate(
            context,
            EditUserDetailsPage(
              text: heading,
            ),
          );
        },
        child: Text(
          'Change',
          style: GoogleFonts.montserrat(
            fontSize: 10.0,
            fontWeight: FontWeight.w400,
            color: Color(0xff1A1D2A).withOpacity(0.4),
          ),
        ),
      )
    ],
  );
}

void _showToast(BuildContext context) {

  final scaffold = ScaffoldMessenger.of(context);
  scaffold.showSnackBar(
    SnackBar(
      content: const Text('Profile Updated'),
     // action: SnackBarAction(label: 'UNDO', onPressed: scaffold.hideCurrentSnackBar),
    ),
  );
}

deActivateDialog(context, height, width) {

  return showDialog(
    context: context,
    barrierColor: Color(0xff333333).withOpacity(0.7),
    builder: (context) {
      return StatefulBuilder(builder: (context, setState) {


        return Container(
          height: height * 0.3,
          color: Color(0xff333333).withOpacity(0.3),
          child: Dialog(
            backgroundColor: Colors.white.withOpacity(0),
            insetPadding: EdgeInsets.only(
              left: 26.0,
              right: 25.0,
              top: 60.0,
              bottom: 80.0,
            ),
            child: Container(
                height: height * 0.4,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.0),
                  border: Border.all(
                    color: Color(0xff707070),
                  ),
                ),
                child: Column(
                  children: [
                    SizedBox(height: 20,),
                    Center(
                      child: Container(
                        margin: EdgeInsets.only(left: 10,right: 10),
                        child: Text(
                          'Are you sure?',
                          style: GoogleFonts.montserrat(
                            fontSize: 25.0,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    SizedBox(height: 50,),
                    Center(
                      child: Container(
                        margin: EdgeInsets.only(left: 20,right: 20),
                        child: Text(
                          'You are about to deactivate your account. Are you sure you want to continue?',
                          style: GoogleFonts.montserrat(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    SizedBox(height: 50,),
                    Container(
                      margin: EdgeInsets.only(left: 10,right: 10),
                      alignment: Alignment.center,
                      height: height * 0.055,
                      width: width * 0.35,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(7),
                      ),
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(7),
                        ),
                        color: Color(0xff5AA5EF),
                        onPressed: () async {

                          Navigator.pop(context);
                        },
                        child: Center(
                          child: Text(
                            'Cancel',
                            style: GoogleFonts.poppins(
                              fontSize: 15.0,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 30,),
                    InkWell(
                      onTap: () async{
                        var response = await AccountService().deleteUser();
                        if(response['success']){
                          Navigator.pop(context);
                          Fluttertoast.showToast(
                            backgroundColor: Colors.white,
                            msg: response['message'],
                            textColor: Colors.black,
                          );

                          UserData().deleteUserLogged();
                          navigateReplace(context, GuideScreens());
                        }
                      },
                      child: Center(
                        child: Container(
                          margin: EdgeInsets.only(left: 10,right: 10),
                          child: Text(
                            'Deactivate',
                            style: GoogleFonts.montserrat(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w700,
                              color: Colors.red,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10,),
                  ],
                )
            ),
          ),
        );
      });
    },
  );
}


//  newAppBar(height),
//               SizedBox(height: 25),
//               Padding(
//                 padding: EdgeInsets.only(left: 15.0),
//                 child: Text(
//                   'Account',
//                   style: GoogleFonts.poppins(
//                     fontSize: 13.0,
//                     fontWeight: FontWeight.w700,
//                     color: Color(0xff32CE71),
//                   ),
//                 ),
//               ),
//               SizedBox(height: 10),
//               Expanded(
//                 child: Container(
//                   width: width,
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(5.0),
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       SizedBox(height: 35),
//                       Padding(
//                         padding: EdgeInsets.only(left: 30.0),
//                         child: Text(
//                           'Settings',
//                           style: GoogleFonts.poppins(
//                             fontSize: 13.0,
//                             fontWeight: FontWeight.w600,
//                             color: Color(0xff585858),
//                           ),
//                         ),
//                       ),
//                       Padding(
//                         padding: EdgeInsets.only(left: 30.0),
//                         child: Text(
//                           'Choose how your friends see you on Projector',
//                           style: GoogleFonts.montserrat(
//                             fontSize: 8.0,
//                             fontWeight: FontWeight.w400,
//                             color: Color(0xffB9B8B8),
//                           ),
//                         ),
//                       ),
//                       Padding(
//                         padding: EdgeInsets.all(8.0),
//                         child: Divider(
//                           height: 40.0,
//                           color: Color(0xffB9B8B8),
//                         ),
//                       ),
//                       Padding(
//                         padding: EdgeInsets.only(
//                           left: 30.0,
//                           top: 10.0,
//                         ),
//                         child: Row(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               'Profile',
//                               style: GoogleFonts.poppins(
//                                 fontSize: 18.0,
//                                 fontWeight: FontWeight.w700,
//                                 color: Color(0xff696969),
//                               ),
//                             ),
//                             SizedBox(width: 30),
//                             Container(
//                               height: height * 0.12,
//                               child: Stack(
//                                 children: [
//                                   Image(
//                                     height: 80,
//                                     image: AssetImage('images/user.png'),
//                                   ),
//                                   Positioned(
//                                     top: 65.0,
//                                     left: 30.0,
//                                     child: CircleAvatar(
//                                       radius: 12.0,
//                                       backgroundColor: Color(0xff30CE75),
//                                       child: Icon(
//                                         Icons.add,
//                                         color: Colors.white,
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             SizedBox(width: 15),
//                             Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   'John Doe',
//                                   style: GoogleFonts.montserrat(
//                                     fontSize: 12.0,
//                                     fontWeight: FontWeight.w700,
//                                     color: Color(0xff1A1D2A),
//                                   ),
//                                 ),
//                                 Text(
//                                   'Edit Avatar',
//                                   style: GoogleFonts.montserrat(
//                                     fontSize: 12.0,
//                                     fontWeight: FontWeight.w700,
//                                     color: Color(0xff30CE75),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//                       SizedBox(height: 60),
//                       Container(
//                         padding: EdgeInsets.only(
//                           left: 30.0,
//                           right: 20.0,
//                         ),
//                         child: Column(
//                           children: [
//                             userDataRow('Email settings', 'Johndoe@gmail.com'),
//                             SizedBox(height: 30),
//                             userDataRow(
//                                 'Phone number settings', '+01 333 4444 000'),
//                             SizedBox(height: 30),
//                             userDataRow('Password', '***************'),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
