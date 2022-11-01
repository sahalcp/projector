import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projector/widgets/scrollGallery.dart';

class PlayAlbumScreen extends StatefulWidget {
  PlayAlbumScreen({
    @required this.albumList,
  });

  final List albumList;

  @override
  _PlayAlbumScreenState createState() => _PlayAlbumScreenState();
}

class _PlayAlbumScreenState extends State<PlayAlbumScreen> {
  List<String> photoList = [];
  List<ImageProvider> photoLoadList = [];

  @override
  void initState() {
    if (widget.albumList != null && widget.albumList.length > 0) {
      for (int i = 0; i < widget.albumList.length; i++) {
        photoList.add(widget.albumList[i]['photo_file']);
        photoLoadList.add( new NetworkImage(widget.albumList[i]['photo_file']),);
      }
    }
    print("api value---");
    setState(() {
      _enableRotation();
    });
    super.initState();
  }
  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    CarouselController carouselController1 = new CarouselController();

    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return SafeArea(
        bottom: false,
        top: false,
        child: Scaffold(
         /* appBar: AppBar(
            automaticallyImplyLeading: false,
            elevation: 0,
            backgroundColor: Colors.black,
            title: Container(
              child: Align(
                alignment: Alignment.topLeft,
                child: InkWell(
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
                        'Back',
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
              ),
            ),
          ),*/
          body: ScrollGallery(
            //new NetworkImage("https://i.ytimg.com/vi/fq4N0hgOWzU/maxresdefault.jpg"),
            photoLoadList,
            borderColor: Colors.blue,

            //interval: new Duration(seconds: 3),
           )
        ));
  }
  void _enableRotation() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }
}
