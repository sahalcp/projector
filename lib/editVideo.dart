import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:path_provider/path_provider.dart';
import 'package:projector/apis/videoService.dart';
import 'package:projector/startWatching.dart';
import 'package:projector/uploading/addDetailsVideo.dart';
import 'package:projector/widgets/dialogs.dart';
// import 'package:projector/sideDrawer/listVideo.dart';
import 'package:projector/widgets/widgets.dart';

import 'apis/groupService.dart';

class EditVideo extends StatefulWidget {
  EditVideo({
    this.cat,
    this.desc,
    this.img,
    this.subCat,
    this.title,
    @required this.videoId,
    @required this.status,
    @required this.categoryId,
    @required this.subCatId,
    @required this.playlistIds,
    @required this.groupId,
    @required this.visibility,
  });

  final int videoId, visibility;
  final String title,
      desc,
      cat,
      subCat,
      img,
      status,
      categoryId,
      subCatId,
      groupId;
  final List playlistIds;

  @override
  _EditVideoState createState() => _EditVideoState();
}

class _EditVideoState extends State<EditVideo> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool titleEdit = false,
      descEdit = false,
      loading = false,
      checked1 = false,
      checked2 = false,
      checked3 = false;
  TextEditingController titleController = TextEditingController(),
      descriptionController = TextEditingController();
  FocusNode titleNode, descriptionNode;
  String title,
      description,
      category = '',
      subCategory = '',
      playlistText = '',
      groupId = '';
  int visibilityId;
  List categoryData = [],
      subCategoryData = [],
      playlistData = [],
      playlistIds = [],
      playlistNames = [];
  List<bool> categorySelected = [], subSelected = [], playlistSelected = [];
  int categoryPrevious,
      subPrevious,
      playlistPrevious,
      parentId,
      subCategoryId,
      playlistId;

  createPath() async {
    final String appDir =
        await getApplicationDocumentsDirectory().then((value) => value.path);
    // final Directory appDirFolder = Directory('$appDir/$path');
    final dir = Directory('$appDir/')
        .create(recursive: true)
        .then((value) => value.path);
    return dir;
  }

  setData(isCategory, title) {
    if (isCategory)
      setState(() {
        category = title;
      });
    else
      setState(() {
        subCategory = title;
      });
  }

  setPlaylist(List data) {
    if (data.length != 0) {
      var text = data.reduce((value, element) => value + ',' + element);
      setState(() {
        playlistText = text;
      });
    } else {
      setState(() {
        playlistText = '';
      });
    }
  }

  viewData(title, data, boolData, addOn, context) {
    var height = MediaQuery.of(context).size.height;

    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
      return Container(
        // height: height * 0.6,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$title',
              style: GoogleFonts.poppins(
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 15),
            Container(
              padding: EdgeInsets.only(left: 11.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: data.length == 0 ? 0 : height * 0.04 * data.length,
                    child: ListView.separated(
                      separatorBuilder: (context, index) =>
                          SizedBox(height: 11.0),
                      itemCount: title == 'Category'
                          ? categoryData.length
                          : data.length,
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () async {
                            if (title != 'Playlists') {
                              if (title == 'Category') {
                                parentId = int.parse(data[index]['id']);
                                // print(categoryPrevious);
                                setData(true, data[index]['title']);
                                categorySelected[index] = true;
                                if (categoryPrevious != null)
                                  categorySelected[categoryPrevious] = false;
                                categoryPrevious = index;
                                // subSelected = [];
                                // subCategoryData = [];
                                // var res = await VideoService()
                                //     .getMyCategory(parentId: parentId);
                                // if (res['success'] == true) {
                                //   subCategoryData = res['data'];
                                //   List.generate(subCategoryData.length,
                                //       (index) {
                                //     subSelected.add(false);
                                //   });
                                // }
                              } else {
                                subCategoryId = int.parse(data[index]['id']);
                                setData(false, data[index]['title']);
                                subSelected[index] = true;
                                if (subPrevious != null)
                                  subSelected[subPrevious] = false;
                                subPrevious = index;
                              }
                              setState(() {});
                              Navigator.pop(context);
                            }
                          },
                          child: title == 'Category'
                              ? Text(
                                  categoryData[index]['title'],
                                  style: GoogleFonts.poppins(
                                    fontSize: 13.0,
                                    color: categorySelected[index]
                                        ? Color(0xff5AA5EF)
                                        : Colors.black,
                                    fontWeight: FontWeight.w600,
                                  ),
                                )
                              : title == 'Sub-Category'
                                  ? Text(
                                      data[index]['title'],
                                      style: GoogleFonts.poppins(
                                        fontSize: 13.0,
                                        color: subSelected[index]
                                            ? Color(0xff5AA5EF)
                                            : Colors.black,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    )
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Container(
                                          height: 20,
                                          width: 15,
                                          child: Checkbox(
                                            value: playlistSelected[index],
                                            onChanged: (val) {
                                              setState(() {
                                                playlistSelected[index] =
                                                    !playlistSelected[index];
                                                if (playlistSelected[index]) {
                                                  playlistNames.add(
                                                      playlistData[index]
                                                          ['title']);
                                                  playlistIds.add(
                                                      playlistData[index]
                                                          ['id']);
                                                  setPlaylist(playlistNames);
                                                } else {
                                                  playlistNames.remove(
                                                      playlistData[index]
                                                          ['title']);
                                                  playlistIds.remove(
                                                      playlistData[index]
                                                          ['id']);
                                                  setPlaylist(playlistNames);
                                                }
                                              });
                                            },
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        Text(
                                          data[index]['title'],
                                          style: GoogleFonts.poppins(
                                            fontSize: 13.0,
                                            color: playlistSelected[index]
                                                ? Color(0xff5AA5EF)
                                                : Colors.black,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 11.0),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      addData(
                          title == 'Category'
                              ? 1
                              : title == 'Sub-Category'
                                  ? 2
                                  : 3,
                          title,
                          context);
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
        ),
      );
    });
  }

  addData(id, title, context) {
    var val = '';
    bool loading = false;
    showModalBottomSheet(
        context: context,
        builder: (context) {
          var height = MediaQuery.of(context).size.height;
          return Container(
            height: height * 0.6,
            padding: EdgeInsets.only(
              top: 11.0,
              // left: 39.0,
            ),
            child: Column(
              children: [
                Center(
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      height: 3,
                      width: 60,
                      color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(height: 19),
                Container(
                  padding: EdgeInsets.all(39.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Add New $title',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 5),
                      TextField(
                        decoration: InputDecoration(
                          border: new OutlineInputBorder(
                            borderSide: new BorderSide(color: Colors.teal),
                          ),
                          labelText: 'Add',
                          suffixStyle: const TextStyle(color: Colors.green),
                        ),
                        onChanged: (value) => {val = value},
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          if (val.length != 0) {
                            setState(() {
                              loading = true;
                            });
                            if (id == 1) {
                              var categoryAdded = await VideoService()
                                  .addEditCategory(title: val);
                              if (categoryAdded['success'] == true) {
                                var data = await VideoService().getMyCategory();
                                setState(() {
                                  categoryData = data;
                                  // print(categoryData);
                                  loading = false;

                                  categorySelected.add(false);
                                });
                                Navigator.pop(context);
                                // if (categoryPrevious != null)
                                //   categorySelected[categoryPrevious] = true;
                              }
                            } else if (id == 2) {
                              var subCategoryAdded =
                                  await VideoService().addEditSubCategory(
                                title: val,
                              );
                              // print(subCategoryAdded);
                              if (subCategoryAdded['success'] == true) {
                                var res =
                                    await VideoService().getMySubCategory();
                                subCategoryData = res['data'];
                                subSelected.add(false);
                                // print(data);
                                setState(() {
                                  loading = false;
                                });
                                Navigator.pop(context);
                              }
                            } else {
                              var addPlaylist = await VideoService()
                                  .addEditPlaylist(title: val);
                              if (addPlaylist['success'] == true) {
                                var data = await VideoService().getMyPlaylist();

                                // print(data);
                                setState(() {
                                  loading = false;
                                  playlistData = data;
                                  playlistSelected.add(false);
                                });
                                Navigator.pop(context);
                              }
                            }
                          }
                        },
                        child: Text(
                          loading ? 'Creating...' : 'Create',
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }

  @override
  void initState() {
    //CheckConnectionService().init(scaffoldKey);
    VideoService().getMySubCategory().then((data) {
      setState(() {
        subCategoryData = data['data'];
        List.generate(subCategoryData.length, (index) {
          subSelected.add(false);
        });
        int index = 0;
        subCategoryData.forEach((subcat) {
          index += 1;
          // print(subcat['id']);
          if (widget.subCatId == subcat['id']) {
            subCategoryId = int.parse(subcat['id']);
            // if (categoryPrevious != null) {
            subPrevious = index - 1;
            subSelected[index - 1] = true;
            subCategory = subcat['title'];

            // }
          }
        });
      });
    });
    visibilityId = widget.visibility;
    groupId = widget.groupId;
    if (visibilityId == 1) {
      setState(() {
        checked2 = true;
      });
    } else if (visibilityId == 2) {
      setState(() {
        checked1 = true;
      });
    } else if (visibilityId == 3) {
      setState(() {
        checked3 = true;
      });
    }

    title = widget.title;
    description = widget.desc;
    titleController = TextEditingController(text: title);
    descriptionController = TextEditingController(text: description);
    super.initState();
    VideoService().getMyPlaylist().then((data) {
      if (data != null) {
        setState(() {
          playlistData = data;
          List.generate(playlistData.length, (index) {
            playlistSelected.add(false);
          });
          widget.playlistIds.forEach((id) {
            // print(id);
            for (var i = 0; i < playlistData.length; i++) {
              // print(playlistData[i]['id']);
              if (id == playlistData[i]['id']) {
                setState(() {
                  playlistSelected.removeAt(i);
                  playlistSelected.insert(i, true);
                  playlistNames.add(playlistData[i]['title']);
                  playlistIds.add(playlistData[i]['id']);
                });
              }
            }
            // print(playlistSelected);
            // setPlaylist(playlistNames);
          });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return SafeArea(
      bottom: false,
      top: false,
      child: Scaffold(
        key: scaffoldKey,
        body: ModalProgressHUD(
          inAsyncCall: loading,
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.only(left: 16, right: 16),
              color: Colors.white,
              height: height,
              width: width,
              child: ListView(
                children: [
                  FutureBuilder(
                    future: VideoService().getMyCategory(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        categoryData = snapshot.data;
                        categorySelected = [];
                        List.generate(categoryData.length, (index) {
                          categorySelected.add(false);
                        });
                        snapshot.data.forEach((data) {
                          if (data['id'] == widget.categoryId) {
                            category = data['title'];
                          }
                        });

                        if (categoryPrevious != null) {
                          categorySelected[categoryPrevious] = true;
                          category = categoryData[categoryPrevious]['title'];
                        }
                        // print(subCategory);
                        // if (subPrevious != null) {
                        //   categorySelected[categoryPrevious] = true;
                        //   category = categoryData[categoryPrevious]['title'];
                        // }

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: height * 0.03),
                            Container(
                              // padding: EdgeInsets.all(16),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          //Navigator.pop(context);
                                          navigateRemoveLeft(
                                              context, StartWatchingScreen());
                                        },
                                        child: Icon(
                                          Icons.arrow_back_ios,
                                          color: Colors.black,
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      Text(
                                        'Edit Video',
                                        style: GoogleFonts.poppins(
                                          fontSize: 22.0,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    widget.status == '1'
                                        ? 'Published'
                                        : 'Save Draft',
                                    style: GoogleFonts.poppins(
                                      fontSize: 14.0,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: height * 0.05),
                            widget.img != null
                                ? Container(
                                    width: width,
                                    height: 200,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: widget.img.contains('http')
                                            ? NetworkImage(widget.img)
                                            : widget.img.contains('data')
                                                ? FileImage(File(widget.img))
                                                : AssetImage(widget.img),
                                        fit: BoxFit.fitHeight,
                                      ),
                                    ),
                                    // child: Card(
                                    //   color: Colors.black,
                                    // ),
                                  )
                                : Container(),
                            SizedBox(height: height * 0.02),
                            widget.img != null
                                ? Container(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Download thumbnail',
                                          style: GoogleFonts.poppins(
                                            fontSize: 14.0,
                                            color: Colors.grey[700],
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () async {
                                            Dio dio = Dio();
                                            var path = await createPath();
                                            await dio.download(
                                              widget.img,
                                              '$path/${widget.title}.png',
                                            );
                                            Fluttertoast.showToast(
                                              msg: 'Thumbnail Downloaded',
                                              textColor: Colors.black,
                                            );
                                          },
                                          child: Icon(
                                            Icons.file_download,
                                            color: Colors.black,
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                : Container(),
                            SizedBox(height: height * 0.03),
                            Container(
                              width: width,
                              height: 35,
                              child: ElevatedButton(
                                onPressed: () async {
                                  print(subCategoryId);
                                  var playlistId = '';
                                  if (playlistIds.length != 0)
                                    playlistId = playlistIds.reduce(
                                        (value, element) =>
                                            value + ',' + element);
                                  setState(() {
                                    loading = true;
                                  });
                                  var data =
                                      await VideoService().addVideoContent(
                                    videoId: widget.videoId,
                                    title: title,
                                    description: description,
                                    categoryId: parentId,
                                    subCategoryId: subCategoryId,
                                    playlistId: playlistId,
                                    groupId: groupId,
                                    visibility: visibilityId,
                                    status: '1',
                                  );
                                  // print(data);
                                  if (data['success'] == true) {
                                    Navigator.pop(context);
                                  }
                                  setState(() {
                                    loading = false;
                                  });
                                  // navigate(context, ListVideo());
                                },
                                child: Text(
                                  'Save',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: height * 0.03),
                            Container(
                              padding: EdgeInsets.all(6.0),
                              color: Color(0xffF2F2F2),
                              width: width,
                              child: Text(
                                widget.status == '1' ? 'Published' : 'DRAFT',
                                textAlign: TextAlign.start,
                                style: GoogleFonts.poppins(
                                  fontSize: 12.0,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            SizedBox(height: height * 0.03),
                            Text(
                              'Title',
                              textAlign: TextAlign.start,
                              style: GoogleFonts.poppins(
                                fontSize: 16.0,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: height * 0.01),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  titleEdit = true;
                                });
                              },
                              child: titleEdit
                                  ? Container(
                                      height: height * 0.08,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                          color: Colors.black.withOpacity(0.5),
                                        ),
                                      ),
                                      child: textFileds(context, 'Add Title',
                                          titleController, titleNode, (val) {
                                        if (val.length < 40) {
                                          title = val;
                                        } else {
                                          Fluttertoast.showToast(
                                            gravity: ToastGravity.CENTER,
                                            textColor: Colors.black,
                                            msg:
                                                'Should not exceed 40 characters',
                                          );
                                        }
                                      }, (val) {}, null, TextAlign.center, 40),
                                    )
                                  : Text(
                                      '$title',
                                      textAlign: TextAlign.start,
                                      style: GoogleFonts.poppins(
                                        fontSize: 16.0,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                            ),
                            SizedBox(height: height * 0.03),
                            Text(
                              'Description',
                              textAlign: TextAlign.start,
                              style: GoogleFonts.poppins(
                                fontSize: 16.0,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: height * 0.01),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  descEdit = true;
                                });
                              },
                              child: descEdit
                                  ? Container(
                                      // height: height * 0.16,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                          color: Colors.black.withOpacity(0.5),
                                        ),
                                      ),
                                      child: textFileds(
                                          context,
                                          'Add Description',
                                          descriptionController,
                                          descriptionNode, (val) {
                                        if (val.length < 120) {
                                          description = val;
                                          descriptionController =
                                              TextEditingController(text: val);
                                        } else {
                                          Fluttertoast.showToast(
                                            gravity: ToastGravity.CENTER,
                                            textColor: Colors.black,
                                            msg:
                                                'Should not exceed 120 characters',
                                          );
                                        }
                                      },
                                          (val) {},
                                          5,
                                          description.length == 0
                                              ? TextAlign.center
                                              : TextAlign.justify,
                                          120),
                                    )
                                  : Text(
                                      '$description',
                                      textAlign: TextAlign.start,
                                      style: GoogleFonts.poppins(
                                        fontSize: 16.0,
                                        color: Colors.grey,
                                      ),
                                    ),
                            ),
                            SizedBox(height: height * 0.03),
                            Text(
                              'Add Category',
                              textAlign: TextAlign.start,
                              style: GoogleFonts.poppins(
                                fontSize: 16.0,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: height * 0.01),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(category),
                                InkWell(
                                  onTap: () {
                                    // categorySelected = [];
                                    // List.generate(
                                    //     cat.length,
                                    //     (index) {
                                    //   categorySelected
                                    //       .add(false);
                                    // });
                                    setState(() {
                                      if (categoryPrevious != null)
                                        categorySelected[categoryPrevious] =
                                            true;
                                    });
                                    showModalBottomSheet(
                                      context: context,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(32.0),
                                          topRight: Radius.circular(32.0),
                                        ),
                                      ),
                                      builder: (context) {
                                        return StatefulBuilder(builder:
                                            (BuildContext context,
                                                StateSetter setState) {
                                          return Container(
                                            height: categoryData.length != 0
                                                ? height *
                                                    0.3 *
                                                    categoryData.length
                                                : height * 0.26 ?? height * 0.6,
                                            padding: EdgeInsets.only(
                                              top: 11.0,
                                            ),
                                            child: Column(
                                              children: [
                                                Center(
                                                  child: Container(
                                                      height: 3,
                                                      width: 60,
                                                      color: Colors.black),
                                                ),
                                                SizedBox(height: 19),
                                                Container(
                                                  padding: EdgeInsets.only(
                                                      left: 39.0),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      viewData(
                                                        'Category',
                                                        categoryData,
                                                        categorySelected,
                                                        'Add New Category',
                                                        context,
                                                      ),
                                                      SizedBox(height: 10),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        });
                                      },
                                    );
                                  },
                                  child: Container(
                                    width: width * 0.06,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.black,
                                      ),
                                    ),
                                    child: Center(
                                      child: Icon(
                                        Icons.arrow_drop_down,
                                        size: 16.0,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Add Sub Category',
                                  textAlign: TextAlign.start,
                                  style: GoogleFonts.poppins(
                                    fontSize: 16.0,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: height * 0.01),
                                // SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(subCategory),
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          if (categoryPrevious != null)
                                            categorySelected[categoryPrevious] =
                                                true;
                                        });
                                        showModalBottomSheet(
                                          context: context,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(32.0),
                                              topRight: Radius.circular(32.0),
                                            ),
                                          ),
                                          builder: (context) {
                                            return StatefulBuilder(builder:
                                                (BuildContext context,
                                                    StateSetter setState) {
                                              return Container(
                                                height:
                                                    subCategoryData.length != 0
                                                        ? height *
                                                            0.3 *
                                                            subCategoryData
                                                                .length
                                                        : height * 0.26 ??
                                                            height * 0.6,
                                                padding: EdgeInsets.only(
                                                  top: 11.0,
                                                ),
                                                child: Column(
                                                  children: [
                                                    Center(
                                                      child: Container(
                                                          height: 3,
                                                          width: 60,
                                                          color: Colors.black),
                                                    ),
                                                    SizedBox(height: 19),
                                                    Container(
                                                      padding: EdgeInsets.only(
                                                          left: 39.0),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          viewData(
                                                            'Sub-Category',
                                                            subCategoryData,
                                                            subSelected,
                                                            'Add Sub Category',
                                                            context,
                                                          ),
                                                          SizedBox(height: 10),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            });
                                          },
                                        );
                                      },
                                      child: Container(
                                        width: width * 0.06,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: Colors.black,
                                          ),
                                        ),
                                        child: Center(
                                          child: Icon(
                                            Icons.arrow_drop_down,
                                            size: 16.0,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: height * 0.03),
                            Text(
                              'Add Playlists',
                              textAlign: TextAlign.start,
                              style: GoogleFonts.poppins(
                                fontSize: 16.0,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: height * 0.01),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    playlistText,
                                    maxLines: 2,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    overflow: TextOverflow.clip,
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: InkWell(
                                    onTap: () {
                                      // print(playlistData);
                                      setState(() {
                                        if (playlistPrevious != null)
                                          playlistSelected[playlistPrevious] =
                                              true;
                                      });
                                      showModalBottomSheet(
                                        context: context,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(32.0),
                                            topRight: Radius.circular(32.0),
                                          ),
                                        ),
                                        builder: (context) {
                                          return StatefulBuilder(builder:
                                              (BuildContext context,
                                                  StateSetter setState) {
                                            return Container(
                                              height:
                                                  height * 0.3 ?? height * 0.6,
                                              padding: EdgeInsets.only(
                                                top: 11.0,
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
                                                  SizedBox(height: 19),
                                                  Container(
                                                    padding: EdgeInsets.only(
                                                        left: 39.0),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        viewData(
                                                          'Playlists',
                                                          playlistData,
                                                          playlistSelected,
                                                          'Add Playlist',
                                                          context,
                                                        ),
                                                        SizedBox(height: 10),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          });
                                        },
                                      );
                                    },
                                    child: Icon(
                                      Icons.add,
                                      size: 30.0,
                                      color: Color(0xff5AA5EF),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(height: height * 0.03),
                            Text(
                              'Add Visibility',
                              textAlign: TextAlign.start,
                              style: GoogleFonts.poppins(
                                fontSize: 16.0,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: height * 0.01),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  visibilityId = 2;
                                  checked2 = false;
                                  checked1 = true;
                                  checked3 = false;
                                });
                              },
                              child: Row(
                                children: [
                                  checkBox(height, width, checked1),
                                  Text(
                                    'Anyone with this Link on the Web',
                                    style: TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(height: height * 0.02),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  visibilityId = 1;
                                  checked2 = true;
                                  checked1 = false;
                                  checked3 = false;
                                });
                              },
                              child: Row(
                                children: [
                                  checkBox(height, width, checked2),
                                  Text(
                                    'Anyone can view on projector',
                                    style: TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(height: height * 0.02),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  visibilityId = 3;
                                  checked2 = false;
                                  checked1 = false;
                                  checked3 = true;
                                });
                              },
                              child: Row(
                                children: [
                                  checkBox(height, width, checked3),
                                  Text(
                                    'Choose a group to share with',
                                    style: TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(height: 32),
                            checked3
                                ? FutureBuilder(
                                    future: GroupService().getMyGroups(),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        return Container(
                                          width: width,
                                          height: height * 0.1,
                                          padding: EdgeInsets.only(
                                              top: 8.0, left: 17.0),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(5.0),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Color(0xff000000)
                                                    .withAlpha(29),
                                                blurRadius: 6.0,
                                                // spreadRadius: 6.0,
                                              ),
                                            ],
                                          ),
                                          margin: EdgeInsets.only(
                                            left: 10.0,
                                            right: 10.0,
                                          ),
                                          child: ListView(
                                            // crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              ListView.builder(
                                                itemCount: snapshot.data.length,
                                                shrinkWrap: true,
                                                physics:
                                                    NeverScrollableScrollPhysics(),
                                                itemBuilder: (context, index) {
                                                  return InkWell(
                                                    onTap: () {
                                                      setState(() {
                                                        groupId = snapshot
                                                            .data[index]['id'];
                                                      });
                                                    },
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.all(2.0),
                                                      child: Row(
                                                        children: [
                                                          groupId ==
                                                                  snapshot.data[
                                                                          index]
                                                                      ['id']
                                                              ? Icon(
                                                                  Icons.check,
                                                                  size: 16,
                                                                )
                                                              : Container(
                                                                  width: 16,
                                                                ),
                                                          Text(
                                                            snapshot.data[index]
                                                                ['title'],
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                              Padding(
                                                padding: EdgeInsets.all(2.0),
                                                child: InkWell(
                                                  onTap: () {
                                                    editDialog(
                                                      context,
                                                      height,
                                                      width,
                                                      true,
                                                    ).then((value) {
                                                      setState(() {});
                                                    });
                                                  },
                                                  child: Text(
                                                    'New Group',
                                                    style: TextStyle(
                                                      color: Color(0xff5AA5EF),
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        );
                                      } else {
                                        return Text('Loading');
                                      }
                                    },
                                  )
                                : Container(),
                            SizedBox(height: height * 0.03),
                            widget.status == '0'
                                ? InkWell(
                                    onTap: () {
                                      navigate(
                                          context,
                                          AddDetailsScreen(
                                            image: [widget.img],
                                            videoFile: File(''),
                                          ));
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Draft',
                                          textAlign: TextAlign.start,
                                          style: GoogleFonts.poppins(
                                            fontSize: 17.0,
                                            color: Colors.grey,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Icon(
                                          Icons.arrow_right,
                                          color: Colors.grey,
                                        )
                                      ],
                                    ),
                                  )
                                : Container(),
                            SizedBox(height: height * 0.05),
                          ],
                        );
                      } else {
                        return Container(
                          height: height * 0.4,
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }
                    },
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
