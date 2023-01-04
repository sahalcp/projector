import 'dart:async';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projector/apis/contentDashboardService.dart';
import 'package:projector/apis/viewService.dart';

class SuccessorListPage extends StatefulWidget {
  const SuccessorListPage({Key key}) : super(key: key);

  @override
  State<SuccessorListPage> createState() => _SuccessorListPageState();
}

class _SuccessorListPageState extends State<SuccessorListPage> {
  StreamController streamSuccessorList = StreamController.broadcast();
  bool centerProgressIndicator = false;
  bool spin = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    ContentDashboardService().getSuccessorsList().then((val) {
      streamSuccessorList.add(val);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
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
            "Successors",
            style: GoogleFonts.montserrat(
              color: Colors.black,
              fontSize: 20.0,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        actions: [
          InkWell(
              onTap: () {
                requestDialog(context, height, width);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Add Successor ",
                    style: GoogleFonts.montserrat(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w700,
                      color: Colors.blue,
                    ),
                  ),
                  Text(
                    "+",
                    style: GoogleFonts.montserrat(
                      fontSize: 17.0,
                      fontWeight: FontWeight.w700,
                      color: Colors.blue,
                    ),
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                ],
              ))
        ],
      ),
      key: _scaffoldKey,
      body: Container(
        margin: EdgeInsets.only(left: 16.0, right: 16.0, top: 25.0),
        child: Stack(
          children: [
            ListView(
              children: [
                StreamBuilder(
                  stream: streamSuccessorList.stream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return SingleChildScrollView(
                        child: ListView.builder(
                          itemCount: snapshot.data.length,
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            var userId = '',
                                userEmail = '',
                                firstName = '',
                                lastName = '';

                            if (index != snapshot.data.length) {
                              userId = snapshot.data[index]['id'];
                              userEmail = snapshot.data[index]['email'];
                              firstName = snapshot.data[index]['firstname'];
                              lastName = snapshot.data[index]['lastname'];
                            }

                            return Stack(
                              children: [
                                Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: 37,
                                          height: 37,
                                          decoration: BoxDecoration(
                                            border: Border.all(width: 1),
                                            shape: BoxShape.circle,
                                            // You can use like this way or like the below line
                                            //borderRadius: new BorderRadius.circular(30.0),
                                            color: Colors.grey[300],
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              Text(
                                                '${firstName[0].toUpperCase()}',
                                                style: GoogleFonts.montserrat(
                                                    fontSize: 16.0,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.black),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Flexible(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "$firstName" + " $lastName",
                                                style: GoogleFonts.montserrat(
                                                  fontSize: 12.0,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 3,
                                              ),
                                              Align(
                                                alignment: Alignment.topLeft,
                                                child: Text(
                                                  "$userEmail",
                                                  style: GoogleFonts.montserrat(
                                                    fontSize: 10.0,
                                                    fontWeight: FontWeight.w400,
                                                    color: Color(0xffB2B2B2),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Row(
                                          children: [
                                            InkWell(
                                              child: Container(
                                                child: Text(
                                                  "Remove",
                                                  style: GoogleFonts.montserrat(
                                                    fontSize: 11.0,
                                                    fontWeight: FontWeight.w600,
                                                    color: Color(0xffFF0000),
                                                  ),
                                                ),
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: Colors.black,
                                                      width: 1.5),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          5.0),
                                                ),
                                                padding:
                                                    const EdgeInsets.all(7.0),
                                              ),
                                              onTap: () async {
                                                setState(() {
                                                  centerProgressIndicator =
                                                      true;
                                                });

                                                var response =
                                                    await ContentDashboardService()
                                                        .deleteSuccessor(
                                                            userId: userId);
                                               // print("response---->$response");

                                                if (response["success"]) {
                                                  setState(() {
                                                    centerProgressIndicator =
                                                        false;
                                                  });

                                                  ContentDashboardService()
                                                      .getSuccessorsList()
                                                      .then((val) {
                                                    streamSuccessorList.add(val);
                                                  });
                                                } else {
                                                  setState(() {
                                                    centerProgressIndicator =
                                                        false;
                                                  });
                                                }
                                              },
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 30,
                                    ),
                                  ],
                                ),
                                Visibility(
                                  visible: false,
                                  child: Positioned(
                                    top: 0,
                                    left: 0,
                                    right: 0,
                                    child: Center(
                                      child: Container(
                                        height: 30,
                                        width: 30,
                                        margin: EdgeInsets.all(5),
                                        child: CircularProgressIndicator(),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      );
                    } else {
                      return Center();
                    }
                  },
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
            Visibility(
              visible: centerProgressIndicator,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ],
        ),
      ),
    );
  }
  requestDialog(context, height, width) {
    FocusNode node = FocusNode();
    TextEditingController reqDataCon = TextEditingController();
    String email = '';
    List users = [];
    List selectedUsers = [];
    List selectedUsersEmail = [], userNames = [];
    return showDialog(
      context: context,
      barrierColor: Color(0xff333333).withOpacity(0.7),
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          List<Widget> bottom = [];

          if (users != null && users.length > 0) {
            for (var index = 0; index < users.length; index++) {
              bottom.add(
                ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 5),
                  onTap: () {
                    if (selectedUsers.contains(users[index]['id'])) {
                      setState(() {
                        reqDataCon = TextEditingController(text: '');
                        selectedUsers.remove(users[index]['id']);
                        selectedUsersEmail.remove(users[index]['email']);
                        userNames.remove(users[index]['firstname']);
                      });
                    } else {
                      setState(() {
                        reqDataCon = TextEditingController(text: '');
                        selectedUsers.add(users[index]['id']);
                        selectedUsersEmail.add(users[index]['email']);
                        userNames.add(users[index]['firstname']);
                      });
                    }
                  },
                  leading: selectedUsers.contains(users[index]['id'])
                      ? Container()
                      : CircleAvatar(
                    backgroundColor:
                    selectedUsers.contains(users[index]['id'])
                        ? Colors.grey
                        : Color(0xff14F47B),
                    child: Text(
                      users[index]['email']
                          .toString()
                          .substring(0, 1)
                          .toUpperCase(),
                      style: GoogleFonts.poppins(
                        fontSize: 15.0,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  title: selectedUsers.contains(users[index]['id'])
                      ? Container()
                      : Text(
                    '${users[index]['firstname']}' +
                        " " +
                        '${users[index]['lastname']}',
                    style: GoogleFonts.poppins(
                      fontSize: 15.0,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  subtitle: selectedUsers.contains(users[index]['id'])
                      ? Container()
                      : Text(
                    '${users[index]['email']}',
                    style: GoogleFonts.poppins(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[500],
                    ),
                  ),
                ),
              );
            }
          }

          return Container(
            height: height * 0.5,
            // width: width * 0.5,
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
                height: height * 0.6,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.0),
                  border: Border.all(
                    color: Color(0xff707070),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Stack(
                    children: [
                      Container(
                        height: height * 0.58,
                        child: Column(
                          children: [
                            Container(
                              // width: width * 0.5,
                              height: height * 0.5,
                              padding: EdgeInsets.only(
                                left: 20,
                                right: 17.0,
                              ),

                              child: Container(
                                // height: height * 0.2,
                                child: SingleChildScrollView(
                                  child: Column(
                                    // crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      SizedBox(height: 10),
                                      Align(
                                        alignment: Alignment.topRight,
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
                                      SizedBox(height: 20),
                                      Row(
                                        children: [
                                          CircleAvatar(
                                            backgroundColor: Color(0xff5AA5EF),
                                            child: Image(
                                              height: 24,
                                              image: AssetImage(
                                                  'images/addPerson.png'),
                                            ),
                                          ),
                                          SizedBox(width: 10),
                                          Text(
                                            'Add Successor',
                                            style: GoogleFonts.poppins(
                                              fontSize: 16.0,
                                              // fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 10),
                                      ListView.builder(
                                        itemCount: userNames.length,
                                        shrinkWrap: true,
                                        itemBuilder: (context, index) {
                                          return InkWell(
                                            onTap: () {
                                              setState(() {
                                                selectedUsers
                                                    .remove(users[index]['id']);
                                                selectedUsersEmail.remove(
                                                    users[index]['email']);
                                                userNames.remove(
                                                    users[index]['firstname']);
                                              });
                                            },
                                            child: FittedBox(
                                              fit: BoxFit.scaleDown,
                                              alignment: Alignment.topLeft,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                  BorderRadius.circular(16),
                                                  border: Border.all(
                                                      color: Colors.grey),
                                                ),
                                                // width: width * 0.5,
                                                margin: EdgeInsets.symmetric(
                                                    horizontal: 2, vertical: 4),
                                                padding: EdgeInsets.all(6),
                                                child: Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      selectedUsersEmail[index],
                                                      style:
                                                      GoogleFonts.poppins(
                                                        fontSize: 13,
                                                        fontWeight:
                                                        FontWeight.w500,
                                                      ),
                                                    ),
                                                    SizedBox(width: 5),
                                                    CircleAvatar(
                                                      radius: 8,
                                                      backgroundColor:
                                                      Colors.grey,
                                                      child: Center(
                                                        child: Icon(
                                                          Icons.close,
                                                          size: 14,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                      SizedBox(height: 10),
                                      TextFormField(
                                        focusNode: node,
                                        style: GoogleFonts.poppins(
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black,
                                        ),
                                        controller: reqDataCon,
                                        keyboardType:
                                        TextInputType.emailAddress,
                                        // ignore: missing_return
                                        onTap: () {
                                          setState(() {});
                                        },
                                        onFieldSubmitted: (val) {
                                          setState(() {});
                                        },
                                        onChanged: (val) async {
                                          email = val;
                                         // if (EmailValidator.validate(email.trim())) {
                                            var data =
                                            await ContentDashboardService()
                                                .searchUserSuccessor(
                                                email: email);
                                            // print(data);
                                            if (data != null &&
                                                data['success'] == true) {
                                              setState(() {
                                                users = data['data'];
                                              });
                                            } else {
                                              setState(() {
                                                users = [];
                                              });
                                            }
                                          //}
                                        },
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: Color(0xffF8F9FA),
                                          hintText: 'Search Users',
                                          hintStyle: GoogleFonts.poppins(
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.w500,
                                            color: Color(0xff8E8E8E),
                                          ),
                                          border: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Colors.white,
                                              // width: 2,
                                            ),
                                          ),
                                          enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Colors.white,
                                              // width: 2,
                                            ),
                                          ),
                                          focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: 2.5,
                                        color: Color(0xff5AA5EF),
                                      ),
                                      Container(
                                        // color: Colors.green,
                                        height: height * 0.3,
                                        child: ListView(
                                          shrinkWrap: true,
                                          children: bottom,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        //bottom: node.hasFocus ? height * 0.18 : 10,
                        bottom: node.hasFocus ? 10 : 10,
                        left: width * 0.22,
                        child: Container(
                          // alignment: Alignment.bottomCenter,
                          child: Center(
                            child: Container(
                              alignment: Alignment.center,
                              height: height * 0.055,
                              width: width * 0.45,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(7),
                              ),
                              child: ElevatedButton(
                                // shape: RoundedRectangleBorder(
                                //   borderRadius: BorderRadius.circular(7),
                                // ),
                                onPressed: () async {

                                  if(email.isEmpty || email==""){
                                    Fluttertoast
                                        .showToast(
                                        msg:
                                        'Enter email',backgroundColor: Colors.white,textColor: Colors.black);

                                  }else{
                                    setState(() {
                                      spin = true;
                                    });

                                    var data = await ContentDashboardService()
                                        .addSuccessors(user: selectedUsers);

                                    // _scaffoldKey.currentState
                                    //     .removeCurrentSnackBar();

                                    setState(() {
                                      spin = false;
                                    });
                                    ContentDashboardService().getSuccessorsList().then((val) {
                                      streamSuccessorList.add(val);
                                    });

                                    reqDataCon.text = '';
                                    Navigator.pop(context, data);
                                  }

                                },
                                child: Center(
                                  child: spin
                                      ? CircularProgressIndicator(
                                      color: Colors.white)
                                      : Text(
                                    'Done',
                                    style: GoogleFonts.poppins(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        });
      },
    );
  }
}
