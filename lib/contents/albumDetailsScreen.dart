import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projector/apis/videoService.dart';
import 'package:projector/contents/playAlbumScreen.dart';
import 'package:projector/widgets/widgets.dart';
import 'package:sizer/sizer.dart';

class AlbumDetailScreen extends StatefulWidget {
  AlbumDetailScreen({@required this.albumId});
  final String albumId;
  @override
  _AlbumDetailScreenState createState() => _AlbumDetailScreenState();
}

class _AlbumDetailScreenState extends State<AlbumDetailScreen> {
  bool loading = false;
  List albumList = [];

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Sizer(builder: (context, orientation, deviceType) {
      return Scaffold(
        body: FutureBuilder(
          future: VideoService().getAlbumDetails(widget.albumId),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var response = snapshot.data['data'];

              var image = response[0]['icon'],
                  title = response[0]['title'],
                  description = response[0]['description'];

              var bannerPreviewStyleId =
                  snapshot.data['banner_preview_style_id'];

              //date = snapshot.data[0]['publish_date'];
              // var  year = DateTime.parse(date).year;

              if (snapshot.hasData &&
                  response != null &&
                  response[0]['photos'].length > 0) {
                albumList.add(response[0]['photos']);
              }

              return Container(
                //color: Color(0xff17191E),
                color: Colors.black,
                width: width,
                child: Column(
                  children: [
                    Expanded(
                      child: Stack(
                        children: [
                          // bannerPreviewStyleId = 1 (large)
                          // bannerPreviewStyleId = 2 (small)

                          bannerPreviewStyleId == "2"
                              ? Container(
                                  padding: EdgeInsets.only(
                                    left: 20,
                                    right: 10,
                                    top: 50,
                                  ),
                                  child: Column(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          Navigator.pop(context);
                                        },
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.arrow_back_ios,
                                              color: Colors.white,
                                              size: 28,
                                            ),
                                            Text(
                                              '',
                                              style: GoogleFonts.montserrat(
                                                fontSize: 20.0,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                              textAlign: TextAlign.start,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : Container(),
                          bannerPreviewStyleId == "2"
                              ? Positioned(
                                  right: 0,
                                  child: Container(
                                    width: 250,
                                    height: 250,
                                    foregroundDecoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.black,
                                          Colors.transparent
                                        ],
                                        begin: FractionalOffset.centerLeft,
                                        end: FractionalOffset.centerRight,
                                        stops: [0.0, 1.0],
                                      ),
                                    ),
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: NetworkImage(image),
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                                )
                              : Positioned(
                                  top: 0,
                                  bottom: 0,
                                  left: 0,
                                  right: 0,
                                  child: Container(
                                      foregroundDecoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            Colors.transparent,
                                            Colors.transparent,
                                            Colors.transparent,
                                            Colors.black
                                          ],
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          stops: [0, 0.2, 0, 2],
                                        ),
                                      ),
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          // colorFilter: new ColorFilter.mode(
                                          //     Colors.black.withOpacity(0.8),
                                          //     BlendMode.dstATop),
                                          image: NetworkImage(image),
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                      child: Container(
                                        padding: EdgeInsets.only(
                                          left: 20,
                                          right: 10,
                                          top: 50,
                                        ),
                                        child: Column(
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                Navigator.pop(context);
                                              },
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.arrow_back_ios,
                                                    color: Colors.white,
                                                    size: 28,
                                                  ),
                                                  Text(
                                                    '',
                                                    style:
                                                        GoogleFonts.montserrat(
                                                      fontSize: 20.0,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white,
                                                    ),
                                                    textAlign: TextAlign.start,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      )),
                                ),

                          Container(
                            margin: EdgeInsets.only(left: 30, right: 30),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Row(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        if (albumList.length > 0) {
                                          navigate(
                                            context,
                                            PlayAlbumScreen(
                                              albumList: albumList[0],
                                            ),
                                          );
                                        }
                                      },
                                      child: Image(
                                        height: 45,
                                        width: 45,
                                        image: AssetImage(
                                            'images/icon_play_new.png'),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Container(
                                  margin: EdgeInsets.only(right: 30),
                                  child: Text(
                                    title,
                                    style: TextStyle(
                                      fontSize: deviceType == DeviceType.mobile
                                          ? 25.0
                                          : 35.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      flex: 2,
                    ),
                    Expanded(
                      child: Container(
                        //color: Colors.black,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              padding: EdgeInsets.only(left: 28.0, right: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 12),
                                  Container(
                                    width: width,
                                    child: Text(
                                      description,
                                      style: TextStyle(
                                        height: 1.5,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize:
                                            deviceType == DeviceType.mobile
                                                ? 12.0
                                                : 20,
                                      ),
                                      maxLines: 5,
                                      textAlign: TextAlign.start,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      flex: 1,
                    ),
                  ],
                ),
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      );
    });
  }
}
