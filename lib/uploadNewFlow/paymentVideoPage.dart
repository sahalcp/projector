import 'package:flutter/material.dart';
import 'package:projector/sideDrawer/newListVideo.dart';
import 'package:projector/style.dart';
import 'package:projector/uploadNewFlow/paymentsPage.dart';
import 'package:projector/widgets/widgets.dart';
import 'package:video_player/video_player.dart';

class PaymentVideoPage extends StatefulWidget {
  const PaymentVideoPage({Key key, this.videoId, this.uploadCount})
      : super(key: key);

  final String videoId;

  /// User's total uploads
  final int uploadCount;

  @override
  State<PaymentVideoPage> createState() => _PaymentVideoPageState();
}

class _PaymentVideoPageState extends State<PaymentVideoPage> {
  VideoPlayerController _controller;
  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(
      'https://assets.mixkit.co/videos/preview/mixkit-waves-in-the-water-1164-large.mp4',
    )..initialize().then((_) {
        _controller.play();
        setState(() {});
      });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: Transform.scale(
          scale: 0.75,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                primary: Colors.black,
                shape: CircleBorder(),
                padding: EdgeInsets.all(0.0)),
            onPressed: () {
              if (widget.videoId != null) {
                navigateReplace(
                    context, NewListVideo(videoId: widget.videoId.toString()));
              } else {
                Navigator.of(context).pop();
              }
            },
            child: Icon(
              Icons.chevron_left,
              color: Colors.white,
              size: 42.0,
            ),
          ),
        ),
        actions: [
          Transform.scale(
            scale: 0.8,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                padding: EdgeInsets.all(0.0),
              ),
              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    PaymentsPage.route(
                      videoId: widget.videoId,
                      uploadCount: widget.uploadCount,
                    ));
              },
              child: Text("Skip", style: TextStyle(fontSize: 17.0)),
            ),
          )
        ],
      ),
      body: _controller.value.isInitialized
          ? InkWell(
              child: VideoPlayer(_controller),
              onTap: () {
                setState(() {
                  _controller.value.isPlaying
                      ? _controller.pause()
                      : _controller.play();
                });
              },
            )
          : Container(
              width: screenSize.width,
              height: screenSize.height,
              color: appBgColor,
            ),
    );
  }
}
