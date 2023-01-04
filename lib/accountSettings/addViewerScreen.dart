import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:projector/apis/groupService.dart';
import 'package:projector/apis/videoService.dart';
import 'package:projector/apis/viewService.dart';
import 'package:projector/widgets/dialogs.dart';

class AddViewerScreen extends StatefulWidget {
  @override
  _AddViewerScreenState createState() => _AddViewerScreenState();
}

class _AddViewerScreenState extends State<AddViewerScreen> {
  bool addViewer = false;
  List users = [];
  List success = [];
  bool loading = false;
  int count = 1;
  List downUsers = [];
  List upuserid = [];
  List upusername = [];
  List intername = [];
  List interid = [];

  TextEditingController emailC = TextEditingController();
  TextEditingController fnameC = TextEditingController();
  TextEditingController lnameC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        body: WillPopScope(
          onWillPop: () {
            if (addViewer) {
              setState(() {
                addViewer = false;
              });
            } else {
              Navigator.pop(context);
            }
          },
          child: ModalProgressHUD(
            inAsyncCall: loading,
            child: Container(
              color: Colors.white,
              child: ListView(
                children: [
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
                          'Connected Accounts',
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
                  SizedBox(height: 10),
                  Container(
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
                            addViewer
                                ? 'Add new viewer'
                                : 'Add viewer/accept user',
                            style: GoogleFonts.poppins(
                              fontSize: 13.0,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
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
                              color: Colors.black,
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Container(
                          height: addViewer
                              ? height + 3 + (upuserid.length - 1) * 200
                              : null,
                          width: width,
                          color: Color(0xffF7F7F7),
                          child: addViewer
                              ? Container(
                                  color: Colors.white,
                                  margin: EdgeInsets.only(
                                    left: 20,
                                    top: 20.0,
                                    right: 20.0,
                                    bottom: 25.0,
                                  ),
                                  padding: EdgeInsets.only(
                                    left: 15.0,
                                    top: 12.0,
                                    right: 15.0,
                                  ),
                                  width: width,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'We will automatically add the viewer to your authorized\nlist of viewers',
                                        style: GoogleFonts.montserrat(
                                          fontSize: 10.0,
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xff1A1D2A),
                                        ),
                                      ),
                                      Divider(
                                        height: 10.0,
                                        color: Color(0xffB9B8B8),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Viewers',
                                            style: GoogleFonts.poppins(
                                              fontSize: 13.0,
                                              fontWeight: FontWeight.w600,
                                              color: Color(0xff141720),
                                            ),
                                          ),
                                          Text(
                                            '0 of 999',
                                            style: GoogleFonts.montserrat(
                                              fontSize: 10.0,
                                              fontWeight: FontWeight.w500,
                                              color: Color(0xff5AA5EF),
                                            ),
                                          )
                                        ],
                                      ),
                                      Container(
                                        // height: upuserid.length < 4
                                        //     ? upuserid.length * 60.0
                                        //     : 200,
                                        child: ListView.builder(
                                            shrinkWrap: true,
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            itemCount: upuserid.length,
                                            itemBuilder: (context, index) =>
                                                Column(
                                                  children: [
                                                    Divider(),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    Container(
                                                      height: height * 0.05,
                                                      width: double.infinity,
                                                      child: Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          SizedBox(
                                                            width: 10,
                                                          ),
                                                          Text(upusername[
                                                              index]),
                                                        ],
                                                      ),
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5),
                                                          color: Colors.grey
                                                              .withOpacity(.05),
                                                          border: Border.all(
                                                              width: 2,
                                                              color: Colors
                                                                  .grey[300])),
                                                    ),
                                                    SizedBox(height: 10),
                                                    viewerTextField(
                                                        height, 'First Name'),
                                                    viewerTextField(
                                                        height, 'Last Name'),
                                                    // SizedBox(
                                                    //   height: 10,
                                                    // ),
                                                    Divider()
                                                  ],
                                                )),
                                      ),
                                      SizedBox(height: 10),
                                      Container(
                                        child: ListView.builder(
                                          itemCount: count,
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          itemBuilder: (context, index) {
                                            List.generate(count, (index) {
                                              users.add('');
                                            });
                                            // users.add('');

                                            return Column(
                                              children: [
                                                viewerTextField(height, 'Email',
                                                    controller: emailC,
                                                    onChanged: (val) async {
                                                  users[index] = val;
                                                  // email = val;
                                                  var data = await ViewService()
                                                      .searchUser(users[index]);
                                                  // print(data);
                                                  if (data['success'] == true) {
                                                    setState(() {
                                                      downUsers = data['data'];
                                                    });
                                                  } else {
                                                    setState(() {
                                                      downUsers = [];
                                                    });
                                                  }
                                                }),
                                                viewerTextField(
                                                    height, 'First Name',
                                                    controller: fnameC),
                                                viewerTextField(
                                                    height, 'Last Name',
                                                    controller: lnameC),
                                                SizedBox(height: 10),
                                                Divider(
                                                  color: Color(0xff707070)
                                                      .withOpacity(0.4),
                                                  height: 10.0,
                                                ),
                                              ],
                                            );
                                          },
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      Container(
                                        height: downUsers.length < 4
                                            ? downUsers.length * 70.0
                                            : 200,
                                        child: ListView.builder(
                                          // shrinkWrap: true,
                                          // physics:
                                          //     NeverScrollableScrollPhysics(),
                                          itemCount: downUsers.length,
                                          itemBuilder: (context, index) =>
                                              ListTile(
                                            onTap: () {
                                              setState(() {
                                                if (upuserid.contains(
                                                    downUsers[index]['id'])) {
                                                } else {
                                                  if (downUsers[index]
                                                          ['status'] ==
                                                      '0') {
                                                    showConfirmDialog(context,
                                                        text:
                                                            "You already send an invitation to the user please wait till user accept");
                                                  } else if (downUsers[index]
                                                          ['status'] ==
                                                      '1') {
                                                    showConfirmDialog(context,
                                                        text:
                                                            "You already have an connection with the user ");
                                                  } else if (downUsers[index]
                                                          ['status'] ==
                                                      '2') {
                                                    showConfirmDialog(context,
                                                        text:
                                                            "Your invitation is rejected by the user ");
                                                  } else {
                                                    emailC.text =
                                                        downUsers[index]
                                                            ['email'];
                                                    intername.add(
                                                        downUsers[index]
                                                            ['email']);
                                                    interid.add(
                                                        downUsers[index]['id']);
                                                  }
                                                }
                                              });
                                            },
                                            leading: CircleAvatar(
                                              backgroundColor: upuserid
                                                      .contains(downUsers[index]
                                                          ['id'])
                                                  ? Colors.grey
                                                  : Color(0xff14F47B),
                                              child: Text(
                                                downUsers[index]['email']
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
                                            title: Text(
                                                '${downUsers[index]['email']}'),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 20),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          ElevatedButton(
                                         
                                            onPressed: () async {
                                              emailC.clear();

                                              setState(() {
                                                downUsers = [];
                                                if (upuserid
                                                    .contains(interid.last)) {
                                                } else {
                                                  upuserid.add(interid.last);
                                                  upusername
                                                      .add(intername.last);
                                                }
                                              });
                                            },
                                            child: Container(
                                              height: height * 0.04,
                                              width: width * 0.3,
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(

                                                  // boxShadow: [
                                                  //   BoxShadow(
                                                  //     blurRadius: 2,
                                                  //     color: Colors.black,
                                                  //   ),
                                                  // ],
                                                  ),
                                              child: Text(
                                                'Add Viewers',
                                                style: GoogleFonts.montserrat(
                                                  fontSize: 10.0,
                                                  fontWeight: FontWeight.w500,
                                                  color: Color(0xff5AA5EF),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 15,
                                          ),
                                          ElevatedButton(
                                    
                                            onPressed: () async {
                                              // var ids = [];
                                              setState(() {
                                                loading = true;
                                              });

                                              if (upuserid.length == 1) {
                                                // print('working if part');
                                                var d = await ViewService()
                                                    .sendViewRequest(
                                                        upuserid[0]);

                                                setState(() {
                                                  loading = false;
                                                });
                                                upuserid.clear();
                                                upusername.clear();
                                                downUsers.clear();
                                                setState(() {
                                                  addViewer = !addViewer;
                                                });
                                                showConfirmDialog(context,
                                                    text: d['message']);
                                              } else {
                                                for (var item = 0;
                                                    item < upuserid.length;
                                                    item++) {
                                                  var d = await ViewService()
                                                      .sendViewRequest(item);

                                                  if (d['success'] == true) {
                                                    success
                                                        .add(upusername[item]);
                                                  }
                                                }
                                                setState(() {
                                                  loading = false;
                                                });
                                                String msg = '';
                                                for (var item in success) {
                                                  msg += '\n' + item;
                                                }
                                                if (success.length == 0) {
                                                  showConfirmDialog(context,
                                                      text: 'No viewers added');
                                                } else {
                                                  upuserid.clear();
                                                  upusername.clear();
                                                  downUsers.clear();
                                                  setState(() {
                                                    addViewer = !addViewer;
                                                  });
                                                  showConfirmDialog(context,
                                                      text: 'Viewers added');
                                                }
                                              }
                                            },
                                            child: Container(
                                              height: height * 0.04,
                                              width: width * 0.3,
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(

                                                  // boxShadow: [
                                                  //   BoxShadow(
                                                  //     blurRadius: 2,
                                                  //     color: Colors.black,
                                                  //   ),
                                                  // ],
                                                  ),
                                              child: Text(
                                                'Done',
                                                style: GoogleFonts.montserrat(
                                                  fontSize: 10.0,
                                                  fontWeight: FontWeight.w500,
                                                  color: Color(0xff5AA5EF),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                              : acceptUser(height, width, setState, loading),
                        ),
                        addViewer
                            ? Container()
                            : Container(
                                height: height * 0.5,
                                padding: EdgeInsets.only(
                                  left: 30.0,
                                  top: 15.0,
                                  right: 15.0,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          'Groups',
                                          style: GoogleFonts.poppins(
                                            fontSize: 13.0,
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xff141720),
                                          ),
                                        ),
                                        SizedBox(width: 5),
                                        InkWell(
                                          onTap: () async {
                                            await editDialog(
                                              context,
                                              height,
                                              width,
                                              true,
                                            ).then((data) {
                                              // print(data);
                                              if (data == 'Added') {
                                                showConfirmDialog(
                                                  context,
                                                  text:
                                                      'Group member added successfully',
                                                );
                                              }
                                            });
                                            setState(() {});
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
                                    SizedBox(height: 14.0),
                                    Text(
                                      'Add Multiple users to this group. All users in this group\nWill have access to your uploaded content.',
                                      style: GoogleFonts.montserrat(
                                        fontSize: 10.0,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xff1A1D2A),
                                      ),
                                    ),
                                    // Divider(
                                    //   height: 10.0,
                                    //   color: Color(0xffB9B8B8),
                                    // ),
                                    SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Group Name',
                                          style: GoogleFonts.poppins(
                                            fontSize: 13.0,
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xff5AA5EF),
                                          ),
                                        ),
                                        Text(
                                          'Viewers',
                                          style: GoogleFonts.poppins(
                                            fontSize: 13.0,
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xff5AA5EF),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Divider(
                                      height: 10.0,
                                      color: Color(0xffB9B8B8),
                                    ),
                                    Container(
                                      height: height * 0.1,
                                      child: FutureBuilder(
                                        future: GroupService().getMyGroups(),
                                        builder: (context, snapshot) {
                                          if (snapshot.hasData) {
                                            return ListView.builder(
                                              itemCount: snapshot.data.length,
                                              shrinkWrap: true,
                                              itemBuilder: (context, index) {
                                                var title = snapshot.data[index]
                                                    ['title'];
                                                var members =
                                                    snapshot.data[index]
                                                        ['members_count'];
                                                return Column(
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          title,
                                                          style: GoogleFonts
                                                              .montserrat(
                                                            fontSize: 11.0,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color: Color(
                                                                0xff5AA5EF),
                                                          ),
                                                        ),
                                                        Row(
                                                          children: [
                                                            InkWell(
                                                              onTap: () async {
                                                                await editDialog(
                                                                  context,
                                                                  height,
                                                                  width,
                                                                  false,
                                                                  grpimage: snapshot
                                                                              .data[
                                                                          index]
                                                                      ['image'],
                                                                  groupId: snapshot
                                                                          .data[
                                                                      index]['id'],
                                                                  title: title,
                                                                );
                                                                setState(() {});
                                                              },
                                                              child: Icon(
                                                                Icons.edit,
                                                                size: 18,
                                                              ),
                                                            ),
                                                            SizedBox(width: 20),
                                                            InkWell(
                                                              onTap: () async {
                                                                setState(() {
                                                                  loading =
                                                                      true;
                                                                });
                                                                var res = await VideoService()
                                                                    .deleteGroup(
                                                                        groupId:
                                                                            snapshot.data[index]['id']);
                                                                // print(res);
                                                                setState(() {
                                                                  loading =
                                                                      false;
                                                                });
                                                              },
                                                              child: Icon(
                                                                Icons.delete,
                                                                size: 18,
                                                              ),
                                                            ),
                                                            SizedBox(width: 20),
                                                            Text(
                                                              '$members',
                                                              style: GoogleFonts
                                                                  .montserrat(
                                                                fontSize: 11.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                color: Color(
                                                                    0xff5AA5EF),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                    Divider(
                                                      height: 10.0,
                                                      color: Color(0xffB9B8B8),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          } else {
                                            return Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  'No new groups',
                                                  style: GoogleFonts.montserrat(
                                                    fontSize: 11.0,
                                                    fontWeight: FontWeight.w500,
                                                    color: Color(0xff5AA5EF),
                                                  ),
                                                ),
                                                Text(
                                                  '0',
                                                  style: GoogleFonts.montserrat(
                                                    fontSize: 11.0,
                                                    fontWeight: FontWeight.w500,
                                                    color: Color(0xff5AA5EF),
                                                  ),
                                                ),
                                              ],
                                            );
                                          }
                                        },
                                      ),
                                    ),
                                    // Divider(
                                    //   height: 10.0,
                                    //   color: Color(0xffB9B8B8),
                                    // ),
                                    SizedBox(height: 10),
                                    Row(
                                      children: [
                                        Text(
                                          'Individual Viewers',
                                          style: GoogleFonts.poppins(
                                            fontSize: 13.0,
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xff141720),
                                          ),
                                        ),
                                        SizedBox(width: 5),
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
                                    SizedBox(height: 15.0),
                                    Text(
                                      'Add Individual viewers to view your content.',
                                      style: GoogleFonts.montserrat(
                                        fontSize: 10.0,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xff1A1D2A),
                                      ),
                                    ),
                                    SizedBox(height: 15.0),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          width: width * 0.5,
                                          child: Text(
                                            'No new Individual viewers have been added',
                                            style: GoogleFonts.montserrat(
                                              fontSize: 10.0,
                                              fontWeight: FontWeight.w500,
                                              color: Color(0xff5AA5EF),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          height: height * 0.04,
                                          width: width * 0.3,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5.0),
                                          ),
                                          child: ElevatedButton(
                                      
                                            onPressed: () {
                                              setState(() {
                                                addViewer = true;
                                              });
                                            },
                                            child: Center(
                                              child: Text(
                                                'Add Viewer',
                                                style: GoogleFonts.montserrat(
                                                  fontSize: 11.0,
                                                  fontWeight: FontWeight.w600,
                                                  color: Color(0xff020410),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    // SizedBox(height: 50),
                                  ],
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
      ),
    );
  }
}

acceptUser(height, width, setState, loading) {
  return Container(
    color: Colors.white,
    // height: height * 0.25,
    width: width,
    margin: EdgeInsets.only(
      left: 20,
      top: 20.0,
      right: 20.0,
      bottom: 25.0,
    ),
    padding: EdgeInsets.only(
      top: 20.0,
      right: 20.0,
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Accept User',
                  style: GoogleFonts.poppins(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff141720),
                  ),
                ),
                Text(
                  'All user requests will appear below, so you can decide\nto accept or decline',
                  style: GoogleFonts.montserrat(
                    fontSize: 10.0,
                    fontWeight: FontWeight.w500,
                    color: Color(0xff1A1D2A),
                  ),
                  textAlign: TextAlign.end,
                ),
              ],
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.only(left: 15.0),
          child: Divider(
            height: 15.0,
            color: Color(0xffB9B8B8),
          ),
        ),
        Container(
          // height: height * 0.13,
          child: FutureBuilder(
            future: ViewService().getAllViewRequests(0),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var requests = [];
                List<Widget> wids = [];
                // print(snapshot.data.toString());
                snapshot.data.forEach((d) {
                  if (d['status'] == '0') {
                    requests.add(d);
                  }
                });

                for (var index = 0; index < requests.length; index++) {
                  var userId = requests[index]['id'];
                  String firstName = requests[index]['firstname'];

                  // var lastname = snapshot.data[index]['lastname'];
                  var email = snapshot.data[index]['email'];
                  wids.add(Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                            left: 15.0,
                            bottom: 5.0,
                          ),
                          child: Text(
                            '${firstName == '' ? email.toString() : firstName} wants to view your content',
                            style: GoogleFonts.montserrat(
                              fontSize: 12.0,
                              fontWeight: FontWeight.w700,
                              color: Color(0xff141720),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            left: 15.0,
                            // right: 16.0,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  height: height * 0.04,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Color(0xff5AA5EF),
                                    ),
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  child: ElevatedButton(
                             
                                    onPressed: () async {
                                      setState(() {
                                        loading = true;
                                      });
                                      var data = await ViewService()
                                          .updateRequestStatus(1, userId);
                                      if (data['success'] == true) {
                                        await showConfirmDialog(
                                          context,
                                          text: 'Request Accepted',
                                        );
                                        setState(() {});
                                      }
                                      setState(() {
                                        loading = false;
                                      });
                                    },
                                    child: Center(
                                      child: Text(
                                        'Accept',
                                        style: GoogleFonts.montserrat(
                                          fontSize: 11.0,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xff020410),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 15),
                              Expanded(
                                child: Container(
                                  height: height * 0.04,
                                  width: width * 0.36,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Color(0xff5AA5EF),
                                    ),
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  child: ElevatedButton(
                       
                                    onPressed: () async {
                                      var data = await ViewService()
                                          .updateRequestStatus(2, userId);
                                      if (data['success'] == true) {
                                        await showConfirmDialog(
                                          context,
                                          text: 'Request Rejected',
                                        );
                                        setState(() {});
                                      }
                                    },
                                    child: Center(
                                      child: Text(
                                        'Decline',
                                        style: GoogleFonts.montserrat(
                                          fontSize: 11.0,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xff020410),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ));
                }

                return requests.length == 0
                    ? Container(
                        height: 60,
                        child: Center(
                          child: Text(
                            'No New Requests',
                            style: GoogleFonts.montserrat(
                              fontSize: 17.0,
                              fontWeight: FontWeight.w700,
                              color: Color(0xff141720),
                            ),
                          ),
                        ),
                      )
                    : Column(
                        children: wids,
                      );
                // : Container(
                //     child: ListView.builder(
                //       itemCount: requests.length,
                //       shrinkWrap: true,
                //       itemBuilder: (context, index) {
                //         var userId = requests[index]['id'];
                //         String firstName = requests[index]['firstname'];

                //         // var lastname = snapshot.data[index]['lastname'];
                //         var email = snapshot.data[index]['email'];
                //         return Column(
                //           children: [
                //             Padding(
                //               padding: EdgeInsets.only(
                //                 left: 15.0,
                //                 bottom: 4.0,
                //               ),
                //               child: Text(
                //                 '  ${firstName == '' ? email.toString() : firstName} wants to view your content',
                //                 style: GoogleFonts.montserrat(
                //                   fontSize: 12.0,
                //                   fontWeight: FontWeight.w700,
                //                   color: Color(0xff141720),
                //                 ),
                //               ),
                //             ),
                //             Padding(
                //               padding: EdgeInsets.only(
                //                 left: 15.0,
                //                 // right: 16.0,
                //               ),
                //               child: Row(
                //                 children: [
                //                   Expanded(
                //                     child: InkWell(
                //                       onTap: () async {
                //                         setState(() {
                //                           loading = true;
                //                         });
                //                         var data = await ViewService()
                //                             .updateRequestStatus(1, userId);
                //                         if (data['success'] == 'true') {
                //                           await showConfirmDialog(
                //                             context,
                //                             text: 'Request Accepted',
                //                           );
                //                           setState(() {});
                //                         }
                //                         setState(() {
                //                           loading = false;
                //                         });
                //                       },
                //                       child: Container(
                //                         height: height * 0.04,
                //                         // width: width * 0.36,
                //                         decoration: BoxDecoration(
                //                           border: Border.all(
                //                             color: Color(0xff5AA5EF),
                //                           ),
                //                           borderRadius:
                //                               BorderRadius.circular(5.0),
                //                         ),
                //                         child: Center(
                //                           child: Text(
                //                             'Accept',
                //                             style: GoogleFonts.montserrat(
                //                               fontSize: 11.0,
                //                               fontWeight: FontWeight.w600,
                //                               color: Color(0xff020410),
                //                             ),
                //                           ),
                //                         ),
                //                       ),
                //                     ),
                //                   ),
                //                   SizedBox(width: 15),
                //                   Expanded(
                //                     child: InkWell(
                //                       onTap: () async {
                //                         var data = await ViewService()
                //                             .updateRequestStatus(2, userId);
                //                         if (data['success'] == 'true') {
                //                           await showConfirmDialog(
                //                             context,
                //                             text: 'Request Rejected',
                //                           );
                //                           setState(() {});
                //                         }
                //                       },
                //                       child: Container(
                //                         height: height * 0.04,
                //                         width: width * 0.36,
                //                         decoration: BoxDecoration(
                //                           border: Border.all(
                //                             color: Color(0xff5AA5EF),
                //                           ),
                //                           borderRadius:
                //                               BorderRadius.circular(5.0),
                //                         ),
                //                         child: Center(
                //                           child: Text(
                //                             'Decline',
                //                             style: GoogleFonts.montserrat(
                //                               fontSize: 11.0,
                //                               fontWeight: FontWeight.w600,
                //                               color: Color(0xff020410),
                //                             ),
                //                           ),
                //                         ),
                //                       ),
                //                     ),
                //                   ),
                //                 ],
                //               ),
                //             ),
                //           ],
                //         );
                //       },
                //     ),
                //   );
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        )
      ],
    ),
  );
}

viewerTextField(height, text, {onChanged, TextEditingController controller}) {
  return Column(
    children: [
      Container(
        height: height * 0.05,
        child: TextField(
          controller: controller,
          onChanged: onChanged,
          decoration: InputDecoration(
            filled: true,
            fillColor: Color(0xffFAFAFA),
            hintText: '$text',
            hintStyle: GoogleFonts.montserrat(
              fontSize: 10.0,
              fontWeight: FontWeight.w500,
              color: Color(0xff5AA5EF),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.0),
              borderSide: BorderSide(
                color: Color(0xffE3E3E3),
                width: 2.0,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.0),
              borderSide: BorderSide(
                color: Color(0xffE3E3E3),
                width: 2.0,
              ),
            ),
          ),
        ),
      ),
      SizedBox(height: 10),
    ],
  );
}
