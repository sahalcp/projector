import 'dart:io';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projector/apis/contentDashboardService.dart';
import 'package:projector/apis/groupService.dart';
import 'package:projector/apis/videoService.dart';

requestDialog({scaffoldKey, context, height, width, type, spin, groupId}) {
  FocusNode node = FocusNode();
  TextEditingController reqDataCon = TextEditingController();
  TextEditingController controller = TextEditingController(text: "");
  String email = '';
  List users = [];
  List selectedUsers = [];
  bool edit = true;
  List selectedUsersEmail = [], userNames = [];
  File image;
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
                                        type == "AddMemberGroup"
                                            ? Text(
                                                "Add group member",
                                                style: GoogleFonts.poppins(
                                                  fontSize: 16.0,
                                                  // fontWeight: FontWeight.w700,
                                                ),
                                              )
                                            : Container(
                                                height: height * 0.05,
                                                width: width * 0.5,
                                                child: TextFormField(
                                                  controller: controller,
                                                  readOnly: !edit,
                                                  maxLines: 1,
                                                  onChanged: (val) {
                                                    setState(() {
                                                      //groupName = val;
                                                    });
                                                    // print(groupName);
                                                  },
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 20.0,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                  decoration: InputDecoration(
                                                    contentPadding:
                                                        EdgeInsets.all(0),
                                                    hintText:
                                                        'Enter Group Name',
                                                    hintStyle:
                                                        GoogleFonts.poppins(
                                                      fontSize: 18.0,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
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
                                                    style: GoogleFonts.poppins(
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
                                      keyboardType: TextInputType.emailAddress,
                                      // ignore: missing_return
                                      onTap: () {
                                        setState(() {});
                                      },
                                      onFieldSubmitted: (val) {
                                        setState(() {});
                                      },
                                      onChanged: (val) async {
                                        email = val;
                                        if (EmailValidator.validate(
                                            email.trim())) {
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
                                        }
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
                              //),
                              onPressed: () async {
                                if (email.isEmpty || email == "") {
                                  Fluttertoast.showToast(
                                      msg: 'Enter email',
                                      backgroundColor: Colors.white,
                                      textColor: Colors.black);
                                } else {
                                  setState(() {
                                    spin = true;
                                  });

                                  if (type == "AddGroup") {
                                    var data = await GroupService().addNewGroup(
                                      controller.text,
                                      image,
                                    );
                                    var groupId = data['id'];
                                    if (data['success'] == true) {
                                      for (var item in selectedUsers) {
                                        var data = await GroupService()
                                            .addMembersToGroup(
                                          groupId,
                                          item,
                                        );

                                        reqDataCon.text = '';
                                        Navigator.pop(context, data);

                                        GroupService()
                                            .getMyGroups()
                                            .then((val) {
                                          //streamGroupList.add(val);
                                        });
                                      }

                                      setState(() {
                                        spin = false;
                                      });
                                    }
                                  } else if (type == "AddMemberGroup") {
                                    for (var item in selectedUsers) {
                                      var data = await GroupService()
                                          .addMembersToGroup(
                                        groupId,
                                        item,
                                      );

                                      reqDataCon.text = '';
                                      Navigator.pop(context, data);

                                      GroupService().getMyGroups().then((val) {
                                        //streamGroupList.add(val);
                                      });
                                    }

                                    // scaffoldKey.currentState
                                    //     .removeCurrentSnackBar();

                                    setState(() {
                                      spin = false;
                                    });
                                  }
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

removeDialog({context, height, width, String groupName, String groupId}) {
  return showDialog(
    context: context,
    barrierColor: Color(0xff333333).withOpacity(0.7),
    builder: (context) {
      return StatefulBuilder(builder: (context, setState) {
        return Container(
          height: height * 0.5,
          color: Color(0xff333333).withOpacity(0.3),
          child: Dialog(
            backgroundColor: Colors.white.withOpacity(0),
            insetPadding: EdgeInsets.only(
              left: 26.0,
              right: 25.0,
              top: 60.0,
              bottom: 50.0,
            ),
            child: Container(
              //height: height * 0.6,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30.0),
                border: Border.all(
                  color: Color(0xff707070),
                ),
              ),
              child: SingleChildScrollView(
                child: Stack(
                  children: [
                    Container(
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.only(
                              left: 20,
                              right: 17.0,
                              bottom: 50,
                            ),
                            child: Container(
                              child: Column(
                                children: [
                                  SizedBox(height: 40),
                                  Text(
                                    "Delete " + groupName + "?",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.montserrat(
                                      fontSize: 25.0,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black,
                                    ),
                                  ),
                                  SizedBox(height: 30),
                                  Text(
                                    "Are you sure you want to delete",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.montserrat(
                                      fontSize: 17.0,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xff0A112B),
                                    ),
                                  ),
                                  SizedBox(height: 50),
                                  Align(
                                    alignment: FractionalOffset.center,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        ButtonTheme(
                                          shape: new RoundedRectangleBorder(
                                              side: BorderSide(
                                                  color: Colors.grey[600],
                                                  width: 1.0)),
                                          child: ElevatedButton(
                                          
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                  left: 10,
                                                  right: 10,
                                                  top: 5,
                                                  bottom: 5),
                                              child: Text(
                                                "Remove",
                                                style: GoogleFonts.montserrat(
                                                  fontSize: 16.0,
                                                  fontWeight: FontWeight.w500,
                                                  color: Color(0xffFF0000),
                                                ),
                                              ),
                                            ),
                                            onPressed: () async {
                                              var response =
                                                  await VideoService()
                                                      .deleteGroup(
                                                          groupId: groupId);
                                              if (response["success"]) {
                                                GroupService()
                                                    .getMyGroups()
                                                    .then((val) {
                                                  //streamGroupList.add(val);
                                                });

                                                Navigator.pop(context);
                                              }
                                            },
                                          ),
                                        ),
                                        SizedBox(
                                          width: 20,
                                        ),
                                        ElevatedButton(
                                  
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                                left: 10,
                                                right: 10,
                                                top: 5,
                                                bottom: 5),
                                            child: Text(
                                              "Go Back",
                                              style: GoogleFonts.montserrat(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
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
                    Visibility(
                      visible: false,
                      child: Positioned(
                        top: 100,
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
                ),
              ),
            ),
          ),
        );
      });
    },
  );
}
