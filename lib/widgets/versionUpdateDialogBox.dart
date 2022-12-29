import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
class VersionUpdateDialogBox extends StatefulWidget {
  final String title, descriptions, text;
  final Image img;
  final VoidCallback updateButtonClick;
  final VoidCallback cancelButtonClick;

  const VersionUpdateDialogBox({Key key,this.title, this.descriptions, this.text, this.img, this.updateButtonClick, this.cancelButtonClick}) : super(key: key);

  @override
  State<VersionUpdateDialogBox> createState() => _VersionUpdateDialogBoxState();
}

class _VersionUpdateDialogBoxState extends State<VersionUpdateDialogBox> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: updateDialog(context),
    );
  }


  updateDialog(context){
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(left: 20,top: 45, right: 20,bottom: 20
          ),
          margin: EdgeInsets.only(top: 45),
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(color: Colors.black,offset: Offset(0,10),
                    blurRadius: 10
                ),
              ]
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text("Projector",style: TextStyle(fontSize: 22,fontWeight: FontWeight.w600),),
              SizedBox(height: 15,),
              Text("New version of Projector is available.",style: TextStyle(fontSize: 14),textAlign: TextAlign.center,),
              SizedBox(height: 22,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: widget.cancelButtonClick,
                    child: Text("Cancel",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w600,color: Colors.blue),),
                  ),
                  InkWell(
                    onTap: widget.updateButtonClick,
                    child: Text("Update",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w600,color: Colors.blue),),
                  ),

                ],
              )
            ],
          ),
        ),
        Positioned(
          left: 20,
          right: 20,
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: 45,
            child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(45)),
                child: Image.asset('images/logo_square.png')
            ),
          ),
        ),
      ],
    );
  }
}
