import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projector/apis/contentDashboardService.dart';
import 'package:projector/apis/groupService.dart';
import 'package:projector/models/group/groupListVideoAlbumModel.dart';
import 'package:projector/widgets/info_toast.dart';
import 'package:provider/provider.dart';

import 'dialogs.dart';
import 'groups_provider.dart';

class GroupsListPage extends StatefulWidget {
  const GroupsListPage({Key key}) : super(key: key);

  @override
  State<GroupsListPage> createState() => _GroupsListPageState();
}

class _GroupsListPageState extends State<GroupsListPage> {
  bool spin = false;
  GroupsProvider groupsProvider;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final ScrollController _scrollController = ScrollController();
  final GlobalKey expansionTileKey = GlobalKey();
  double previousOffset;

  String selectedGroupId;

  @override
  void initState() {
    groupsProvider = GroupsProvider()..initialize();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return ChangeNotifierProvider.value(
        value: groupsProvider,
        builder: (builderContext, child) {
          return Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                backgroundColor: Colors.white,
                centerTitle: false,
                elevation: 1.0,
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
                  TextButton.icon(
                    onPressed: () {
                      requestDialog(
                        scaffoldKey: _scaffoldKey,
                        context: context,
                        height: height,
                        width: width,
                        type: "AddGroup",
                        spin: spin,
                      );
                    },
                    label: Text(
                      "New group",
                      style: GoogleFonts.montserrat(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w700,
                        color: Colors.blue,
                      ),
                    ),
                    icon: Icon(Icons.add, color: Colors.blue),
                  )
                ],
              ),
              key: _scaffoldKey,
              floatingActionButton: FloatingActionButton(
                backgroundColor:
                    (selectedGroupId != null) ? Color(0xff5AA5EF) : Colors.grey,
                child: Icon(Icons.save, color: Colors.black),
                onPressed: () async {
                  if (selectedGroupId == null) return;

                  final result = await groupsProvider.saveGroupData(
                      groupId: selectedGroupId);

                  if (result) {
                    InfoToast.showSnackBar(context,
                        message: "Group saved Successfully");
                  } else {
                    InfoToast.showSnackBar(context,
                        message: "Error Saving data");
                  }
                },
              ),
              body: _body(builderContext));
        });
  }

  _body(BuildContext bodyContext) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    final provider = bodyContext.watch<GroupsProvider>();

    if (provider.isBusy) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    if (provider.errorMessage != null) {
      return Center(
        child: Text(provider.errorMessage),
      );
    }

    return Container(
      margin: EdgeInsets.only(left: 16.0, right: 16.0, top: 25.0),
      child: ListView.separated(
          controller: _scrollController,
          itemCount: provider.groupListData.length,
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          separatorBuilder: (context, index) => SizedBox(height: 12.0),
          itemBuilder: (context, groupIndex) {
            final groupId = provider.groupListData[groupIndex]['id'];
            final groupItems = provider.checkedGroupItems.firstWhereOrNull(
              (element) => element["groupId"] == groupId,
            );

            List<Video> checkedVideos = [];
            List<Album> checkedAlbums = [];

            if (groupItems != null) {
              checkedVideos = groupItems['videos'];
              checkedAlbums = groupItems['albums'];
            }

            return Container(
              margin: const EdgeInsets.all(2.0),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 1.75,
                      blurRadius: 1.0,
                      offset: Offset(0, 0),
                    )
                  ]),
              child: ExpansionTile(
                onExpansionChanged: (isExpanded) {
                  if (isExpanded) previousOffset = _scrollController.offset;

                  setState(() {
                    selectedGroupId = (isExpanded) ? groupId : null;
                  });

                  _scrollToSelectedContent(
                      isExpanded, previousOffset, groupIndex, expansionTileKey);
                },
                title: Row(
                  children: [
                    Text(
                      provider.groupListData[groupIndex]['title'],
                      style: new TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                    Spacer(),
                    new Visibility(
                      child: InkWell(
                        onTap: () async {
                          removeDialog(
                            context: context,
                            height: height,
                            width: width,
                            groupName: provider.groupListData[groupIndex]
                                ['title'],
                            groupId: provider.groupListData[groupIndex]['id'],
                          );
                        },
                        child: Text(
                          "Delete Group",
                          style: GoogleFonts.montserrat(
                            fontSize: 9.0,
                            fontWeight: FontWeight.w600,
                            color: Color(0xffFF0000),
                          ),
                        ),
                      ),
                      visible: true,
                    ),
                  ],
                ),
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 6, right: 6),
                    padding: EdgeInsets.symmetric(horizontal: 12.0),
                    child: TextButton.icon(
                      onPressed: () {
                        requestDialog(
                          scaffoldKey: _scaffoldKey,
                          context: context,
                          height: height,
                          width: width,
                          type: "AddMemberGroup",
                          spin: spin,
                          groupId: provider.groupListData[groupIndex]['id'],
                        );
                      },
                      label: Text(
                        "Add group member ",
                        style: GoogleFonts.montserrat(
                          fontSize: 12.0,
                          fontWeight: FontWeight.w700,
                          color: Colors.blue,
                        ),
                      ),
                      icon: Icon(Icons.add, color: Colors.blue, size: 20.0),
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (BuildContext context, int memberIndex) {
                      var userEmail = provider.groupListData[groupIndex]
                          ['members'][memberIndex]['email'];
                      var firstName = provider.groupListData[groupIndex]
                          ['members'][memberIndex]['firstname'];
                      var lastName = provider.groupListData[groupIndex]
                          ['members'][memberIndex]['lastname'];
                      var userId = provider.groupListData[groupIndex]['members']
                          [memberIndex]['id'];
                      return Container(
                        margin:
                            EdgeInsets.only(left: 16.0, right: 16.0, top: 25.0),
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
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
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
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
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                      color: Colors.black, width: 1.5),
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                padding: const EdgeInsets.all(5.0),
                              ),
                              onTap: () async {
                                var response = await ContentDashboardService()
                                    .deleteMemberFromGroup(
                                        groupId: provider
                                            .groupListData[groupIndex]['id'],
                                        users: userId);
                                if (response["success"]) {
                                  GroupService().getMyGroups().then((val) {
                                    //streamGroupList.add(val);
                                  });
                                }
                              },
                            ),
                          ],
                        ),
                      );
                    },
                    itemCount:
                        provider.groupListData[groupIndex]['members'].length,
                  ),
                  Padding(
                    padding:
                        EdgeInsets.only(left: 16.0, top: 20.0, right: 20.0),
                    child: Column(
                      children: [
                        Align(
                          child: Text(
                            'Videos',
                            style: GoogleFonts.poppins(
                              fontSize: 14.0,
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          alignment: Alignment.topLeft,
                        ),
                        ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            itemCount: provider.userVideos.length,
                            itemBuilder: (context, videoIndex) {
                              final item = provider.userVideos[videoIndex];
                              final bool isChecked =
                                  (checkedVideos.firstWhereOrNull(
                                          (e) => e.id == item.id) !=
                                      null);

                              if (isChecked) {
                                print(
                                    "Video ${item.title} exsisting in group $groupId");
                              }
                              return Container(
                                child: Row(
                                  children: [
                                    Checkbox(
                                        value: isChecked,
                                        onChanged: (val) {
                                          provider.updateItemInGroup(
                                              isAlbum: false,
                                              isAddition: val,
                                              groupId: groupId,
                                              video: item);
                                        }),
                                    SizedBox(width: 5),
                                    Text(
                                      item.title,
                                      style: GoogleFonts.poppins(
                                        fontSize: 13.0,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                        SizedBox(
                          height: 20,
                        ),
                        Column(
                          children: [
                            Align(
                              child: Text(
                                'Photo Albums',
                                style: GoogleFonts.poppins(
                                  fontSize: 14.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              alignment: Alignment.topLeft,
                            ),
                            Container(
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  scrollDirection: Axis.vertical,
                                  itemCount: provider.userAlbums.length,
                                  itemBuilder: (context, albumIndex) {
                                    final item =
                                        provider.userAlbums[albumIndex];
                                    final bool isChecked =
                                        (checkedAlbums.firstWhereOrNull(
                                                (e) => e.id == item.id) !=
                                            null);

                                    if (isChecked) {
                                      print(
                                          "Album ${item.title} exsisting in group $groupId");
                                    }

                                    return Container(
                                      child: Row(
                                        children: [
                                          Checkbox(
                                              value: isChecked,
                                              onChanged: (val) {
                                                provider.updateItemInGroup(
                                                    isAlbum: true,
                                                    isAddition: val,
                                                    groupId: groupId,
                                                    album: item);
                                              }),
                                          SizedBox(width: 5),
                                          Text(
                                            item.title,
                                            style: GoogleFonts.poppins(
                                              fontSize: 13.0,
                                              color: Colors.black,
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
                        SizedBox(height: 12.0),
                      ],
                    ),
                  ),
                ],
                iconColor: Colors.black,
                textColor: Colors.black,
                collapsedTextColor: Colors.black,
              ),
            );
          }),
    );
  }

  void _scrollToSelectedContent(
      bool isExpanded, double previousOffset, int index, GlobalKey myKey) {
    final keyContext = myKey.currentContext;

    if (keyContext != null) {
      // make sure that your widget is visible
      final box = keyContext.findRenderObject() as RenderBox;
      _scrollController.animateTo(
          isExpanded ? (box.size.height * index) : previousOffset,
          duration: Duration(milliseconds: 500),
          curve: Curves.linear);
    }
  }
}
