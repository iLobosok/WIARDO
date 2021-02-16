import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_login_screen/model/AddingProduct.dart';
import 'package:flutter_login_screen/model/config.dart';
import 'package:flutter_login_screen/ui/ProductInfo/ProductInfo.dart';
import 'package:flutter_login_screen/database/Data.dart';
import 'dart:io';
import 'package:flutter_login_screen/animation/FadeAnimation.dart';
import 'dart:math';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_screen/model/User.dart';
import 'package:flutter_login_screen/ui/home/Test.dart';
import 'package:image_picker/image_picker.dart';
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
  final User user;
  var WidgetList = List<Widget>();
  List images_collection = [];
  List<Data> dataList = []; //тут будет список виджетов данных для виджетов, котрый создастся при чтении данных с бд
  DatabaseReference databaseReference = FirebaseDatabase.instance
      .reference(); // инициализация бд
  Shopping(this.user);
  @override
  Widget build(BuildContext context) {
    getDataFromFirebaseAndBuildCarousel();
    getDataFromFirebaseAndBuildList(); //вызываем функцию, которая создаст список виджетов и отрисует их
    return Scaffold(
      backgroundColor: Colors.black,
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
                    SizedBox(width: MediaQuery.of(context).size.width * 0.39,),
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
                            backgroundImage: NetworkImage('${user.profilePictureURL}'),
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
                padding:  EdgeInsets.symmetric(horizontal: Paddings.getPadding(context, 0.02)),
                child: Container(
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
                      width: MediaQuery.of(context).size.width,
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


                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        if(WidgetList.isEmpty)
                          Text('Wait for a пару секунд')
                        else
                          ...WidgetList,
                      ],
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
          description: values[key]["description"],
        );
        dataList.add(data);
      }
      BuildWidgetList();
    }
    );

  }
  void getDataFromFirebaseAndBuildCarousel() {
    databaseReference.once().then((DataSnapshot snapshot) { //получаем данные
      var keys = snapshot.value['PromoToday'].keys; //получаем ключи
      var values = snapshot.value['PromoToday']; //получаем значения
      for(var key in keys){
        images_collection.add(values[key]);
      }
    }
    );

  }
  void BuildWidgetList(){
    WidgetList.clear();
    for(int index = 0; index < dataList.length; index = index + 1) {
      WidgetList.add(
          CardUI(
            context: context,
            name: dataList[index].name,
            img: dataList[index].img,
            cost: dataList[index].cost,
            type: dataList[index].type,
            description: dataList[index].description
          )
      );
    }
    setState((){});
  }
}

Widget CardUI({String name,String type, String cost, String img, BuildContext context, String description}) {
  return Card(
    color: Colors.transparent,
    child: Center(
      child: Column(
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
