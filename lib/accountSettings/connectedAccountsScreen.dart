import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projector/accountSettings/addViewerScreen.dart';
import 'package:projector/apis/viewService.dart';
import 'package:projector/widgets/widgets.dart';

class ConnectedAccountScreen extends StatefulWidget {
  @override
  _ConnectedAccountScreenState createState() => _ConnectedAccountScreenState();
}

class _ConnectedAccountScreenState extends State<ConnectedAccountScreen> {
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
              //     'Connected Accounts',
              //     style: GoogleFonts.poppins(
              //       fontSize: 13.0,
              //       fontWeight: FontWeight.w700,
              //       color: Color(0xff32CE71),
              //     ),
              //   ),
              // ),
              // SizedBox(height: 10),
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
                  'Connected Accounts',
                  style: GoogleFonts.poppins(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
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
                          'Edit all associated account settings',
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
                        padding: EdgeInsets.only(left: 24.0, right: 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Add Viewer/accept User',
                                  style: GoogleFonts.poppins(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w700,
                                    // color: Colors.w,
                                  ),
                                ),
                                SizedBox(width: 10),
                                InkWell(
                                  onTap: () {
                                    navigate(context, AddViewerScreen());
                                  },
                                  child: CircleAvatar(
                                    radius: 12.0,
                                    backgroundColor: Colors.black,
                                    child: Icon(
                                      Icons.add,
                                      size: 16.0,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 30),
                            FutureBuilder(
                              future: ViewService().getAllViewRequests(1),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  var requests = [];
                                  snapshot.data.forEach((d) {
                                    if (d['status'] == '1') {
                                      requests.add(d);
                                    }
                                  });
                                  return requests.length == 0
                                      ? Container(
                                          height: height * 0.05,
                                          child: Center(
                                            child: Text(
                                              'No Viewers',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        )
                                      : Container(
                                          padding: EdgeInsets.all(14),
                                          decoration: BoxDecoration(
                                            border:
                                                Border.all(color: Colors.grey),
                                          ),
                                          child: ListView.builder(
                                            itemCount: requests.length,
                                            shrinkWrap: true,
                                            itemBuilder: (context, index) {
                                              var email =
                                                  requests[index]['email'];
                                              var image =
                                                  requests[index]['image'];
                                              return Container(
                                                margin: EdgeInsets.symmetric(vertical: 5),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    CircleAvatar(
                                                      radius: 20,
                                                      backgroundImage: image !=
                                                              null
                                                          ? NetworkImage(image)
                                                          : AssetImage(''),
                                                    ),
                                                    SizedBox(width: 10),
                                                    Text(
                                                      email,
                                                      style:
                                                          GoogleFonts.montserrat(
                                                        fontSize: 12.0,
                                                        color: Color(0xffB2B2B2),
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          ),
                                        );
                                } else {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                              },
                            ),
                            // Text(
                            //   'First and Last name\nEmail or phone number\nSend invite\nAccept request to join',
                            //   style: GoogleFonts.montserrat(
                            //     fontSize: 13.0,
                            //     fontWeight: FontWeight.w400,
                            //     color: Color(0xff1A1D2A),
                            //   ),
                            // ),
                            SizedBox(height: 35),
                            Row(
                              children: [
                                Text(
                                  'Add Successor',
                                  style: GoogleFonts.poppins(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w700,
                                    // color: Color(0xff696969),
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
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
