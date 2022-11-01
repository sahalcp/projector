import 'dart:async';
import 'dart:io';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:projector/apis/contentDashboardService.dart';
import 'package:projector/apis/groupService.dart';
import 'package:projector/apis/videoService.dart';
import 'package:projector/apis/viewService.dart';
import 'package:projector/models/group/groupListVideoAlbumModel.dart';
import 'package:projector/models/group/groupVideoModel.dart';

class GroupListPage extends StatefulWidget {
  const GroupListPage({Key key}) : super(key: key);

  @override
  State<GroupListPage> createState() => _GroupListPageState();
}

class _GroupListPageState extends State<GroupListPage> {
  bool centerProgressIndicator = false;
  bool spin = false;
  bool removeUserProgress = false;
  bool deleteGroup = false;
  List<bool> selectedVideos = [];
  List<bool> selectedAlbums = [];
  List<GroupVideoModel> selectedVideoData = [];
  List<String> selectedPhotoData = [];
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  StreamController streamGroupList = StreamController.broadcast();
  StreamController streamVideoAlbumList = StreamController.broadcast();
  bool isChecked = false;
  List<Video> videoListResponse;
  List<Album> albumListResponse;
  var groupListData = [];
  var videoAlbumListData = [];
  @override
  void initState(){
    GroupServcie().getMyGroups().then((val) {
      streamGroupList.add(val);

      setState(() {
        groupListData = val;
        List.generate(groupListData.length, (index) {

          var groupId = groupListData[index]['id'];

          print("grpoddd11--${groupListData[index]['id']}");

        });
      });


    });


   /* ContentDashboardService().getVideoAndAlbumOfUser(
        groupId: "24"
    ).then((val) {
      streamVideoAlbumList.add(val);

      setState(() {
        //videoAlbumListData = val;

        GroupListVideoAlbumModel response = val;
        videoListResponse = response.videoListResponse;
        albumListResponse = response.albumListResponse;

        videoAlbumListData.add(response);



        List.generate(videoAlbumListData.length, (index) {

          //  var groupId = videoAlbumListData[index]['id'];
          var data = videoListResponse[index].title;
          print("grpoddd33--$data");


        });
      });

    });*/




    super.initState();
  }
  _onExpansion(bool expanding){
    setState(() {
      if (expanding){
        deleteGroup = true;
      }else{
     deleteGroup = false;
      }
    });
  }

  _checkGroupId({String groupId, String videoId}) {
    //print("selecteddatacheck grp1-->$groupId");
    var myListFiltered = selectedVideoData.firstWhere((e) =>

    e.groupId == groupId,orElse: (){
     return null;
    });

    //print("selected data check checkedval-->$myListFiltered");
    if(myListFiltered !=null && myListFiltered.videoId == videoId){
      return true;
    }

    return false;

  }


  void _onSelected({bool selected, String videoId, String groupId}) {
    var groupVideo = GroupVideoModel();
    groupVideo.videoId = videoId;
    groupVideo.groupId = groupId;
    if (selected == true) {
      selectedVideoData.add(groupVideo);
     // print("selected data check add-->$selectedVideoData");
    } else {
      selectedVideoData.remove(groupVideo);
      print("selected data check remove-->$selectedVideoData");
    }
     //print("selected data check all-->$selectedVideoData");
     print("selecteddatacheck grp-->$groupId");
     print("selecteddatacheck vdo-->$videoId");
  }

