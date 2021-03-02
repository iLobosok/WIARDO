import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_login_screen/model/AddingProduct.dart';
import 'package:flutter_login_screen/model/Favourite.dart';
import 'package:flutter_login_screen/model/User.dart';
import 'package:flutter_login_screen/model/config.dart';
import 'package:flutter_login_screen/ui/ProductInfo/ProductInfo.dart';
import 'package:flutter_login_screen/ui/home/Test.dart';
import 'package:flutter_login_screen/database/Data.dart';
import 'dart:io';
import 'package:flutter_login_screen/animation/FadeAnimation.dart';
import 'dart:math';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart'; // For Image Picker
import 'package:path/path.dart' as Path;



class Shop extends StatefulWidget {
  final Users user;

  const Shop({Key key, this.user}) : super(key: key);

  @override
  State createState() {
    return Shopping(user);
  }
}

List randomImages =
[
  'https://cdn.pixabay.com/photo/2014/09/30/22/50/sandstone-467714_960_720.jpg',
  'https://cdn.pixabay.com/photo/2020/06/15/15/34/fog-5302291_960_720.jpg',
  'https://cdn.pixabay.com/photo/2020/12/23/14/41/forest-5855196_960_720.jpg',
  'https://cdn.pixabay.com/photo/2020/10/21/09/49/beach-5672641_960_720.jpg',
  'https://cdn.pixabay.com/photo/2020/12/18/15/29/mountains-5842346_960_720.jpg',
  'https://cdn.pixabay.com/photo/2021/01/28/03/13/person-5956897_960_720.jpg',
  'https://cdn.pixabay.com/photo/2020/12/10/08/44/mountains-5819651_960_720.jpg',
  'https://cdn.pixabay.com/photo/2021/01/29/09/33/beach-5960371_960_720.jpg',
  'https://cdn.pixabay.com/photo/2021/01/21/09/58/swan-5936863_960_720.jpg',
];
int min = 0;
int max = randomImages.length-1;
Random rnd = new Random();
int r = min + rnd.nextInt(max - min);
String image_to_print  = randomImages[r].toString();

class Shopping extends State<Shop> {
  final Users user;
  var WidgetList = List<Widget>();
  List images_collection = [];
  List<Data> dataList = [
  ]; //тут будет список виджетов данных для виджетов, котрый создастся при чтении данных с бд
  DatabaseReference databaseReference = FirebaseDatabase.instance
      .reference(); // инициализация бд

  Shopping(this.user);

