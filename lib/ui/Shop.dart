import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_login_screen/model/AddingProduct.dart';
import 'package:flutter_login_screen/services/helper.dart';
import 'package:flutter_login_screen/ui/ProductInfo/ProductInfo.dart';
import 'package:flutter_login_screen/ui/home/HomeScreen.dart';
import 'package:flutter_login_screen/ui/home/Test.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_login_screen/database/Data.dart';
import 'dart:io';
import 'package:flutter_login_screen/animation/FadeAnimation.dart';
import 'dart:math';
import 'package:lottie/lottie.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_screen/model/User.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_login_screen/database/Data.dart';
import 'package:permission_handler/permission_handler.dart'; // For Image Picker
import 'package:path/path.dart' as Path;

class Shop extends StatefulWidget {
  final User user;

  const Shop({Key key, this.user}) : super(key: key);

  @override
  State createState() {
    return Shopping(user);
  }
}

class Shopping extends State<Shop> {
  final User user;
  List<Data> dataList = [
  ]; //тут будет список виджетов данных для виджетов, котрый создастся при чтении данных с бд
  DatabaseReference databaseReference = FirebaseDatabase.instance
      .reference(); // инициализация бд

  Shopping(this.user);

  @override
  Widget build(BuildContext context) {
    getDataFromFirebaseAndBuildList(); //вызываем функцию, которая создаст список виджетов и отрисует их
    String imageUrl;
    int min = 1,
        max = 99999999;
    Random rnd = new Random();
    int HASHT = min + rnd.nextInt(max - min);
    int _current = 0;
    String image, tag, descript; //context;
    image =
    'https://firebasestorage.googleapis.com/v0/b/chat-b43aa.appspot.com/o/images%2Fid-0xiGjOHeZwfHJNxCHJJMtryEZjp2%2Fhash-29503656?alt=media&token=a030a049-f6b3-4b87-ae6d-449bd917fd11';
    List images_collection = [
      'https://firebasestorage.googleapis.com/v0/b/chat-b43aa.appspot.com/o/images%2Fid-0xiGjOHeZwfHJNxCHJJMtryEZjp2%2Fhash-29503656?alt=media&token=a030a049-f6b3-4b87-ae6d-449bd917fd11',
      'https://firebasestorage.googleapis.com/v0/b/chat-b43aa.appspot.com/o/images%2Fid-0xiGjOHeZwfHJNxCHJJMtryEZjp2%2Fhash-45474279?alt=media&token=c8400e7a-33c4-4ccf-8184-3759feb8c936',
      'https://firebasestorage.googleapis.com/v0/b/chat-b43aa.appspot.com/o/images%2Fid-0xiGjOHeZwfHJNxCHJJMtryEZjp2%2Fhash-74849519?alt=media&token=466d8ff0-c712-46e4-a5d4-1762a30f2a0b',
      'https://firebasestorage.googleapis.com/v0/b/chat-b43aa.appspot.com/o/images%2Fid-0xiGjOHeZwfHJNxCHJJMtryEZjp2%2Fhash-45474279?alt=media&token=c8400e7a-33c4-4ccf-8184-3759feb8c936',
    ];
    uploadImage() async {
      final _firebaseStorage = FirebaseStorage.instance;
      final _imagePicker = ImagePicker();
      PickedFile image;
      //Check Permissions
      await Permission.photos.request();

      var permissionStatus = await Permission.photos.status;

      if (permissionStatus.isGranted) {
        //Select Image
        image = await _imagePicker.getImage(source: ImageSource.gallery,
            imageQuality: 80,
            maxHeight: 480,
            maxWidth: 640);
        var file = File(image.path);

        if (image != null) {
          //Upload to Firebase
          var snapshot = await _firebaseStorage.ref()

              .child('images/id-${user.userID}/img_$HASHT.jpg')
              .putFile(file);
          var downloadUrl = await snapshot.ref.getDownloadURL();
          setState(() {
            imageUrl = downloadUrl;
          });
        } else {
          print('No Image Path Received');
        }
      } else {
        print('Permission not granted. Try Again with permission access');
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(''),
        backgroundColor: Colors.black,
        leading: InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddingProduct()));
            //uploadImage();
          },
          child: Icon(
            Icons.add,
            color: Colors.white, // add custom icons also
          ),
        ),
        actions: <Widget>[
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {
                  //Test();
                },
                child: Icon(
                  Icons.shopping_cart,
                  size: 26.0,
                  color: Colors.black,
                ),
              )
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: double.infinity,

                decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(30))),
                padding: EdgeInsets.all(20.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[

                    Text(
                      'Find Your\nSwag',
                      style: TextStyle(color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 200,),
                    Align(
                      alignment: FractionalOffset(3, 3),
                      child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) =>
                                    HomeScreenx(user: user)));
                          },
                          child: CircleAvatar(
                            //circle avatar
                            radius: 30.0,
                            backgroundImage: NetworkImage("${user
                                .profilePictureURL}"),
                            //backgroundColor: Colors.transparent,
                          )
                      ),
                    ),

                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.circular(15)),
                child: TextField(
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      prefixIcon: Icon(
                        Icons.search,
                        color: Colors.white,
                      ),
                      hintText: "Search something",
                      hintStyle:
                      TextStyle(color: Colors.grey, fontSize: 15)),
                ),
              ),
              SizedBox(
                height: 40,
              ),
              SizedBox(
                height: 1,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Promo Today',
                      style:
                      TextStyle(fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Container(
                      height: 200,
                      width: MediaQuery
                          .of(context)
                          .size
                          .width,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: CarouselSlider(
                          options: CarouselOptions(
                            height: 240.0,
                            initialPage: 0,
                            autoPlay: true,
                            reverse: false,
                            enableInfiniteScroll: true,
                            autoPlayInterval: Duration(seconds: 5),
                            autoPlayAnimationDuration: Duration(
                                milliseconds: 2000),
                            scrollDirection: Axis.horizontal,
                          ),
                          items: images_collection.map((imgUrl) {
                            return Builder(
                              builder: (BuildContext context) {
                                return Container(
                                  width: MediaQuery
                                      .of(context)
                                      .size
                                      .width,
                                  margin: EdgeInsets.symmetric(horizontal: 5.0),
                                  child: ClipRRect(
                                    //borderRadius: BorderRadius.circular(20),
                                    child: Image.network(
                                      imgUrl,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                );
                              },
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 60,
                    ),
                    // ClipRRect(
                    //   borderRadius: BorderRadius.circular(25.0),
                    // child:Container(
                    //   height: 150,
                    //   width: MediaQuery.of(context).size.width,
                    //   child: ListView(
                    //     scrollDirection: Axis.horizontal,
                    //     children: <Widget>[
                    //       Image.network('https://firebasestorage.googleapis.com/v0/b/chat-b43aa.appspot.com/o/images%2Fid-0xiGjOHeZwfHJNxCHJJMtryEZjp2%2Fhash-74849519?alt=media&token=466d8ff0-c712-46e4-a5d4-1762a30f2a0b'),
                    //       Image.network('https://firebasestorage.googleapis.com/v0/b/chat-b43aa.appspot.com/o/images%2Fid-0xiGjOHeZwfHJNxCHJJMtryEZjp2%2Fhash-45474279?alt=media&token=c8400e7a-33c4-4ccf-8184-3759feb8c936'),
                    //       Image.network('https://firebasestorage.googleapis.com/v0/b/chat-b43aa.appspot.com/o/images%2Fid-0xiGjOHeZwfHJNxCHJJMtryEZjp2%2Fhash-29503656?alt=media&token=a030a049-f6b3-4b87-ae6d-449bd917fd11'),
                    //       Image.network('https://firebasestorage.googleapis.com/v0/b/chat-b43aa.appspot.com/o/images%2Fid-0xiGjOHeZwfHJNxCHJJMtryEZjp2%2Fhash-29503656?alt=media&token=a030a049-f6b3-4b87-ae6d-449bd917fd11'),
                    //     ],
                    //   ),
                    // ),
                    // ),
                    SizedBox(height: 20,),
                    Center(
                      child:Expanded(
                      child:Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Container(
                                child:
                                dataList.length == 0
                                    ? Center(child: Text(
                                  'no data', style: TextStyle(fontSize: 20),))
                                    : ListView.builder(
                                  itemCount: dataList.length,
                                  itemBuilder: (_, index) {
                                    return CardUI(name: dataList[index].name,
                                        imgUrl: dataList[index].img,
                                        context: context);
                                  },
                                ),
                              ),

                           SizedBox(height: 20,),
                          InkWell(
                             child: Container(
                               height: 250,
                               width: double.infinity,
                               padding: EdgeInsets.all(20),
                               margin: EdgeInsets.only(bottom: 20),
                               decoration: BoxDecoration(
                                   borderRadius: BorderRadius.circular(20),
                                   image: DecorationImage(
                                       image: NetworkImage('$image'),
                                       fit: BoxFit.cover
                                   ),
                                   boxShadow: [
                                     BoxShadow(
                                         color: Colors.grey[900],
                                         blurRadius: 10,
                                         offset: Offset(0, 10)
                                     )
                                   ]
                               ),
                               child: Column(
                                 crossAxisAlignment: CrossAxisAlignment.stretch,
                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                 children: <Widget>[
                                   Row(
                                     crossAxisAlignment: CrossAxisAlignment.start,
                                     children: <Widget>[
                                       Expanded(
                                         child: Column(
                                           crossAxisAlignment: CrossAxisAlignment
                                               .start,
                                           children: <Widget>[
                                             FadeAnimation(1, Text("Night ice cow",
                                               style: TextStyle(color: Colors.white,
                                                   fontSize: 30,
                                                   fontWeight: FontWeight.bold),)),
                                             SizedBox(height: 10,),
                                             FadeAnimation(1.1, Text("Shoppers",
                                               style: TextStyle(
                                                   color: Colors.white,
                                                   fontSize: 20),)),

                                           ],
                                         ),
                                       ),
                                       FadeAnimation(1.2, Container(
                                         width: 35,
                                         height: 35,
                                         decoration: BoxDecoration(
                                             shape: BoxShape.circle,
                                             color: Colors.white
                                         ),
                                         child: Center(
                                           child: Icon(
                                             Icons.favorite_border, size: 20,),
                                         ),
                                       ))
                                     ],
                                   ), // пример карточки и визуала
                                   FadeAnimation(1.2, Text("15\$", style: TextStyle(
                                       color: Colors.white,
                                       fontSize: 30,
                                       fontWeight: FontWeight.bold),)),
                                 ],
                               ),
                             ),
                             onTap: () {
                               Navigator.push(
                                   context,
                                   MaterialPageRoute(builder: (context) =>
                                       ProductInformation()));
                             },
                           ),
                          SizedBox(height: 20,),
                        ],
                      ),
                    ),
                    ),
                    Container(
                      height: 200,
                      child: RaisedButton(
                        child: Text('Обновить'),
                        color: Colors.red,
                        onPressed: (){
                          getDataFromFirebaseAndBuildList();
                          setState((){});
                        },
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    ),

                    SizedBox(
                      height: 40,
                    ),
                    // child: Align(
                    //   alignment: Alignment.bottomLeft,
                    //   child: Padding(
                    //     padding: const EdgeInsets.all(15.0),
                    //     child: Text(
                    //       'New collection',
                    //       style:
                    //           TextStyle(color: Colors.white, fontSize: 20),
                    //     ),
                    //   ),
                    // ),

                  ],
                ),
              )
            ],

          ),
        ),
      ),
    );
  }

  void getDataFromFirebaseAndBuildList() {
    databaseReference.once().then((DataSnapshot snapshot) { //получаем данные
      dataList
          .clear(); //очищаем список (дабы не возникло путаницы с повторением элементов)
      var keys = snapshot.value['Data'].keys; //получаем ключи
      var values = snapshot.value['Data']; //получаем значения
      print(keys); /*для наглядности */
      print('$values');
      for (var key in keys) { // бежим по ключам и добавляем значение их пары в отдельный класс
        Data data = Data(
          img: values[key]["img"],
          name: values[key]["name"],
        );
        dataList.add(data);
      }
    }
    );
  }
}

Widget CardUI({String name,String imgUrl, BuildContext context}) {
  return Card(
    color: Colors.orange,
    child: Center(
      child: Container(
        alignment: Alignment.center,
        height: MediaQuery.of(context).size.height * 0.2,
        child: Text('$name \n $imgUrl'),
      ),
    ),
  );
}

