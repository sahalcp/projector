import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:projector/accountSettings/billsPaymentScreen.dart';
import 'package:projector/accountSettings/connectedAccountsScreen.dart';
import 'package:projector/accountSettings/notificationsScreen.dart';
import 'package:projector/accountSettings/profileScreen.dart';
import 'package:projector/sideDrawer/contentLayoutScreen.dart';
import 'package:projector/sideDrawer/dashboard.dart';
import 'package:projector/sideDrawer/listVideo.dart';
import 'package:projector/sideDrawer/viewProfiePage.dart';
import 'package:sizer/sizer.dart';
import '../signInScreen.dart';
import 'package:google_fonts/google_fonts.dart';

newAppBar(height) {
  return Column(
    children: [
      SizedBox(height: height * 0.01),
      Padding(
        padding: EdgeInsets.only(
          left: 15.0,
          right: 15.0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Image(
                  image: AssetImage('images/logo.png'),
                  height: 30,
                  width: 30,
                ),
                Text(
                  '|PROJECtor',
                  style: GoogleFonts.poppins(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                )
              ],
            ),
            Row(
              children: [
                Image(
                  image: AssetImage('images/add.png'),
                  height: 30,
                  width: 30,
                ),
                SizedBox(width: 5),
                Image(
                  image: AssetImage('images/user.png'),
                  height: 30,
                  width: 30,
                ),
                Image(
                  image: AssetImage('images/layer.png'),
                  height: 30,
                  width: 30,
                ),
              ],
            )
          ],
        ),
      ),
    ],
  );
}

viewData(title, data, addOn, context) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        '$title',
        style: GoogleFonts.poppins(
          fontSize: 16.0,
          fontWeight: FontWeight.w600,
        ),
      ),
      SizedBox(height: 5),
      Container(
        // height: 300,
        padding: EdgeInsets.only(left: 11.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListView.separated(
              separatorBuilder: (context, index) => SizedBox(height: 11.0),
              itemCount: data.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    data[index],
                    style: GoogleFonts.poppins(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 5.0),
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Text(
                '$addOn',
                style: GoogleFonts.poppins(
                  fontSize: 13.0,
                  fontWeight: FontWeight.w600,
                  color: Color(0xff5AA5EF),
                ),
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

navigate(context, page) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => page),
  );
}

navigateLeft(context, page) {
  Navigator.of(context).push(
    CupertinoPageRoute<Null>(
      builder: (BuildContext context) {
        return page;
      },
    ),
  );
}

navigateReplaceLeft(context, page) {
  Navigator.of(context).pushReplacement(
    CupertinoPageRoute<Null>(
      builder: (BuildContext context) {
        return page;
      },
    ),
  );
}

navigateRemoveLeft(context, page) {
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (context) => page),
    (route) => false,
  );
}

navigateReplace(context, page) {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => page),
  );
}

navigateRemove(context, page) {
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (context) => page),
    (route) => false,
  );
}

// drawer(context, title) {
//   bool isExpand = false;
//   return;
// }

class DrawerList extends StatefulWidget {
  final String title;
  DrawerList({this.title});
  @override
  _DrawerListState createState() => _DrawerListState();
}

