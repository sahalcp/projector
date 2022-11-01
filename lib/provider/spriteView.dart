

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class SpriteView extends StatefulWidget {
  const SpriteView({Key key}) : super(key: key);

  @override
  _SpriteViewState createState() => _SpriteViewState();
}

class _SpriteViewState extends State<SpriteView> {

  @override
  void initState() {
    setState(() {
      _enableRotation();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
        top: false,
        child: Scaffold(
      backgroundColor: Colors.blue,

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Test screen',
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed:(){

        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
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
