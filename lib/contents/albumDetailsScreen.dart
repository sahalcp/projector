import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projector/apis/videoService.dart';
import 'package:projector/contents/playAlbumScreen.dart';
import 'package:projector/widgets/widgets.dart';

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
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: FutureBuilder(
        future: VideoService().getAlbumDetails(widget.albumId),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var image = snapshot.data[0]['icon'],
                title = snapshot.data[0]['title'],
                description = snapshot.data[0]['description'];

            //date = snapshot.data[0]['publish_date'];

            // var  year = DateTime.parse(date).year;

            if (snapshot.hasData &&
                snapshot.data != null &&
                snapshot.data[0]['photos'].length > 0) {
              albumList.add(snapshot.data[0]['photos']);
            }

            return Container(
              //color: Color(0xff17191E),
              width: width,
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            colorFilter: new ColorFilter.mode(
                                Colors.black.withOpacity(0.8),
                                BlendMode.dstATop),
                            image: NetworkImage(image),
                            fit: BoxFit.fill,
                          ),
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(40),
                            bottomRight: Radius.circular(40),
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
                                      'BACK',
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
                        )),
                    flex: 1,
                  ),
                  Expanded(
                    child: Container(
                      //color: Color(0xff17191E),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 40,
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 25.0, right: 25.0),
                            child: Text(
                              title,
                              style: TextStyle(
                                fontSize: 25.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.start,
                            ),
                          ),
                          SizedBox(height: 40),
                          Container(
                            padding: EdgeInsets.only(left: 28.0, right: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
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
                                      child: Container(
                                        height: 56,
                                        width: 140,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                          color: Colors.white,
                                        ),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            // SizedBox(
                                            //   width: 10,
                                            // ),
                                            Icon(
                                              Icons.play_arrow_rounded,
                                              color: Colors.black,
                                              size: 43.0,
                                            ),
                                            Text(
                                              'PLAY',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                  ],
                                ),
                                SizedBox(height: 12),
                                // Row(
                                //   children: [
                                //     Text(
                                //       year!=null?year.toString():"" ,
                                //       style: TextStyle(
                                //         color: Colors.white,
                                //         fontSize: 15.0,
                                //         fontWeight: FontWeight.bold,
                                //       ),
                                //     ),
                                //     SizedBox(width: 11),
                                //     Text(
                                //       '|',
                                //       style: GoogleFonts.comfortaa(
                                //         color: Colors.white,
                                //         fontWeight: FontWeight.bold,
                                //       ),
                                //     ),
                                //     SizedBox(width: 5),
                                //     Text(
                                //       category!=null?category:"",
                                //       style: TextStyle(
                                //         color: Colors.white,
                                //         fontSize: 15.0,
                                //         fontWeight: FontWeight.bold,
                                //       ),
                                //     ),
                                //     SizedBox(width: 11),
                                //     Text(
                                //       '|',
                                //       style: GoogleFonts.comfortaa(
                                //         color: Colors.white,
                                //         fontWeight: FontWeight.bold,
                                //       ),
                                //     ),
                                //     SizedBox(width: 5),
                                //     Text(
                                //       subCategory!=null?subCategory:"",
                                //       style: TextStyle(
                                //         color: Colors.white,
                                //         fontSize: 15.0,
                                //         fontWeight: FontWeight.bold,
                                //       ),
                                //     ),
                                //   ],
                                // ),
                                SizedBox(height: 12),
                                Container(
                                  width: width,
                                  child: Text(
                                    description,
                                    style: TextStyle(
                                      height: 1.5,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12.0,
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
  }
}
