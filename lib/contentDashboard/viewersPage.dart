import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projector/contentDashboard/groups/groups_list_page.dart';
import 'package:projector/contentDashboard/successorListPage.dart';
import 'package:projector/contentDashboard/viewerListPage.dart';
import 'package:projector/widgets/widgets.dart';

class ViewersPage extends StatefulWidget {
  const ViewersPage({Key key}) : super(key: key);

  @override
  State<ViewersPage> createState() => _ViewersPageState();
}

class _ViewersPageState extends State<ViewersPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: false,
        elevation: 1,
        leading: IconButton(
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else {
              SystemNavigator.pop();
            }
          },
          icon: Icon(Icons.arrow_back_ios),
          color: Colors.black,
        ),
        titleSpacing: 0.0,
        title: Transform(
          transform: Matrix4.translationValues(0.0, 0.0, 0.0),
          child: Text(
            "Viewers",
            style: GoogleFonts.montserrat(
              color: Colors.black,
              fontSize: 20.0,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
      body: Container(
        child: ListView(
          children: [
            SizedBox(
              height: 50,
            ),
            SizedBox(
                height: 80,
                child: InkWell(
                  onTap: () {
                    navigate(context, ViewerListPage());
                  },
                  child: Container(
                    margin: EdgeInsets.only(left: 16.0, right: 16.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey[500],
                          blurRadius: 2.0,
                          spreadRadius: 1.0,
                          offset:
                              Offset(0.0, 0.0), // shadow direction: 360 degree
                        )
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 20.0),
                          child: Text(
                            "Viewers",
                            style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontSize: 18.0,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(right: 16.0),
                          padding: EdgeInsets.only(
                              left: 15.0, right: 15.0, top: 10.0, bottom: 10.0),
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0)),
                            border: Border.all(color: Colors.grey[200]),
                          ),
                          child: Text(
                            "Edit",
                            style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontSize: 12.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )),
            SizedBox(
              height: 20,
            ),
            SizedBox(
                height: 80,
                child: InkWell(
                  onTap: () {
                    navigate(context, GroupsListPage());
                  },
                  child: Container(
                    margin: EdgeInsets.only(left: 16.0, right: 16.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey[500],
                          blurRadius: 2.0,
                          spreadRadius: 1.0,
                          offset:
                              Offset(0.0, 0.0), // shadow direction: 360 degree
                        )
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 20.0),
                          child: Text(
                            "Groups",
                            style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontSize: 18.0,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(right: 16.0),
                          padding: EdgeInsets.only(
                              left: 15.0, right: 15.0, top: 10.0, bottom: 10.0),
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0)),
                            border: Border.all(color: Colors.grey[200]),
                          ),
                          child: Text(
                            "Edit",
                            style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontSize: 12.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )),
            SizedBox(
              height: 20,
            ),
            SizedBox(
                height: 80,
                child: InkWell(
                  onTap: () {
                    navigate(context, SuccessorListPage());
                  },
                  child: Container(
                    margin: EdgeInsets.only(left: 16.0, right: 16.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey[500],
                          blurRadius: 2.0,
                          spreadRadius: 1.0,
                          offset:
                              Offset(0.0, 0.0), // shadow direction: 360 degree
                        )
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 20.0),
                          child: Text(
                            "Successors",
                            style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontSize: 18.0,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(right: 16.0),
                          padding: EdgeInsets.only(
                              left: 15.0, right: 15.0, top: 10.0, bottom: 10.0),
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0)),
                            border: Border.all(color: Colors.grey[200]),
                          ),
                          child: Text(
                            "Edit",
                            style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontSize: 12.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