class _DrawerListState extends State<DrawerList> {
  bool isExpand = false;
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Container(
      color: Colors.white,
      child: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            // Container(
            //   // height: 120,
            //   child: DrawerHeader(
            //     child: Text(
            //       'Projector',
            //       textAlign: TextAlign.center,
            //       style: TextStyle(fontSize: 20),
            //     ),
            //     decoration: BoxDecoration(
            //       color: Colors.white,
            //     ),
            //   ),
            // ),
            Padding(
              padding: const EdgeInsets.only(
                top: 30.0,
                bottom: 30.0,
                left: 20.0,
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Image(
                  height: height * 0.04,
                  image: AssetImage('images/01.png'),
                ),
              ),
            ),
            // InkWell(
            //   onTap: () {
            //     Navigator.pop(context);
            //     navigate(context, DashBoard());
            //   },
            //   child: Container(
            //     padding: EdgeInsets.all(16),
            //     child: Row(
            //       children: [
            //         Icon(
            //           Icons.home,
            //           color: widget.title == 'Dashboard'
            //               ? Color(0xff5AA5EF)
            //               : Colors.black,
            //           size: 24,
            //         ),
            //         SizedBox(width: 10),
            //         Text(
            //           'Dashboard',
            //           style: TextStyle(
            //             color: widget.title == 'Dashboard'
            //                 ? Color(0xff5AA5EF)
            //                 : Colors.black,
            //             fontSize: 15,
            //             fontWeight: FontWeight.w500,
            //           ),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),

            // InkWell(
            //   onTap: () {
            //     Navigator.pop(context);
            //     navigate(context, ListVideo());
            //   },
            //   child: Container(
            //     padding: EdgeInsets.all(16),
            //     child: Row(
            //       children: [
            //         Icon(
            //           Icons.movie,
            //           color: widget.title == 'All Videos'
            //               ? Color(0xff5AA5EF)
            //               : Colors.black,
            //           size: 24,
            //         ),
            //         SizedBox(width: 10),
            //         Text(
            //           'Video List',
            //           style: TextStyle(
            //             color: widget.title == 'All Videos'
            //                 ? Color(0xff5AA5EF)
            //                 : Colors.black,
            //             fontSize: 15,
            //             fontWeight: FontWeight.w500,
            //           ),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
            // InkWell(
            //   onTap: () {
            //     Navigator.pop(context);
            //     navigate(context, ContentLayoutScreen());
            //   },
            //   child: Container(
            //     padding: EdgeInsets.all(16),
            //     child: Row(
            //       children: [
            //         Icon(
            //           Icons.view_compact,
            //           color: widget.title == 'Content Layout'
            //               ? Color(0xff5AA5EF)
            //               : Colors.black,
            //           size: 24,
            //         ),
            //         SizedBox(width: 10),
            //         Text(
            //           'Content Layout',
            //           style: TextStyle(
            //             color: widget.title == 'Content Layout'
            //                 ? Color(0xff5AA5EF)
            //                 : Colors.black,
            //             fontSize: 15,
            //             fontWeight: FontWeight.w500,
            //           ),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),

            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white),
              ),
              child: Theme(
                data: ThemeData(
                  dividerColor: Colors.white.withOpacity(0),
                ),
                child: ExpansionTile(
                  onExpansionChanged: (val) {
                    // print(val);
                    setState(() {
                      isExpand = !isExpand;
                    });
                  },
                  // leading: Icon(
                  //   Icons.settings,
                  //   color: Colors.black,
                  //   size: 24,
                  // ),
                  title: Row(
                    children: [
                      Icon(
                        Icons.settings,
                        color: Colors.black,
                        size: 24,
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Account Settings',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                        ),
                      ),
                      isExpand
                          ? Icon(Icons.arrow_drop_up)
                          : Icon(Icons.arrow_drop_down),
                    ],
                  ),
                  trailing: SizedBox(
                    height: 0,
                    width: 0,
                  ),
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 10),
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                            navigate(context, ProfileScreen());
                          },
                          child: Padding(
                            padding: EdgeInsets.only(left: 50),
                            child: Text(
                              "Account",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                            navigate(context, NotificationScreen());
                          },
                          child: Padding(
                            padding: EdgeInsets.only(left: 50),
                            child: Text(
                              "Notifications",
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Padding(
                          padding: EdgeInsets.only(left: 50),
                          child: Text(
                            "Privacy",
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                            navigate(context, ConnectedAccountScreen());
                          },
                          child: Padding(
                            padding: EdgeInsets.only(left: 50),
                            child: Text(
                              "Connected Accounts",
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                            navigate(context, BillPaymentScreen());
                          },
                          child: Padding(
                            padding: EdgeInsets.only(left: 50),
                            child: Text(
                              "Billing And Payments",
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

List list = ['All Videos', 'Draft', 'Public', 'Private', 'Unlisted'];
appBar(key, title, width, context) {
  var height = MediaQuery.of(context).size.height;
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: <Widget>[
      InkWell(
        onTap: () {
          key.currentState.openDrawer();
        },
        child: Icon(
          Icons.menu,
          color: title == '' ? Colors.white : Colors.black,
        ),
      ),
      SizedBox(
        width: width * 0.02,
      ),
      InkWell(
        onTap: () {
          if (title == 'All Videos') {
            showModalBottomSheet(
              context: context,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(32.0),
                  topRight: Radius.circular(32.0),
                ),
              ),
              builder: (context) {
                return Container(
                  height: height * 0.08 * list.length,
                  padding: EdgeInsets.only(
                    top: 11.0,
                    // left: 39.0,
                  ),
                  child: Column(
                    children: [
                      Center(
                        child: Container(
                          height: 3,
                          width: 60,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 5),
                      Container(
                        padding: EdgeInsets.only(left: 39.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            viewData('', list, 'Cancel', context),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
        child: Row(
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 20,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              width: width * 0.06,
            ),
            title == 'All Videos' || title == 'Dashboard'
                ? title == 'Dashboard'
                    ? SizedBox(width: width * 0)
                    : Icon(
                        Icons.arrow_drop_down,
                        color: Colors.black,
                      )
                : SizedBox(
                    width: width * 0.3,
                  ),
          ],
        ),
      ),
      SizedBox(width: width * 0.32),
      InkWell(
        onTap: () {
          // if (title == 'All Videos' || title == 'Dashboard') {
          navigate(context, ViewProfilePage());
          // } else {
          //   showMenu(
          //     context: context,
          //     position: RelativeRect.fromLTRB(width, height * 0.12, 0, 0),
          //     items: [
          //       PopupMenuItem(
          //         child: InkWell(
          //           onTap: () {
          //             Navigator.pushAndRemoveUntil(
          //                 context,
          //                 MaterialPageRoute(
          //                   builder: (context) => SignInScreen(),
          //                 ),
          //                 (route) => false);
          //           },
          //           child: Text(
          //             'Log Out',
          //             style: TextStyle(fontWeight: FontWeight.w500),
          //           ),
          //         ),
          //       ),
          //     ],
          //   );
          // }
        },
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border:
                Border.all(color: title == '' ? Colors.white : Colors.black),
          ),
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Image(
              height: 20.0,
              color: title == '' ? Colors.white : Colors.black,
              image: AssetImage(
                'images/person.png',
              ),
            ),
          ),
        ),
      ),
    ],
  );
}

manageUserContent({name, email, accept, reject, type, cancelInvitationClick,deviceType}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10,),
          Text(
            name,
            style: TextStyle(
              fontSize: deviceType == DeviceType.mobile ? 16.0 : 18.0,
              color: Colors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            email,
            style: GoogleFonts.montserrat(
              fontSize: deviceType == DeviceType.mobile ? 9.0 : 14.0,
              color: Color(0xffB2B2B2),
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
     type == "invitation"? InkWell(
       onTap: cancelInvitationClick,
       child: Text(
         "Cancel invite",
         style: GoogleFonts.montserrat(
           fontSize: deviceType == DeviceType.mobile ? 12.0 : 16.0,
           fontWeight: FontWeight.w600,
           color: Colors.red,
         ),
       ),
     ): Row(
        children: [
          Container(
            width: 50,
            padding: const EdgeInsets.all(3.0),
            decoration: BoxDecoration(
              border: Border.all(
                width: 2.0,
                color: Color(0xff5AA5EF),
              ),
              borderRadius: BorderRadius.circular(5),
            ),
            child: InkWell(
              onTap: accept,
              child: Text(
                'Accept',
                textAlign: TextAlign.center,
                style: GoogleFonts.montserrat(
                  fontSize: deviceType == DeviceType.mobile ? 10.0 : 14.0,
                  color: Color(0xff020410),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          SizedBox(width: 10),
          Container(
            width: 50,
            padding: const EdgeInsets.all(3.0),
            decoration: BoxDecoration(
              border: Border.all(
                width: 2.0,
                color: Color(0xff5AA5EF),
              ),
              borderRadius: BorderRadius.circular(5),
            ),
            child: InkWell(
              onTap: reject,
              child: Text(
                'Decline',
                textAlign: TextAlign.center,
                style: GoogleFonts.montserrat(
                  fontSize: deviceType == DeviceType.mobile ? 10.0 : 14.0,
                  color: Color(0xff020410),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      )
    ],
  );
}

loginButton({context, width, DeviceType deviceType}) {
  return Align(
    alignment: Alignment.centerRight,
    child: InkWell(
      onTap: () {
        navigateReplace(context, SignInScreen());
      },
      child: Container(
        width: width * 0.16,
        padding: EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(
            color: Colors.white,
          ),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Center(
            child: Text(
              'Log In',
              style: TextStyle(
                fontSize:deviceType == DeviceType.mobile? 12.0 : 20.0,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

videoTitle({title,deviceType}) {
  return Align(
    alignment: Alignment.centerLeft,
    child: Container(
      margin: EdgeInsets.only(left: 16.0,right: 16.0),
      child: Text(
        '$title',
        style: GoogleFonts
            .montserrat(
          fontSize:
          deviceType == DeviceType.mobile ? 14.0 : 18.0,
          color:
          Colors.white,
          fontWeight:
          FontWeight.w700,
        ),
      ),
    )
  );
}

videoList(context, height, width) {
  return Container(
    height: height * 0.12,
    child: ListView.builder(
      itemCount: 3,
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.all(4),
          height: height * 0.12,
          width: width * 0.36,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('images/simon.png'),
              fit: BoxFit.fill,
            ),
          ),
        );
      },
    ),
  );
}

textFileds(context, text1, controller, node, onChanged, submitted, maxlines,
    textAlign, length) {
  return LayoutBuilder(
    builder: (context, size) {
      TextSpan text = new TextSpan(
        text: controller.text,
        style: TextStyle(
          color: Colors.black,
          fontSize: 17.0,
          fontWeight: FontWeight.w600,
        ),
      );
      TextPainter tp = new TextPainter(
        text: text,
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.left,
      );
      tp.layout(maxWidth: size.maxWidth);
      int lines = (tp.size.height / tp.preferredLineHeight).ceil();
      int maxLines = 6;
      return TextFormField(
        controller: controller
          ..selection = TextSelection.collapsed(offset: controller.text.length),
        inputFormatters: [
          LengthLimitingTextInputFormatter(length),
        ],
        focusNode: node,
        scrollPadding: EdgeInsets.only(
          // bottom: 19.0,
          left: 8.0,
          right: 8.0,
        ),
        onFieldSubmitted: submitted,
        onChanged: onChanged,
        maxLength: length,
        // maxLines: maxlines,
        maxLines: lines < maxLines ? null : maxLines,
        // minLines: 1,
        keyboardType: TextInputType.name,
        textInputAction: TextInputAction.done,
        style: TextStyle(
          color: Colors.black,
          fontSize: 17.0,
          fontWeight: FontWeight.w600,
        ),
        textAlign: textAlign,
        decoration: InputDecoration(
          focusedErrorBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.white,
            ),
          ),
          contentPadding: EdgeInsets.only(bottom: -20, left: 14.0, right: 14.0),
          hintText: text1,
          hintMaxLines: 3,
          hintStyle: TextStyle(
            color: Color(0xff9F9E9E),
            fontSize: 12.0,
            fontWeight: FontWeight.w400,
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.white,
            ),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.white,
            ),
          ),
          errorBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.white,
            ),
          ),
        ),
      );
    },
  );
}