  void _onSelectedPhoto({bool selected, String videoId, String groupId}) {
    if (selected == true) {
      setState(() {
        selectedPhotoData.add(videoId);
      });
    } else {
      setState(() {
        selectedPhotoData.remove(videoId);
      });
    }
    // print("selecteddatacheck-->$selectedVideoData");
    // print("selecteddatacheck grp-->$groupId");
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
            "Groups",
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
                requestDialog(scaffoldKey: _scaffoldKey,
                    context: context,height: height,
                    width: width,type: "AddGroup",spin: spin,streamGroupList: streamGroupList);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "New group ",
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
      body:  Container(
        margin: EdgeInsets.only(left: 16.0, right: 16.0, top: 25.0),
        child: Stack(
          children: [
            ListView(
              children: [
                StreamBuilder(
                  stream: streamGroupList.stream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                          itemCount: snapshot.data.length,
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {

                            var groupId = snapshot.data[index]['id'];
                            return Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                        borderRadius: BorderRadius.circular(7),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          spreadRadius: 2,
                                          blurRadius: 3,
                                          offset: Offset(1, 0),
                                        )
                                      ]
                                    ),
                                    child: ExpansionTile(
                                      title: Row(
                                        children: [
                                          Text(snapshot.data[index]['title'],
                                            style: new TextStyle(fontWeight: FontWeight.bold, color: Colors.black),),
                                          Spacer(),
                                          new Visibility(child: InkWell(
                                            onTap: () async{


                                              removeDialog(context: context,height: height,width: width,
                                                  groupName:snapshot.data[index]['title'],
                                                  groupId: snapshot.data[index]['id'],streamGroupList: streamGroupList);

                                            },
                                            child: Text(
                                              "Delete Group",
                                              style: GoogleFonts.montserrat(
                                                fontSize: 9.0,
                                                fontWeight: FontWeight.w600,
                                                color: Color(0xffFF0000),
                                              ),
                                            ),
                                          ),visible: true,),
                                        ],
                                      ),
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(left: 6,right: 6),
                                          child: InkWell(
                                            onTap: (){
                                              requestDialog(scaffoldKey: _scaffoldKey, context: context,
                                                  height: height,width: width,type: "AddMemberGroup",
                                                  spin: spin,groupId: snapshot.data[index]['id']
                                                  ,streamGroupList: streamGroupList);
                                            },
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                SizedBox(height: 5,),
                                                Text(
                                                  "Add group member ",
                                                  style: GoogleFonts.montserrat(
                                                    fontSize: 12.0,
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
                                            ),
                                          ),
                                        ),
                                        ListView.builder(
                                          shrinkWrap: true,
                                          physics: NeverScrollableScrollPhysics(),
                                          itemBuilder: (BuildContext context, int index1) {
                                            var userEmail = snapshot.data[index]
                                            ['members'][index1]['email'];
                                            var  firstName = snapshot.data[index]
                                            ['members'][index1]['firstname'];
                                            var  lastName = snapshot.data[index]
                                            ['members'][index1]['lastname'];
                                            var  userId = snapshot.data[index]
                                            ['members'][index1]['id'];
                                            return Container(
                                              margin: EdgeInsets.only(left: 16.0, right: 16.0, top: 25.0),
                                              child: new  Row(
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
                                                          const EdgeInsets.all(5.0),
                                                        ),
                                                        onTap: () async {

                                                          var response =
                                                          await ContentDashboardService()
                                                              .deleteMemberFromGroup(groupId: snapshot.data[index]['id'],
                                                              users: userId);
                                                          if (response["success"]) {
                                                            GroupServcie().getMyGroups().then((val) {
                                                              streamGroupList.add(val);
                                                            });
                                                          }

                                                        },
                                                      )
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                          itemCount: snapshot.data[index]['members'].length,
                                        ),

                                        FutureBuilder(
                                            future: ContentDashboardService().getVideoAndAlbumOfUser(
                                                groupId: snapshot.data[index]['id']),
                                            builder: (context,snapshot){
                                              if(snapshot.hasData){

                                                // var videoListData = [];
                                                // var albumListData = [];
                                                //
                                                // var videosList = snapshot.data['video'];
                                                // videoListData = videosList;
                                                //
                                                // var albumList = snapshot.data['album'];
                                                // albumListData = albumList;



                                                GroupListVideoAlbumModel response = snapshot.data;
                                                videoListResponse = response.videoListResponse;
                                                albumListResponse = response.albumListResponse;

                                               // print("itemleng--->${videoListResponse.length}");

                                                return  Column(
                                                  children: [
                                                    Column(
                                                      children: [
                                                        SizedBox(height: 20,),
                                                        Align(
                                                          child:   Text(
                                                            'Videos',
                                                            style: GoogleFonts.poppins(
                                                              fontSize: 14.0,
                                                              color:  Colors.black,
                                                              fontWeight: FontWeight.w600,
                                                            ),
                                                          ),
                                                          alignment: Alignment.topLeft,),
                                                        Container(
                                                          child:  ListView.builder(
                                                              shrinkWrap: true,
                                                              physics: NeverScrollableScrollPhysics(),
                                                              scrollDirection: Axis.vertical,
                                                              itemCount: videoListResponse.length,
                                                              itemBuilder: (context, index1) {

                                                                final item = videoListResponse[index1];

                                                                var videoTitle = item.title;
                                                                var videoId = item.id;


                                                                // var videoTitle = videoListData[index1]['title'];

                                                                // var selectedCheckValue = videoListData[index1]['selected'];

                                                                // if(selectedCheckValue == 1){
                                                                //   isChecked = true;
                                                                // }else{
                                                                //   isChecked = false;
                                                                // }

                                                                //selectedVideoData.contains(videoListData[index1]['id']
                                                                // if(item.selected == 1){
                                                                //   isChecked = true;
                                                                // }else{
                                                                //   isChecked = false;
                                                                // }

                                                                print("checkedvaitem--${item.isChecked},${item.title},${item.groupId}");


                                                                //_checkGroupId(groupId: groupId,videoId: videoId)
                                                                return Container(
                                                                  child: Row(
                                                                    children: [
                                                                      Checkbox(value: item.isChecked,
                                                                          onChanged: (val){
                                                                            print("checkedvall--${item.title},$val");
                                                                            // if(val == true){
                                                                            //   item.selected = 0;
                                                                            // }else{
                                                                            //   item.selected = 1;
                                                                            // }



                                                                            setState(() {

                                                                              print("checkedvall--,$val");
                                                                              // item. isChecked = val;

                                                                              videoListResponse[index1].isChecked = val;

                                                                            });
                                                                            /*_onSelected(selected: val,
                         videoId: videoId,
                         groupId: groupId);*/
                                                                          }),
                                                                      SizedBox(width: 5),
                                                                      Text(
                                                                        '$videoTitle',
                                                                        style: GoogleFonts.poppins(
                                                                          fontSize: 13.0,
                                                                          color:  Colors.black,
                                                                          fontWeight: FontWeight.w600,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                );
                                                              }),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(height: 20,),
                                                    Column(
                                                      children: [
                                                        Align(
                                                          child:   Text(
                                                            'Photo Albums',
                                                            style: GoogleFonts.poppins(
                                                              fontSize: 14.0,
                                                              color:  Colors.black,
                                                              fontWeight: FontWeight.w600,
                                                            ),
                                                          ),
                                                          alignment: Alignment.topLeft,),
                                                        Container(
                                                          child:  ListView.builder(
                                                              shrinkWrap: true,
                                                              physics: NeverScrollableScrollPhysics(),
                                                              scrollDirection: Axis.vertical,
                                                              itemCount: albumListResponse.length,
                                                              itemBuilder: (context, index1) {
                                                                final item = albumListResponse[index1];

                                                                var albumTitle = item.title;
                                                                var id = item.id;
                                                                // var albumTitle = albumListData[index1]['title'];
                                                                return Container(
                                                                  child: Row(
                                                                    children: [
                                                                      Checkbox(value: selectedPhotoData.contains(id),
                                                                          onChanged: (val){
                                                                            // _onSelectedPhoto(selected: val,
                                                                            //     videoId: albumListData[index1]['id'],
                                                                            //     groupId: groupId);
                                                                          }),
                                                                      SizedBox(width: 5),
                                                                      Text(
                                                                        albumTitle,
                                                                        style: GoogleFonts.poppins(
                                                                          fontSize: 13.0,
                                                                          color:  Colors.black,
                                                                          fontWeight: FontWeight.w600,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                );
                                                              }),
                                                        ),
                                                      ],
                                                    ),

                                                    Align(
                                                      alignment: Alignment.bottomCenter,
                                                      child: SizedBox(
                                                        child: InkWell(
                                                            onTap : () {

                                                            },
                                                            child: Container(
                                                              padding: EdgeInsets.only(left: 16.0,right: 16.0,top: 7.0,bottom: 7.0),
                                                              decoration: BoxDecoration(
                                                                border: Border.all(
                                                                  color: Colors.blue,
                                                                  width: 1.5,
                                                                ),
                                                                borderRadius: BorderRadius.circular(5.0),
                                                              ),
                                                              child: Text(
                                                                'Save',
                                                                style: GoogleFonts.montserrat(
                                                                  color: Colors.black,
                                                                  fontSize: 14.0,
                                                                  fontWeight: FontWeight.w600,
                                                                ),
                                                              ),
                                                            )
                                                          // borderSide: BorderSide(
                                                          //   color: Color(0xff6D6F76),
                                                          //   width: 2.0,
                                                          // ),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(height: 20,),

                                                  ],
                                                );
                                              }else{
                                                return Container();
                                              }
                                            }),




                                      ],
                                      iconColor: Colors.black,
                                      textColor: Colors.black,
                                      collapsedTextColor: Colors.black,
                                     // onExpansionChanged: _onExpansion,
                                    ),
                                  ),
                                 // ExpandableListView(snapshot: snapshot,index: index,streamGroupList: streamGroupList,)
                                ],
                              ),
                              margin: EdgeInsets.only(bottom: 15),
                            );
                          });
                    } else {
                      return Container(
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
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
}


class ExpandableListView extends StatefulWidget {
  final AsyncSnapshot snapshot;
  final int index;
  final StreamController streamGroupList;

  const ExpandableListView({Key key, this.snapshot,this.index,this.streamGroupList}) : super(key: key);

  @override
  _ExpandableListViewState createState() => new _ExpandableListViewState();
}

class _ExpandableListViewState extends State<ExpandableListView> {
  bool expandFlag = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool spin = false;
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return new Container(
      margin: new EdgeInsets.symmetric(vertical: 1.0),
      child: new Column(
        children: <Widget>[
          new Container(
            padding: new EdgeInsets.symmetric(horizontal: 5.0),
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                new Text(
                  widget.snapshot.data[widget.index]['title'],
                  style: new TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                ),

                new IconButton(
                    icon: new Container(
                      height: 50.0,
                      width: 50.0,
                      child: new Center(
                        child: new Icon(
                          expandFlag ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                          color: Colors.black,
                          size: 30.0,
                        ),
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        expandFlag = !expandFlag;
                      });
                    }),
                Spacer(),
                new Visibility(child: InkWell(
                  onTap: () async{


               removeDialog(context: context,height: height,width: width,
                   groupName:widget.snapshot.data[widget.index]['title'],
               groupId: widget.snapshot.data[widget.index]['id'],streamGroupList: widget.streamGroupList);

                  },
                  child: Text(
                    "Delete Group",
                    style: GoogleFonts.montserrat(
                      fontSize: 9.0,
                      fontWeight: FontWeight.w600,
                      color: Color(0xffFF0000),
                    ),
                  ),
                ),visible: expandFlag ? true : false,),
              ],
            ),
          ),
          new Column(
            children: [
              Visibility(
                child: Container(
                  margin: EdgeInsets.only(left: 6,right: 6),
                  child: InkWell(
                    onTap: (){
                      requestDialog(scaffoldKey: _scaffoldKey, context: context,
                          height: height,width: width,type: "AddMemberGroup",
                          spin: spin,groupId: widget.snapshot.data[widget.index]['id']
                          ,streamGroupList: widget.streamGroupList);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 5,),
                        Text(
                          "Add group member ",
                          style: GoogleFonts.montserrat(
                            fontSize: 12.0,
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
                    ),
                  ),
                ),
                visible: expandFlag ? true : false,),
              ExpandableContainer(
                  expanded: expandFlag,
                  child: ListView.builder(
                    itemBuilder: (BuildContext context, int index) {
                      var userEmail = widget.snapshot.data[widget.index]
                      ['members'][index]['email'];
                      var  firstName = widget.snapshot.data[widget.index]
                      ['members'][index]['firstname'];
                      var  lastName = widget.snapshot.data[widget.index]
                      ['members'][index]['lastname'];
                      var  userId = widget.snapshot.data[widget.index]
                      ['members'][index]['id'];
                      return Container(
                        margin: EdgeInsets.only(left: 16.0, right: 16.0, top: 25.0),
                        child: new  Row(
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
                                    const EdgeInsets.all(5.0),
                                  ),
                                  onTap: () async {

                                    var response =
                                    await ContentDashboardService()
                                        .deleteMemberFromGroup(groupId: widget.snapshot.data[widget.index]['id'],
                                        users: userId);
                                    if (response["success"]) {
                                      GroupServcie().getMyGroups().then((val) {
                                        widget.streamGroupList.add(val);
                                      });
                                    }

                                  },
                                )
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                    itemCount: widget.snapshot.data[widget.index]['members'].length,
                  ),)
            ],
          )
        ],
      ),
    );
  }
}


class ExpandableContainer extends StatelessWidget {
  final bool expanded;
  final double collapsedHeight;
  final int expandedHeight;
  final Widget child;

  ExpandableContainer({
    @required this.child,
    this.collapsedHeight = 0,
    this.expandedHeight = 300,
    this.expanded = true,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return new AnimatedContainer(
      duration: new Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      width: screenWidth,
      height: expanded ? expandedHeight.toDouble() : collapsedHeight,
      child: new Container(
        child: child,
      ),
    );
  }
}

requestDialog({scaffoldKey,context, height, width,type,spin,groupId,streamGroupList}) {
  FocusNode node = FocusNode();
  TextEditingController reqDataCon = TextEditingController();
  TextEditingController controller = TextEditingController(text: "");
  String email = '',groupName = '';
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
                                      type == "AddMemberGroup" ?
                                      Text(
                                        "Add group member",
                                        style: GoogleFonts.poppins(
                                          fontSize: 16.0,
                                          // fontWeight: FontWeight.w700,
                                        ),) :
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
                                              hintText: 'Enter Group Name',
                                              hintStyle: GoogleFonts.poppins(
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.w500,
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
                            child: RaisedButton(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(7),
                              ),
                              color: Color(0xff5AA5EF),
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

                                  if(type == "AddGroup"){
                                    var data =
                                    await GroupServcie().addNewGroup(
                                      controller.text,
                                      image,
                                    );
                                    var groupId = data['id'];
                                    if (data['success'] == true) {
                                      for (var item in selectedUsers) {
                                        var data = await GroupServcie()
                                            .addMembersToGroup(
                                          groupId,
                                          item,
                                        );

                                        reqDataCon.text = '';
                                        Navigator.pop(context, data);

                                        GroupServcie().getMyGroups().then((val) {
                                          streamGroupList.add(val);
                                        });

                                      }

                                      setState(() {
                                        spin = false;
                                      });
                                    }

                                  }else if(type == "AddMemberGroup"){
                                    for (var item in selectedUsers) {
                                      var data = await GroupServcie()
                                          .addMembersToGroup(
                                        groupId,
                                        item,
                                      );

                                      reqDataCon.text = '';
                                      Navigator.pop(context, data);

                                      GroupServcie().getMyGroups().then((val) {
                                        streamGroupList.add(val);
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

removeDialog({context, height, width, String groupName, String groupId,streamGroupList}) {
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
                                          child: RaisedButton(
                                            elevation: 5.0,
                                            color: Colors.white,
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

                                              var response = await VideoService()
                                                  .deleteGroup(
                                                  groupId:
                                                  groupId);
                                              if (response["success"]) {
                                                GroupServcie().getMyGroups().then((val) {
                                                  streamGroupList.add(val);
                                                });

                                                Navigator.pop(context);
                                              }


                                            },
                                          ),
                                        ),
                                        SizedBox(
                                          width: 20,
                                        ),
                                        RaisedButton(
                                          elevation: 5.0,
                                          color: Color(0xffDEDEDE),
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
