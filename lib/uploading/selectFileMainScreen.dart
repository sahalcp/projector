import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projector/apis/photoService.dart';
import 'package:projector/data/userData.dart';
import 'package:projector/startWatching.dart';
import 'package:projector/uploading/summaryScreen.dart';
import 'package:projector/uploading/photo/selectPhoto.dart';
import 'package:projector/uploading/selectVideo.dart';
import 'package:projector/uploading/uploadImages.dart';
import 'package:projector/widgets/widgets.dart';

class SelectFileMainScreen extends StatefulWidget {
  const SelectFileMainScreen({Key key}) : super(key: key);

  @override
  _SelectFileMainScreenState createState() => _SelectFileMainScreenState();
}

class _SelectFileMainScreenState extends State<SelectFileMainScreen> {
  String _loginedUserId;
 bool checked = false;
  List albumList = [];
  int groupValue = 1;
  String selectedTitle;
  String selectedDescription;

  albumBottomSheet() {
    var val = '';
    bool loading = false;
    //var context;
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        context: context,
        builder: (context) {
          var height = MediaQuery.of(context).size.height;
          var width = MediaQuery.of(context).size.width;
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return Stack(
                  children: [
                  Container(
                  height: height * 0.6,
                  padding: EdgeInsets.only(
                    top: 11.0,
                    // left: 39.0,
                  ),
                  child: ListView(
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
                        padding: EdgeInsets.only(left: 39.0,right: 39.0,bottom: 39.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Album',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18.0,
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Add New Album',
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: 13.0,
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 10),
                            Container(
                              height: 40,
                              child: TextField(
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14.0,
                                ),
                                decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.grey,
                                    ),
                                   // borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.blue,
                                    ),
                                   // borderRadius: BorderRadius.circular(5.0),
                                  ),
                                ),
                                onChanged: (value) => {val = value},
                              ),
                            ),
                            SizedBox(height: 10),
                            Align(
                              alignment: Alignment.topRight,
                              child: RaisedButton(
                                color: Colors.blue,
                                onPressed: () async {
                                  if (val.length != 0) {

                                    setState(() {
                                      loading = true;
                                    });

                                    var createAlbum = await PhotoService()
                                        .addAlbum(title: val,description: "",icon: "",albumId: "");
                                    if (createAlbum['success'] == true) {
                                      Fluttertoast.showToast(msg: 'Album created', backgroundColor: Colors.black);
                                     // Navigator.pop(context);
                                      var res = await  PhotoService().getMyAlbum(userId: _loginedUserId);
                                      albumList = res;
                                    }
                                  }else{
                                    Fluttertoast.showToast(msg: 'Enter album name', backgroundColor: Colors.black);
                                  }
                                },
                                child: Text(
                                  'Create',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                            SizedBox(height: 30),

                            Container(
                              child: FutureBuilder(
                                future: PhotoService().getMyAlbum(userId: _loginedUserId),
                                builder: (context,snapshot){
                                  if (snapshot.hasData) {
                                    return Container(
                                      child: snapshot.data.length==0?Container():Container(
                                        child: Column(
                                          children: [
                                            Align(
                                              alignment: Alignment.topLeft,
                                              child: Text(
                                                'Choose from existing Albums',
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 18.0,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                            SizedBox(height: 10),
                                            ListView.builder(
                                                itemCount:
                                                snapshot.data.length,
                                                shrinkWrap: true,
                                                scrollDirection:
                                                Axis.vertical,
                                                physics: NeverScrollableScrollPhysics(),
                                                itemBuilder:(context, index) {
                                                  var title = snapshot
                                                      .data[index]['title'];
                                                  var id = snapshot
                                                      .data[index]['id'];
                                                  var description = snapshot
                                                      .data[index]['description'];

                                                  return Container(
                                                    // RadioListTile<int>(
                                                    //   toggleable: true,
                                                    //   contentPadding: EdgeInsets.all(0),
                                                    //   title: Text(
                                                    //     title,
                                                    //     style: TextStyle(
                                                    //       color: Colors.black,
                                                    //       fontSize: 14.0,
                                                    //       fontWeight: FontWeight.w600,
                                                    //     ),
                                                    //   ),
                                                    //   groupValue: groupValue,
                                                    //   value: int.parse(id),
                                                    //   onChanged: (int val) {
                                                    //     setState(() {
                                                    //       radioItem = title ;
                                                    //       groupValue = val;
                                                    //
                                                    //       print("radiovalue-->"+radioItem.toString()+","+groupValue.toString());
                                                    //     });
                                                    //   },
                                                    // ),


                                                      child:SizedBox(
                                                        height: 40,
                                                        child: Row(
                                                          children: [
                                                            Radio<int>(
                                                              toggleable: true,
                                                              groupValue: groupValue,
                                                              value: int.parse(id),
                                                              onChanged: (int val) {
                                                                setState(() {
                                                                  selectedTitle = title ;
                                                                  selectedDescription = description;
                                                                  groupValue = val;

                                                                });
                                                              },
                                                            ),
                                                            Text(
                                                              title,
                                                              style: TextStyle(
                                                                color: Colors.black,
                                                                fontSize: 14.0,
                                                                fontWeight: FontWeight.w600,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      )
                                                  );
                                                }),
                                          ],
                                        ),
                                      ),
                                    );
                                  }else{
                                    return Container();
                                  }

                                },
                              ),
                            ),

                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                 albumList.length>0?   Positioned(
                      bottom: 0.0,
                      right: 0.0,
                      child: Container(
                        margin: EdgeInsets.only(right: 20,bottom: 20),
                        child: Align(
                          alignment: Alignment.topRight,
                          child:  RaisedButton(
                            color: selectedTitle != null?Colors.blue: Colors.grey,
                            onPressed: () async{

                              // print("radiovalue-->"+selectedTitle.toString()+","+groupValue.toString());

                              if(selectedTitle!=null){
                                Navigator.pop(context);
                                await UserData().setAlbumId(groupValue);
                                await UserData().setAlbumTitle(selectedTitle!=null?selectedTitle:"");
                                await UserData().setAlbumDescription(selectedDescription!=null?selectedDescription:"");
                                navigateLeft(context, SelectPhotoView());
                              }else{
                                Fluttertoast.showToast(msg: 'Choose Album', backgroundColor: Colors.black);
                              }

                            },
                            child: Text(
                              'Choose',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      )):Container(),
                  ],
                );

              });
        });
  }

  Future<void> getUserId() async {
    var userId = await UserData().getUserId();

    setState(() {
      _loginedUserId = userId;
      //print("logineduser -->"+_loginedUserId);
    });
  }

  @override
  void initState() {
    getUserId();

    PhotoService().getMyAlbum(userId: _loginedUserId).then((data) {
      if (data != null) {
        setState(() {
          albumList = data;
          List.generate(albumList.length, (index) {
            //categorySelected.add(false);
          });
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return SafeArea(
      bottom: false,
      top: false,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: false,
          leading: IconButton(
            onPressed: () {
              navigateRemoveLeft(context, StartWatchingScreen());

              // if (Navigator.canPop(context)) {
              //   Navigator.pop(context);
              // } else {
              //   SystemNavigator.pop();
              // }
            },
            icon: Icon(Icons.arrow_back_ios),
            color: Colors.white,
          ),
          titleSpacing: 0.0,
          title: Text(
            "Upload File",
            style: GoogleFonts.montserrat(
              color: Colors.white,
              fontSize: 22.0,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        body: Container(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(left: 25, top: 25, bottom: 15),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Select File",
                    style: GoogleFonts.montserrat(
                      color: Colors.white,
                      fontSize: 13.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: () {
                    //navigateLeft(context, UploadImages());
                    navigateLeft(context, SelectVideoView());
                  },
                  child: Container(
                    width: width,
                    height: height,
                    margin: EdgeInsets.only(left: 25, right: 25, bottom: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: ListView(
                      children: [
                        SizedBox(height: height * 0.05),
                        CircleAvatar(
                          backgroundColor: Color(0xffFAF8F8),
                          radius: width * 0.18,
                          child: Image(
                            height: height * 0.10,
                            width: width * 0.18,
                            image: AssetImage('images/add_video.png'),
                          ),
                        ),
                       // Spacer(),
                        Wrap(
                          children: [
                            Align(
                              alignment: Alignment.bottomCenter,
                              child:  Container(
                                margin: EdgeInsets.only(top: 25.0),
                                padding: const EdgeInsets.only(
                                    left: 40.0, right: 40.0, top: 20.0, bottom: 20.0),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Color(0xff9F9E9E).withOpacity(0.5)),
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                child: Text(
                                  'Add Video',
                                  style: GoogleFonts.montserrat(
                                    color: Color(0xff9F9E9E),
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ],
                        ),

                        // SizedBox(height: height * 0.016),
                      ],
                    ),
                  ),
                ),
                flex: 1,
              ),
              Expanded(
                child: InkWell(
                  onTap: () {
                    albumBottomSheet();
                  },
                  child: Container(
                    width: width,
                    height: height,
                    margin: EdgeInsets.only(left: 25, right: 25, top: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: ListView(
                      children: [
                        SizedBox(height: height * 0.05),
                        CircleAvatar(
                          backgroundColor: Color(0xffFAF8F8),
                          radius: width * 0.18,
                          child: Image(
                            height: height * 0.10,
                            width: width * 0.18,
                            image: AssetImage('images/add_img.png'),
                          ),
                        ),
                       // Spacer(),
                        Wrap(
                          children: [
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                margin: EdgeInsets.only(top: 25.0),
                                padding: const EdgeInsets.only(
                                    left: 40.0, right: 40.0, top: 20.0, bottom: 20.0),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Color(0xff9F9E9E).withOpacity(0.5)),
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                child: Text(
                                  'Add Photo/s',
                                  style: GoogleFonts.montserrat(
                                    color: Color(0xff9F9E9E),
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),

                          ],
                        ),

                        // SizedBox(height: height * 0.016),
                      ],
                    ),
                  ),
                ),
                flex: 1,
              ),
              SizedBox(
                height: height * 0.1,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
