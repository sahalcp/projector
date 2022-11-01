import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

commingSoonDialog(context) {
  var height = MediaQuery.of(context).size.height;
  var width = MediaQuery.of(context).size.width;
  showDialog(
      context: context,
      barrierColor: Color(0xff333333).withOpacity(0.7),
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          insetPadding: EdgeInsets.only(
            left: 20,
            right: 20,
            bottom: height * 0.3,
            top: 30,
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          content: Builder(
            builder: (context) {
              return Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: CircleAvatar(
                          radius: 10,
                          backgroundColor: Color(0xff333333),
                          child: Icon(
                            Icons.close,
                            size: 11,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 15),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: 5),
                          Text(
                            'Coming Soon!',
                            style: GoogleFonts.montserrat(
                              fontSize: 33,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.03),
                          Text(
                            'For now go to',
                            style: GoogleFonts.montserrat(
                              fontSize: 22,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10),
                          InkWell(
                            onTap: () {
                              launch(
                                  'https://projector.app');
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'projector.app',
                                  style: GoogleFonts.montserrat(
                                    fontSize: 22,
                                    color: Color(0xff0270D7),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  ' to',
                                  style: GoogleFonts.montserrat(
                                    fontSize: 22,
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'upload your content to',
                            style: GoogleFonts.montserrat(
                              fontSize: 22,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'share with anyone',
                            style: GoogleFonts.montserrat(
                              fontSize: 22,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.04),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      });
}