  @override
  Widget build(BuildContext context) {
    getDataFromFirebaseAndBuildCarousel();
    getDataFromFirebaseAndBuildList(); //вызываем функцию, которая создаст список виджетов и отрисует их
    setState(() {});
    String imageUrl;
    int min = 1,
        max = 99999999;
    Random rnd = new Random();
    int HASHT = min + rnd.nextInt(max - min);
    int _current = 0;
    String image, tag, descript; //context;
    image =
    'https://ae01.alicdn.com/kf/H16ae39cc62614d00906f217cc5e0d1089/QUANBO-Men-Red-Polo-Shirts-Cotton-Classic-Fit-Long-Sleeve-Polo-Shirt-Work-Casual-Knitted-Mens.jpg';


    uploadImage() async {
      final _firebaseStorage = FirebaseStorage.instance;
      final _imagePicker = ImagePicker();
      PickedFile image;
      //Check Permissions
      await Permission.photos.request();

      var permissionStatus = await Permission.photos.status;
      if (user.profilePictureURL == '' || user.profilePictureURL == null) {
        // проверка на имение картинки, если нет - присваиваем рандомную
        user.profilePictureURL = '$image_to_print';
      }
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
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(''),
        backgroundColor: Colors.black,
        //проверка на продавца
        leading: user.seller == true ? InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>
                    AddProduct(user: user,)));
          },
          child: Icon(
            Icons.add,
            color: Colors.white, // add custom icons also
          ),
        ) : null,
        actions: <Widget>[
          Padding(
              padding: EdgeInsets.only(left: 20.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context) =>
                          Favourite())); //favourite list of cards
                },
                child: Icon(
                  Icons.favorite_border,
                  size: 26.0,
                  color: Colors.white,
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
                    SizedBox(width: MediaQuery
                        .of(context)
                        .size
                        .width * 0.39,),
                    Align(
                      alignment: FractionalOffset(3, 3),
                      child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) =>
                                    HomeScreenx(user: user,)));
                          },
                          child: CircleAvatar(
                            //circle avatar
                            radius: 30.0,
                            foregroundImage: NetworkImage('${user.profilePictureURL}'),
                            backgroundImage: NetworkImage('https://i.ytimg.com/vi/DwL3CaKIuoA/maxresdefault.jpg'),
                            backgroundColor: Colors.transparent,
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
                padding: EdgeInsets.symmetric(
                    horizontal: Paddings.getPadding(context, 0.02)),
                child: Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: Colors.grey[900],
                      borderRadius: BorderRadius.circular(15)),
                  child: TextField(
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        prefixIcon: Icon(
                          Icons.search,
                          color: Colors.white,
                        ),
                        hintText: "Search something",
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 15)),
                  ),
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
                            enlargeCenterPage: true,
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
                                    borderRadius: BorderRadius.circular(20),
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
                    SizedBox(height: 20,),

                    Container(
                      child: dataList.length == 0
                          ? Center(child: Text('no data', style: TextStyle(
                          fontSize: 20),))
                          : ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: dataList.length,
                          itemBuilder: (_, index) {
                            print(index);
                            return CardUI(
                                name: dataList[index].name,
                                img: dataList[index].img,
                                inst: dataList[index].inst,
                                description: dataList[index].description,
                                type: dataList[index].type,
                                cost: dataList[index].cost,
                                context: context
                            );
                          }
                      ),
                    ),


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
      dataList.clear(); //очищаем список (дабы не возникло путаницы с повторением элементов)
      var keys = snapshot.value['Data'].keys; //получаем ключи
      var values = snapshot.value['Data']; //получаем значения
      for (var key in keys) { // бежим по ключам и добавляем значение их пары в отдельный класс
        Data data = Data(
          img: values[key]["imgUrl"],
          name: values[key]["name"],
          type: values[key]["type"],
          cost: values[key]["cost"],
          inst: values[key]["instagram"],
          description: values[key]["description"],
        );
        dataList.add(data);
      }
      setState(() {}
      );
    }
    );
  }

  void getDataFromFirebaseAndBuildCarousel() {
    databaseReference.once().then((DataSnapshot snapshot) { //получаем данные
      var keys = snapshot.value['PromoToday'].keys; //получаем ключи
      var values = snapshot.value['PromoToday']; //получаем значения
      for (var key in keys) {
        images_collection.add(values[key]);
      }
    }
    );
  }
}

Widget CardUI({String name,String type, String cost, String img, String inst, BuildContext context, String description}) {
  return Card(
    color: Colors.transparent,
    child: Center(
      child:Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          InkWell(
            borderRadius: BorderRadius.circular(20),
            child: Container(
              alignment: Alignment.center,
              height: 250,
              width: double.infinity,
              padding: EdgeInsets.all(20),
              margin: EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(
                      image: NetworkImage('$img'),
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
                            FadeAnimation(1, Text('$name',
                              style: TextStyle(color: Colors.white,
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold),)),
                            SizedBox(height: 10,),
                            FadeAnimation(1.1, Text('$type',
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
                  FadeAnimation(1.2, Text('$cost\$', style: TextStyle(
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
                      ProductInformation(
                        inst: inst,
                        img: img,
                        name: name,
                        description: description,
                      )
                  )
              );
            },
          ),

        ],
      ),
    ),
  );
}