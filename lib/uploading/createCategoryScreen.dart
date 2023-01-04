import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projector/apis/videoService.dart';
import 'package:projector/data/userData.dart';

class CreateCategoryScreen extends StatefulWidget {
  const CreateCategoryScreen({Key key}) : super(key: key);

  @override
  _CreateCategoryScreenState createState() => _CreateCategoryScreenState();
}

class _CreateCategoryScreenState extends State<CreateCategoryScreen> {
  int selectedBackground;
  var selectedBackgroundImageId;
  var val = '';
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      top: false,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          title: Container(

          ),
        ),
        backgroundColor: Colors.white,
        body: new GestureDetector(
          onTap: (){
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: Container(
            child: ListView(
              children: [
                Container(
                  padding: EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Add New Category',
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
                      Align(
                        alignment: Alignment.topRight,
                        child: ElevatedButton(
                          onPressed: () async {
                            if(val.isNotEmpty){
                              var categoryAdded = await VideoService()
                                  .addEditCategory(title: val,bgImageId: selectedBackgroundImageId);
                              if (categoryAdded['success'] == true) {

                                var categoryId = categoryAdded['category_id'].toString();
                                await UserData().setCategoryId(categoryId);
                                await UserData().setCategoryName(val);

                                Navigator.pop(context);

                                //navigateRemoveLeft(context, StartWatchingScreen());
                                //print("categoryId--->"+parentId);


                              }
                            }else{
                              Fluttertoast.showToast(
                                gravity:
                                ToastGravity.CENTER,
                                backgroundColor: Colors.black,
                                textColor: Colors.white,
                                msg:
                                'Enter Category',
                              );
                            }

                          },
                          child: Text(
                            'Create',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),

                      Container(
                        child: Column(
                          children: [
                            SizedBox(height: 20,),
                            Text(
                              'Select Background',
                              style: GoogleFonts.poppins(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(height: 20,),
                          ],
                        ),
                      ),
                      Container(
                        child: FutureBuilder(
                          future: VideoService()
                              .getCategoryBackgroundImages(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return snapshot.data.length == 0
                                  ? Center(
                                child: Text(
                                  'No Background',
                                  style: GoogleFonts.poppins(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              )
                                  : Container(
                                //alignment: Alignment.centerLeft,
                                child: Container(
                                  child: GridView.builder(

                                    gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      childAspectRatio: 3,
                                      crossAxisSpacing: 16,
                                      mainAxisSpacing: 16,
                                    ),
                                    itemCount: snapshot.data.length,
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    scrollDirection: Axis.vertical,
                                    itemBuilder: (context, index) {
                                      //selectedBackgroundImageId = snapshot.data[index]['id'];
                                      var image = snapshot.data[index]
                                      ['image'];
                                      return InkWell(
                                        onTap: () async{
                                          selectedBackgroundImageId = snapshot.data[index]['id'];
                                          print("imageidd ---$selectedBackgroundImageId");
                                          setState(() {
                                           selectedBackground = index;

                                          //print("imageidd ---${selectedBackground == index}");


                                          });
                                        },
                                        child: Container(
                                          padding: EdgeInsets.all(3.0),
                                          // padding:
                                          // EdgeInsets.symmetric(
                                          //     horizontal: 15),
// margin: EdgeInsets.only(right: 16,bottom: 16),
                                          height: 90,
                                          width: MediaQuery.of(context).size.width,
                                          decoration: BoxDecoration(
                                            color:
                                            // Color(0xff2F303D),
                                            Colors.grey,
                                            borderRadius:
                                            BorderRadius
                                                .circular(10.0),
                                            border: Border.all(
                                              color:selectedBackground !=null && selectedBackground == index
                                                  ? Colors.blue
                                                  : Colors.transparent,
                                              width: 3.0,
                                            ),
                                            image: DecorationImage(
                                              // image: AssetImage('images/pic.png'),

                                              image: NetworkImage(image),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              );
                            } else {
                              return CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.blue,
                              );
                            }
                          },
                        ),
                      )
                    ],
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
