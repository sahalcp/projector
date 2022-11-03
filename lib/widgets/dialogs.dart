import 'dart:io';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:projector/apis/cacheService.dart';
import 'package:projector/apis/groupService.dart';
import 'package:projector/apis/promotionService.dart';
import 'package:projector/apis/videoService.dart';
import 'package:projector/apis/viewService.dart';
import 'package:projector/constant.dart';
import 'package:projector/sideDrawer/contentLayoutScreen.dart';
import 'package:projector/widgets/info_toast.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:collection/collection.dart';

List cat = ['Vacation', 'Sports', 'Gym'];
List subCat = [
  'Summer',
  'Holiday',
  'Get-Away',
];
Future contentLayoutDialog(height, width, context, title) {
  String addTitle;
  bool loading = false;
  String selectedType = 'Category';
  return showDialog(
      context: context,
      builder: (_) {
        return StatefulBuilder(builder: (context, setState) {
          return Container(
            height: height,
            width: width,
            child: Dialog(
              backgroundColor: Colors.white.withOpacity(0),
              insetPadding: EdgeInsets.only(
                left: 20.0,
                right: 20.0,
                // top: 60.0,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(32.0),
              ),
              child: Container(
                height: height * 0.24,
                width: width,
                padding: EdgeInsets.only(top: 30.0, left: 30.0, right: 30.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(32.0),
                ),
                child: ListView(
                  children: [
                    Row(
                      children: [
                        title == 'Category Title'
                            ? DropdownButton(
                                hint: Text(
                                  "$selectedType",
                                  style: GoogleFonts.poppins(
                                    color: Color(0xff1A1D2A),
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                underline: Container(
                                  height: 1,
                                  color: Colors.transparent,
                                ),
                                style: GoogleFonts.poppins(
                                  color: Color(0xff1A1D2A),
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w500,
                                ),
                                items: [
                                  DropdownMenuItem(
                                    value: 'Category',
                                    child: Text(
                                      'Category',
                                      style: GoogleFonts.poppins(
                                        color: Color(0xff1A1D2A),
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  DropdownMenuItem(
                                    value: 'Sub Category',
                                    child: Text(
                                      'Sub Category',
                                      style: GoogleFonts.poppins(
                                        color: Color(0xff1A1D2A),
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                                onChanged: (val) {
                                  //print(val);
                                  setState(() {
                                    selectedType = val;
                                  });
                                },
                              )
                            : Text(
                                '$title',
                                style: GoogleFonts.poppins(
                                  color: Color(0xff1A1D2A),
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                        // title == 'Category Title'
                        //     ? Icon(
                        //         Icons.keyboard_arrow_down,
                        //         size: 26.0,
                        //         color: Colors.black,
                        //       )
                        //     : Container()
                      ],
                    ),
                    SizedBox(height: 14),
                    Container(
                      height: height * 0.05,
                      child: TextFormField(
                        onChanged: (val) {
                          addTitle = val;
                        },
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xff5AA5EF),
                              width: 1.0,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xff5AA5EF),
                              width: 1.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    // title == 'Playlist Title'
                    //     ? Row(
                    //         children: [
                    //           Text(
                    //             'Public',
                    //             style: GoogleFonts.poppins(
                    //               color: Colors.black,
                    //               fontSize: 17.0,
                    //               fontWeight: FontWeight.w500,
                    //             ),
                    //           ),
                    //           Icon(
                    //             Icons.keyboard_arrow_down,
                    //             size: 26.0,
                    //             color: Colors.black,
                    //           )
                    //         ],
                    //       )
                    //     : Container(),
                    // SizedBox(height: 30),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          dialogButtons(height, width, 'Cancel', () {
                            Navigator.pop(context);
                          }),
                          dialogButtons(
                              height, width, loading ? 'Creating...' : 'Create',
                              () async {
                            if (addTitle != null) {
                              if (title == 'Playlist Title') {
                                setState(() {
                                  loading = true;
                                });
                                var data = await VideoService()
                                    .addEditPlaylist(title: addTitle);
                                setState(() {
                                  loading = false;
                                });
                                if (data['success'] == true)
                                  Navigator.pop(context, 'Added New Playlist');
                              } else {
                                if (selectedType == 'Category') {
                                  setState(() {
                                    loading = true;
                                  });
                                  var data = await VideoService()
                                      .addEditCategory(title: addTitle);
                                  setState(() {
                                    loading = false;
                                  });
                                  if (data['success'] == true)
                                    Navigator.pop(
                                        context, 'Added New Category');
                                } else {
                                  setState(() {
                                    loading = true;
                                  });
                                  var data = await VideoService()
                                      .addEditSubCategory(title: addTitle);
                                  setState(() {
                                    loading = false;
                                  });
                                  if (data['success'] == true)
                                    Navigator.pop(
                                        context, 'Added New Sub Category');
                                }
                              }
                            }
                          })
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        });
      });
}

Future editDialog(context, height, width, edit, {groupId, title, grpimage}) {
  String email = '', groupName = '', groupStatusMsg = '', userId = '';
  bool groupStatus = true;
  List users = [];
  List ids = [];
  List<Map<String, String>> selectedUser = [];
  File image;
  bool loading = false;

  TextEditingController controller = TextEditingController(text: title);

  return showDialog(
    context: context,
    builder: (context) {
      return SingleChildScrollView(
        child: Container(
          height: height,
          width: width,
          // color: Color(0xff333333).withOpacity(0.7),
          child: StatefulBuilder(
            builder: (context, setState) {
              List<Widget> sel = [];
              for (var item in selectedUser) {
                sel.add(ListTile(
                  trailing: InkWell(
                      onTap: () {
                        setState(() {
                          selectedUser.remove(item);
                        });
                      },
                      child: Icon(Icons.close)),
                  title: Text(
                    item['email'],
                    style: TextStyle(color: Colors.black),
                  ),
                  leading: CircleAvatar(
                    backgroundColor: Color(0xff14F47B),
                    child: Text(
                      item['email'].toString().substring(0, 1).toUpperCase(),
                      style: GoogleFonts.poppins(
                        fontSize: 21.0,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ));
              }
              groupId = groupId;
              groupName = title;
              // print(groupName);

              List<Widget> bottom = [];

              // print('userssssss' + users.toString());
              if (users != null && users.length > 0) {
                for (var index = 0; index < users.length; index++) {
                  bottom.add(InkWell(
                    onTap: () {
                      // print(selectedUser);
                      setState(() {
                        if (!ids.contains(
                          users[index]['id'],
                        )) {
                          ids.add(users[index]['id']);
                          selectedUser.add({
                            'id': users[index]['id'],
                            'email': users[index]['email'],
                          });
                        }
                      });
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 3),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Color(0xff14F47B),
                            child: Text(
                              users[index]['email']
                                  .toString()
                                  .substring(0, 1)
                                  .toUpperCase(),
                              style: GoogleFonts.poppins(
                                fontSize: 21.0,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(width: 5),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              // Text(
                              //   '',
                              //   style: GoogleFonts.poppins(
                              //     fontSize: 18.0,
                              //     fontWeight: FontWeight.w500,
                              //     color: Colors.black,
                              //   ),
                              // ),
                              Container(
                                width: width * 0.5,
                                child: Text(
                                  '${users[index]['email']}',
                                  style: GoogleFonts.poppins(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xff63676C),
                                  ),
                                  maxLines: 2,
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ));
                }
              }

              return Dialog(
                backgroundColor: Colors.white.withOpacity(0),
                insetPadding: EdgeInsets.only(
                  left: 20.0,
                  right: 20.0,
                  top: 60.0,
                  bottom: 80.0,
                ),
                child: ListView(
                  children: [
                    Container(
                      width: width,
                      height: height * 0.54,
                      padding: EdgeInsets.only(
                        left: 20,
                        right: 17.0,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.0),
                        border: Border.all(
                          color: Color(0xff707070),
                        ),
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 8.0),
                              child: InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Icon(Icons.close),
                              ),
                            ),
                            Row(
                              children: [
                                InkWell(
                                  onTap: () async {
                                    final pickedFile = await ImagePicker()
                                        .getImage(source: ImageSource.gallery);
                                    setState(() {
                                      image = File(pickedFile.path);
                                    });
                                  },
                                  child: image == null
                                      ? grpimage == null
                                          ? CircleAvatar(
                                              backgroundColor:
                                                  Color(0xff5AA5EF),
                                              child: Image(
                                                height: 24,
                                                image: AssetImage(
                                                    'images/addPerson.png'),
                                              ),
                                            )
                                          : CircleAvatar(
                                              backgroundColor:
                                                  Color(0xff5AA5EF),
                                              backgroundImage:
                                                  NetworkImage(grpimage),
                                            )
                                      : CircleAvatar(
                                          backgroundColor: Color(0xff5AA5EF),
                                          backgroundImage: FileImage(image),
                                          // child: Image(
                                          //   height: 24,
                                          //   image: AssetImage('images/addPerson.png'),
                                          // ),
                                        ),
                                ),
                                SizedBox(width: 23),
                                // Text(
                                //   'Edit Group Name',
                                //   style: GoogleFonts.poppins(
                                //     fontSize: 20.0,
                                //     fontWeight: FontWeight.w500,
                                //   ),
                                // ),
                                Container(
                                  height: height * 0.05,
                                  width: width * 0.5,
                                  child: TextFormField(
                                    controller: controller,
                                    readOnly: !edit,
                                    maxLines: 1,
                                    onChanged: (val) {
                                      setState(() {
                                        groupName = val;
                                      });
                                      // print(groupName);
                                    },
                                    style: GoogleFonts.poppins(
                                      fontSize: 20.0,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.all(0),
                                      hintText: 'Edit Group Name',
                                      hintStyle: GoogleFonts.poppins(
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            groupStatus
                                ? Container()
                                : Center(
                                    child: Text(
                                      groupStatusMsg,
                                      style: GoogleFonts.poppins(
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                            SizedBox(height: 10),
                            Column(
                              children: sel,
                            ),
                            TextFormField(
                              style: GoogleFonts.poppins(
                                fontSize: 15.0,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                              ),
                              keyboardType: TextInputType.emailAddress,
                              // ignore: missing_return
                              onChanged: (val) async {
                                email = val;
                                var data = await GroupService()
                                    .searchUserFriendList(email);

                                // GrpModel model =
                                //     grpModelFromJson(jsonEncode(data));
                                if (data['success'] == true) {
                                  setState(() {
                                    users = data['data'];
                                    // userId = data['data'][0]['id'];
                                    // print("userslist -->"+users.toString());
                                  });
                                } else {
                                  setState(() {
                                    users = [];
                                  });
                                }
                              },

                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Color(0xffF8F9FA),
                                hintText: 'Add people to group',
                                hintStyle: GoogleFonts.poppins(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w400,
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
                                    // width: 2,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: height * 0.05),
                            Column(
                              children: bottom,
                            ),
                            SizedBox(height: 20),
                            Center(
                              child: Container(
                                height: height * 0.06,
                                width: width * 0.3,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(7),
                                  // color: Color(0xff5AA5EF),
                                ),
                                child: RaisedButton(
                                  color: Color(0xff5AA5EF),
                                  padding: EdgeInsets.all(0),
                                  onPressed: () async {
                                    if (edit) {
                                      if (groupName ?? '' != '') {
                                        var data =
                                            await GroupService().addNewGroup(
                                          controller.text,
                                          image,
                                        );
                                        setState(() {
                                          groupStatus = false;
                                          groupStatusMsg = data['message'];
                                        });
                                        var groupId = data['id'];
                                        List problems = [];
                                        // if (EmailValidator.validate(email)) {
                                        if (data['success'] == true) {
                                          for (var item in selectedUser) {
                                            var d = await GroupService()
                                                .addMembersToGroup(
                                              groupId,
                                              item['id'],
                                            );
                                            if (d['success'] != true) {
                                              problems.add(item);
                                            }
                                            // print('messageeee' + d);
                                          }

                                          if (problems.length == 0) {
                                            Navigator.pop(context, 'Added');
                                          } else {
                                            String ayoo = '';
                                            for (var item in problems) {
                                              ayoo += item['email'] + ',';
                                            }
                                            Navigator.pop(context);
                                          }
                                        } else {
                                          showConfirmDialog(context,
                                              text: data['message']);
                                        }

                                        // }
                                        // else{
                                        //   Navigator.pop(context,'Group Name already exist');
                                        // }
                                      }
                                    } else {
                                      // if (EmailValidator.validate(email)) {
                                      // print('xxxxx');
                                      List problems = [];
                                      // var data = await GroupServcie()
                                      //     .addMembersToGroup(groupId, userId);
                                      for (var item in selectedUser) {
                                        // print(item['id']);
                                        var d = await GroupService()
                                            .addMembersToGroup(
                                                groupId, item['id']);
                                        if (d['success'] != true) {
                                          problems.add(item);
                                        }
                                      }
                                      // print(groupId);
                                      if (problems.length == 0) {
                                        Navigator.pop(context, 'Added');
                                        showConfirmDialog(context,
                                            text: 'Members added to group');
                                      } else
                                        showConfirmDialog(context,
                                            text: 'Error');
                                      // }
                                      // else {
                                      //   print('workx');
                                      // }
                                    }
                                  },
                                  child: Center(
                                    child: Text(
                                      'Done',
                                      style: GoogleFonts.poppins(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: height * .055,
                            )
                          ],
                        ),
                      ),
                    ),
                    // SizedBox(height: height * 0.02),
                    // Container(
                    //   width: width,
                    //   padding: EdgeInsets.only(
                    //       left: 24, top: 20.0, right: 40.0, bottom: 24.0),
                    //   decoration: BoxDecoration(
                    //     color: Colors.white,
                    //     borderRadius: BorderRadius.circular(12.0),
                    //     border: Border.all(
                    //       color: Color(0xff707070),
                    //     ),
                    //   ),
                    //   child: Column(
                    //     crossAxisAlignment: CrossAxisAlignment.end,
                    //     children: [
                    //       Row(
                    //         mainAxisAlignment: MainAxisAlignment.start,
                    //         children: [
                    //           Image(
                    //             height: height * 0.035,
                    //             image: AssetImage('images/link.png'),
                    //           ),
                    //           SizedBox(width: width * 0.001),
                    //           Text(
                    //             'Get Link',
                    //             style: GoogleFonts.poppins(
                    //               fontSize: 31.0,
                    //               fontWeight: FontWeight.w500,
                    //             ),
                    //           ),
                    //         ],
                    //       ),
                    //       SizedBox(height: 7.0),
                    //       RichText(
                    //         text: TextSpan(
                    //           children: [
                    //             TextSpan(
                    //               text: 'Restricted',
                    //               style: GoogleFonts.poppins(
                    //                   fontSize: 14.0,
                    //                   fontWeight: FontWeight.w600,
                    //                   color: Colors.black),
                    //             ),
                    //             TextSpan(
                    //               text:
                    //                   ' Only people added can open with this link',
                    //               style: GoogleFonts.poppins(
                    //                 color: Colors.black,
                    //                 fontSize: 14.0,
                    //                 fontWeight: FontWeight.w500,
                    //               ),
                    //             ),
                    //           ],
                    //         ),
                    //       ),
                    //       SizedBox(height: height * 0.02),
                    //       InkWell(
                    //         onTap: () {
                    //           Fluttertoast.showToast(
                    //             msg: 'Link copied to clipboard',
                    //             gravity: ToastGravity.BOTTOM,
                    //           );
                    //         },
                    //         child: Text(
                    //           'Copy Link',
                    //           style: GoogleFonts.poppins(
                    //             fontSize: 12.0,
                    //             fontWeight: FontWeight.w600,
                    //             color: Color(0xff5AA5EF),
                    //           ),
                    //         ),
                    //       )
                    //     ],
                    //   ),
                    // )
                  ],
                ),
              );
            },
          ),
        ),
      );
    },
  );
}

requestAccessDialog(context, height, width) {
  String email = '';
  List users = [];
  return showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(builder: (context, setState) {
        return Container(
          height: height * 0.4,
          width: width * 0.5,
          // color: Color(0xff333333).withOpacity(0.7),
          child: Dialog(
            backgroundColor: Colors.white.withOpacity(0),
            insetPadding: EdgeInsets.only(
              left: 20.0,
              right: 20.0,
              top: 60.0,
              bottom: 80.0,
            ),
            child: Container(
              width: width * 0.5,
              height: height * 0.54,
              padding: EdgeInsets.only(
                left: 20,
                right: 17.0,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.0),
                border: Border.all(
                  color: Color(0xff707070),
                ),
              ),
              child: ListView(
                // crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(height: 10),
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Color(0xff5AA5EF),
                        child: Image(
                          height: 24,
                          image: AssetImage('images/addPerson.png'),
                        ),
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Request Access to View',
                        style: GoogleFonts.poppins(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    style: GoogleFonts.poppins(
                      fontSize: 15.0,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                    keyboardType: TextInputType.emailAddress,
                    // ignore: missing_return
                    onChanged: (val) async {
                      email = val;
                      var data = await ViewService().searchUser(email);
                      if (data['success'] == true) {
                        setState(() {
                          users = data['data'];
                        });
                      } else {
                        setState(() {
                          users = [];
                        });
                      }
                    },
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Color(0xffF8F9FA),
                      hintText: 'Search Email',
                      hintStyle: GoogleFonts.poppins(
                        fontSize: 15.0,
                        fontWeight: FontWeight.w400,
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
                          // width: 2,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: height * 0.05),
                  ListView.builder(
                    itemCount: users.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Color(0xff14F47B),
                            child: Text(
                              users[index]['email']
                                  .toString()
                                  .substring(0, 1)
                                  .toUpperCase(),
                              style: GoogleFonts.poppins(
                                fontSize: 21.0,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(width: 5),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              // Text(
                              //   '',
                              //   style: GoogleFonts.poppins(
                              //     fontSize: 18.0,
                              //     fontWeight: FontWeight.w500,
                              //     color: Colors.black,
                              //   ),
                              // ),
                              Container(
                                width: width * 0.5,
                                child: Text(
                                  '${users[index]['email']}',
                                  style: GoogleFonts.poppins(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xff63676C),
                                  ),
                                  maxLines: 2,
                                ),
                              )
                            ],
                          )
                        ],
                      );
                    },
                  ),
                  SizedBox(height: height * 0.03),
                  Align(
                    alignment: Alignment.centerRight,
                    child: InkWell(
                      onTap: () async {
                        if (EmailValidator.validate(email)) {
                          if (users.length != 0) {
                            var data = await ViewService()
                                .sendViewRequest(users[0]['id']);
                            Navigator.pop(context, data);
                          } else {
                            var data = await ViewService()
                                .getAllViewRequestSent('1', context);
                          }
                        }
                      },
                      child: Container(
                        alignment: Alignment.centerRight,
                        height: height * 0.06,
                        width: width * 0.3,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(7),
                          color: Color(0xff5AA5EF),
                        ),
                        child: Center(
                          child: Text(
                            'Done',
                            style: GoogleFonts.poppins(
                              fontSize: 18.0,
                              fontWeight: FontWeight.w400,
                              color: Colors.white,
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
        );
      });
    },
  );
}

showAuthDialog(context, height, width, {text, button, onTap}) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        content: Builder(
          builder: (context) {
            return Container(
              height: height * 0.14,
              child: Column(
                children: [
                  Text(
                    text,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 13.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: onTap,
                        child: Container(
                          margin: EdgeInsets.all(2.0),
                          height: height * 0.05,
                          width: width * 0.24,
                          decoration: BoxDecoration(
                            color: Color(0xff5AA5EF),
                            borderRadius: BorderRadius.circular(6.0),
                          ),
                          child: Center(
                            child: Text(
                              button,
                              style: TextStyle(
                                fontSize: 18.0,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          margin: EdgeInsets.all(2.0),
                          height: height * 0.05,
                          width: width * 0.24,
                          decoration: BoxDecoration(
                            color: Color(0xff5AA5EF),
                            borderRadius: BorderRadius.circular(6.0),
                          ),
                          child: Center(
                            child: Text(
                              'Cancel',
                              style: TextStyle(
                                fontSize: 18.0,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            );
          },
        ),
      );
    },
  );
}

showConfirmDialog(context, {text}) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        content: Text(
          text,
          style: TextStyle(
            color: Colors.black,
            fontSize: 17.0,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
      );
    },
  );
}

storageDialog(context, height, width) {
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
              left: 35.0,
              right: 35.0,
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
                                  SizedBox(height: 20),
                                  InkWell(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: Align(
                                      alignment: Alignment.topRight,
                                      child: Container(
                                          child: Icon(
                                        Icons.close,
                                        color: Colors.black,
                                        size: 20,
                                      )),
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    "Action Required",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.montserrat(
                                      fontSize: 28.0,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.black,
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Go to",
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.montserrat(
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.black,
                                        ),
                                      ),
                                      Text(
                                        " www.projector.app",
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.montserrat(
                                          fontSize: 17.0,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.indigoAccent,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    "to manage your storage",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.montserrat(
                                      fontSize: 17.0,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    "and viewer options!",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.montserrat(
                                      fontSize: 17.0,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black,
                                    ),
                                  ),
                                  SizedBox(height: 50),
                                  Align(
                                    alignment: FractionalOffset.center,
                                    child: Container(
                                      margin:
                                          EdgeInsets.only(left: 50, right: 50),
                                      child: SizedBox(
                                        height: 50,
                                        width: double.infinity,
                                        child: ElevatedButton(
                                          style: ButtonStyle(
                                              shape: MaterialStateProperty.all<
                                                      RoundedRectangleBorder>(
                                                  RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5.0),
                                                      side: BorderSide(
                                                          color:
                                                              Colors.blue)))),
                                          child: Text(
                                            "Go",
                                            style: GoogleFonts.montserrat(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.white,
                                            ),
                                          ),
                                          onPressed: () {
                                            launch(serverPlanUrl);
                                            Navigator.pop(context);
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
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

showPromotionDialog(
    {BuildContext context,
    String promoCode,
    String promoValue,
    int skipCount}) async {
  if (promoCode == null || promoValue == null) {
    final promoList = await PromotionService().getUserPromotion();
    if (promoList != null) {
      final userPromo =
          promoList.firstWhereOrNull((e) => e['promo_type'] == "1");
      promoCode = userPromo['promo_code'];
      promoValue = userPromo['promo_value'];
    } else {
      return;
    }
  }

  return showDialog<String>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) => AlertDialog(
      titlePadding: EdgeInsets.all(0),
      contentPadding: EdgeInsets.fromLTRB(24.0, 32.0, 24.0, 12.0),
      actionsPadding: EdgeInsets.all(24.0),
      actionsAlignment: MainAxisAlignment.center,
      title: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              icon: Icon(Icons.close, size: 32.0),
              onPressed: () async {
                // If the promo is skipped for first time or already once skipped.
                if (skipCount == null) {
                  CacheService()
                      .storeIntToCache(key: "promoSkipCount", value: 1);
                } else {
                  CacheService().storeIntToCache(
                      key: "promoSkipCount", value: skipCount + 1);
                  PromotionService().updatePromoCodePopUpSkipped();
                }
                Navigator.pop(context);
              },
            ),
          ),
          SizedBox(height: 8.0),
          const Text(
            'Upgrade Now and Save',
            style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Get $promoValue FREE months of an upgraded package today!',
            style: TextStyle(
              fontSize: 26.0,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24.0),
          Text(
            'Store, share and stream all your memories, pictures and videos in one spot',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          )
        ],
      ),
      actions: <Widget>[
        ElevatedButton(
          child: Text(
            'GET $promoValue FREE MONTHS NOW',
            textAlign: TextAlign.center,
          ),
          onPressed: () async {
            final result = await PromotionService().addUserPromotion(promoCode);

            if (result) {
              CacheService().storeIntToCache(key: "promoSkipCount", value: 2);
              Navigator.pop(context);
              InfoToast.showSnackBar(context,
                  message:
                      "Congrats! Offer grabbed.. It will be applied once you purchase a plan.");
            } else {
              InfoToast.showSnackBar(context,
                  message: "Could not apply promo code. Please try again.");
              Navigator.pop(context);
            }
          },
        ),
      ],
    ),
  );
}
