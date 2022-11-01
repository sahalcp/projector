import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

contentLoading(double height,double width) {
  return Container(
    height: height,
    color: Colors.transparent,
    width: double.infinity,
    //margin: const EdgeInsets.only(left: 16.0,right: 16.0),
    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
    child: Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Expanded(
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300],
            highlightColor: Colors.grey[500],
            enabled: true,
            child: ListView.builder(
              itemBuilder: (_, __) => Padding(
                padding: const EdgeInsets.only(bottom: 15.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: height * 0.10,
                      width: width * 0.37,
                      color: Colors.white,
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 10.0),
                          ),
                          Container(
                            width: 90,
                            height: 8.0,
                            color: Colors.white,
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 2.0),
                          ),
                          Container(
                            width: double.infinity,
                            height: 8.0,
                            color: Colors.white,
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 2.0),
                          ),
                          Container(
                            width: double.infinity,
                            height: 8.0,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                    ),
                    Container(
                      width: 30,
                      height: 5.0,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
              itemCount: 10,
            ),
          ),
        ),
      ],
    ),
  );

}

categoryLoading(double height,double width) {
  return Container(
    color: Colors.transparent,
    width: double.infinity,
    margin: const EdgeInsets.only(left: 16.0,right: 16.0),
    //height: 500,
    // padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Expanded(
          child: Shimmer.fromColors(
              baseColor: Colors.grey[300],
              highlightColor: Colors.grey[500],
              enabled: true,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 3,
                shrinkWrap: true,
                itemBuilder: (context,index){

                  return Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                height: height * 0.09,
                                width: width,
                                color: Colors.white,
                              ),
                            ],
                          ),

                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.0),
                          ),

                        ],
                      ),
                    ],
                  );
                },
              )
          ),
        ),
      ],
    ),
  );

}

videoLoading(double height,double width) {
  return Container(
    color: Colors.transparent,
    width: double.infinity,
    margin: const EdgeInsets.only(left: 16.0,right: 16.0),
    //height: 500,
   // padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Expanded(
          child: Shimmer.fromColors(
              baseColor: Colors.grey[300],
              highlightColor: Colors.grey[500],
              enabled: true,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 3,
                shrinkWrap: true,
                itemBuilder: (context,index){

                  return Column(
                    children: [

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                height: height,
                                width: width,
                                color: Colors.white,
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 3.0),
                              ),
                              Container(
                                width: width,
                                child:  Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Container(
                                      width: 30,
                                      height: 3.0,
                                      color: Colors.white,
                                    ),

                                  ],
                                ),
                              ),
                              Container(
                                width: width,
                                child:  Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 30,
                                      height: 5.0,
                                      color: Colors.white,
                                    ),

                                  ],
                                ),
                              ),
                            ],
                          ),



                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.0),
                          ),

                        ],
                      ),
                    ],
                  );
                },
              )
          ),
        ),
      ],
    ),
  );

}

playListLoading(double height,double width) {
  return Container(
    color: Colors.transparent,
    width: double.infinity,
    height: 500,
    margin: const EdgeInsets.only(left: 16.0,right: 16.0),
    // padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
    child: Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Expanded(
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300],
            highlightColor: Colors.grey[500],
            enabled: true,
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: 3,
              shrinkWrap: true,
              itemBuilder: (context,index){

                return Container(
                  height: 170,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 3,
                    shrinkWrap: true,
                    itemBuilder: (context,index){

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            width: 80,
                            height: 8.0,
                            color: Colors.white,
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 5.0),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    height: height,
                                    width: width,
                                    color: Colors.white,
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 3.0),
                                  ),
                                  Container(
                                    width: width,
                                    child:  Row(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Container(
                                          width: 30,
                                          height: 3.0,
                                          color: Colors.white,
                                        ),

                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: width,
                                    child:  Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: 30,
                                          height: 5.0,
                                          color: Colors.white,
                                        ),

                                      ],
                                    ),
                                  ),
                                ],
                              ),



                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8.0),
                              ),

                            ],
                          ),
                        ],
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ),
      ],
    ),
  );

}


