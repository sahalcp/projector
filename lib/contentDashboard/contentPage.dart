import 'package:flutter/material.dart';

class ContentPage extends StatefulWidget {
  const ContentPage({Key key}) : super(key: key);

  @override
  State<ContentPage> createState() => _ContentPageState();
}

class _ContentPageState extends State<ContentPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text(
          "content page",
          style: TextStyle(
            color: Colors.red[900],
            fontSize: 30,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
