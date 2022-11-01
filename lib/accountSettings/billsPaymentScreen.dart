import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projector/constant.dart';
import 'package:projector/widgets/widgets.dart';
import 'package:url_launcher/url_launcher.dart';

class BillPaymentScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        body: Container(
          // color: Color(0xff1A1D2A),
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // newAppBar(height),
              // SizedBox(height: 25),
              // Padding(
              //   padding: EdgeInsets.only(left: 15.0),
              //   child: Text(
              //     'Billings and Payment',
              //     style: GoogleFonts.poppins(
              //       fontSize: 13.0,
              //       fontWeight: FontWeight.w700,
              //       color: Color(0xff32CE71),
              //     ),
              //   ),
              // ),
              SizedBox(height: height * 0.03),
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
                  'Billings and Payment',
                  style: GoogleFonts.poppins(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              // SizedBox(height: 10),
              Expanded(
                child: Container(
                  width: width,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 35),
                      Padding(
                        padding: EdgeInsets.only(left: 30.0),
                        child: Text(
                          'Settings',
                          style: GoogleFonts.poppins(
                            fontSize: 13.0,
                            fontWeight: FontWeight.w600,
                            color: Color(0xff585858),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 30.0),
                        child: Text(
                          'Edit payment methods, add and remove cards',
                          style: GoogleFonts.montserrat(
                            fontSize: 8.0,
                            fontWeight: FontWeight.w400,
                            color: Color(0xffB9B8B8),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Divider(
                          height: 40.0,
                          color: Color(0xffB9B8B8),
                        ),
                      ),
                      SizedBox(height: 20),
                      Container(
                        padding: EdgeInsets.only(
                          left: 30.0,
                          right: 30.0,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Add New Card',
                                  style: GoogleFonts.poppins(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xff696969),
                                  ),
                                ),
                                SizedBox(width: 10),
                                CircleAvatar(
                                  radius: 12.0,
                                  backgroundColor: Colors.black,
                                  child: Icon(
                                    Icons.add,
                                    size: 16.0,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 30),
                            InkWell(
                              onTap: () {
                                launch(planUrl);
                              },
                              child: Container(
                                height: height * 0.18,
                                width: width,
                                padding: EdgeInsets.only(
                                  left: 30.0,
                                  right: 20.0,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  border: Border.all(
                                    color: Color(0xff707070).withOpacity(0.3),
                                    width: 2.0,
                                  ),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '5 3 4 4 * * * * * * * * * * * *',
                                      style: GoogleFonts.montserrat(
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xff1A1D2A),
                                      ),
                                    ),
                                    SizedBox(height: height * 0.04),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Image(
                                          height: 40,
                                          width: 40,
                                          image: AssetImage(
                                              'images/masterCard.png'),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
