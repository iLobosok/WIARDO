import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:home_widget/home_widget.dart';
import 'package:flutter_login_screen/model/AddingProduct.dart';
import 'package:flutter_login_screen/model/Favourite.dart';
import 'package:flutter_login_screen/model/User.dart';
import 'package:flutter_login_screen/model/config.dart';
import 'package:flutter_login_screen/model/selfproducts.dart';
import 'package:flutter_login_screen/ui/ProductInfo/ProductInfo.dart';
import 'package:flutter_login_screen/ui/home/Test.dart';
import 'package:flutter_login_screen/database/Data.dart';
import 'package:flutter_login_screen/animation/FadeAnimation.dart';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_screen/ui/toperson/ToPerson.dart';
import 'package:url_launcher/url_launcher.dart';


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
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final myController = TextEditingController();
  bool searchstate = false;
  /*var queryResultSet = [];
  var tempSearchStore = [];

  initiateSearch(value) {
    if (value.length == 0) {
      setState(() {
        queryResultSet = [];
        tempSearchStore = [];
      });
    }

    var capitalizedValue =
        value.substring(0, 1).toUpperCase() + value.substring(1);

    if (queryResultSet.length == 0 && value.length == 1) {
      SearchService().searchByName(value).then((QuerySnapshot docs) {
        for (int i = 0; i < docs.documents.length; ++i) {
          queryResultSet.add(docs.documents[i].data);
        }
      });
    } else {
      tempSearchStore = [];
      queryResultSet.forEach((element) {
        if (element['businessName'].startsWith(capitalizedValue)) {
          setState(() {
            tempSearchStore.add(element);
          });
        }
      });
    }
  }*/
  final Users user;
  List images_collection = [];
  List<Data> dataList = []; //тут будет список виджетов данных для виджетов, котрый создастся при чтении данных с бд
  DatabaseReference databaseReference = FirebaseDatabase.instance.reference(); // инициализация бд
  Shopping(this.user);


  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    getDataFromFirebaseAndBuildCarousel(1);
    getDataFromFirebaseAndBuildList();
    //вызываем функцию, которая создаст список виджетов и отрисует их
  }


  _launchURL() async {
    String url = 'http://wiardo.tilda.ws/';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch';
    }
  }

  _verification() async {

    String url = 'https://instagram.com/verifywiardo';
    if (await canLaunch(url) && user.verifseller == false) {
      await launch(url);
    } else if (user.verifseller == true) {
      Navigator.push(
          context,
          MaterialPageRoute(builder: (context) =>
              AddProduct(user: user,)));
    }
    else {
      throw 'Can not verify your profile right now!';
    }
  }

  int _value = 1;
  @override
  Widget build(BuildContext context) {
    getDataFromFirebaseAndBuildCarousel(0);
    getDataFromFirebaseAndBuildList();
    setState(() {});
    String imageUrl;
    int min = 1, max = 99999999;
    Random rnd = new Random();
    int HASHT = min + rnd.nextInt(max - min);
    int _current = 0;
    String image, tag, descript; //context;
    setState(() {
      user.profilePictureURL;
    });
    return Scaffold(
    key: _scaffoldKey,
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(''),
        backgroundColor: Colors.black,
        //проверка на продавца
        leading: user.seller == true ? InkWell(
          onTap: () {
            if (user.verifseller != true) {
              var scaffoldKey = _scaffoldKey;
              scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(
                'Verifying your profile ',
                style: TextStyle(color: Colors.white),),
                backgroundColor: Colors.green,));
            }
            _verification();
          },
          child: user.verifseller == true ? Icon(
            Icons.add,
            color: Colors.white, // add custom icons also
          ) : Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
          Icon(Icons.add, color:Colors.red),
          ],
      ),) : Icon(
        Icons.add,
        color: Colors.black, // add custom icons also
      ),
        actions: <Widget>[
          Padding(
              padding: EdgeInsets.only(left: 20.0),
              child: GestureDetector(
                onTap: () {
                    Navigator.push(context, MaterialPageRoute(
                        builder: (context) =>
                            Favourite()));
                },
                child: Icon(
                  Icons.favorite_border,
                  size: 26.0,
                  color: Colors.white,
                ),
              )
          ),
          user.seller == true ? Padding(
              padding: EdgeInsets.only(left: 20.0, right: 10.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context) =>
                          SelfProducts(user: user))); //to self items page
                },
                child: Icon(
                  Icons.checkroom,
                  size: 26.0,
                  color: Colors.white,
                ),
              )
          ) : Icon(
            Icons.favorite_border,
            size: 26.0,
            color: Colors.black,
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
                        .width * 0.40,),
                    Align(
                      alignment: FractionalOffset(3, 3),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.black,
                        ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) =>
                                    HomeScreenx(user: user,)));
                          },
                          child: user.profilePictureURL == "" ? CircleAvatar(
                            //circle avatar
                            radius: 30.0,
                            backgroundImage: NetworkImage('$image_to_print'),
                            backgroundColor: Colors.transparent,
                          ) : CircleAvatar(
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
                padding: EdgeInsets.symmetric(
                    horizontal: Paddings.getPadding(context, 0.02)),
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: Colors.grey[900],
                      borderRadius: BorderRadius.circular(15)),
                  child: TextField(
                    controller: myController,
                   onChanged: (text){
                      SarchMethod(text);
                   },
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        prefixIcon:
                        InkWell(
                            onTap: () async {
                              Text uid = Text(myController.text);

                              DocumentSnapshot result =  await FirebaseFirestore.instance.collection('users/${uid.toString()}').doc().get();
                              setState(() {
                                print(uid);
                                print(result);
                              });
                              /* Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ToPerson(users: result)),
                          );*/
                            },
                        child:Icon(
                          Icons.search,
                          color: Colors.white,
                          size: 20,
                        ),
                        ),
                        hintText: "Search designers",
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 15)),
                  ),
                ),
              ],),
              ),
             /* SizedBox(height: 10.0),
              GridView.count(
                  padding: EdgeInsets.only(left: 10.0, right: 10.0),
                  crossAxisCount: 2,
                  crossAxisSpacing: 4.0,
                  mainAxisSpacing: 4.0,
                  primary: false,
                  shrinkWrap: true,
                  children: tempSearchStore.map((element) {
                    return buildResultCard(element);
                  }).toList()),*/
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

                          child:CarouselSlider(
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
                                child: InkWell(
                                onTap:(){
                                _launchURL();
                                },
                                child:Image.network(
                                      imgUrl,
                                      fit: BoxFit.cover,
                                    ),
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
                      height: 50,
                    ),

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
                                productID: dataList[index].productID,
                                context: context
                            );
                          }
                      ),
                    ),
                    SizedBox(height: 10,),
                    Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.black,
                        ),
                        onPressed: () {
                          getDataFromFirebaseAndBuildList();
                          setState(() {setState(() {});});
                        },
                        child: Icon(
                          Icons.refresh,
                          size: 20.0,
                          color: Colors.white,
                        ),
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
      var keys = snapshot.value['Data'].keys;
      var values = snapshot.value['Data']; //получаем значения
      for (var key in keys) { // бежим по ключам и добавляем значение их пары в отдельный класс
        Data data = Data(
            img: values[key]["imgUrl"],
            name: values[key]["name"],
            type: values[key]["type"],
            cost: values[key]["cost"],
            inst: values[key]["instagram"],
            description: values[key]["description"],
            productID: values[key]["productID"]
        );
        dataList.add(data);
      }
    });
    setState(() {

    });
  }

  void getDataFromFirebaseAndBuildCarousel(int d) {
    databaseReference.once().then((DataSnapshot snapshot) { //получаем данные
      var keys = snapshot.value['PromoToday'].keys; //получаем ключи
      var values = snapshot.value['PromoToday']; //получаем значения
      for (var key in keys) {
        images_collection.add(values[key]);
      }
      d==1 ? setState((){}) : print(d);
    }
    );
  }

  void SarchMethod(String text) {
    DatabaseReference searchRef = FirebaseDatabase.instance.reference().child('Data');
    searchRef.once().then((DataSnapshot snapshot){
    dataList.clear();
    var keys = snapshot.value;
    var values = snapshot.value['Data'];
    for (var key in keys){
      Data data = new Data(
          img: values[keys]["imgUrl"],
          name: values[key]["name"],
          type: values[key]["type"],
          cost: values[key]["cost"],
          inst: values[key]["instagram"],
          description: values[key]["description"],
          productID: values[key]["productID"]
      );
      if(data.name.contains(text)) {
        dataList.add(data);
      }
    }
    });
  }
}

Widget CardUI({String name,String type, String cost, String img, String inst, BuildContext context, String description, String productID}) {
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
                      //image: NetworkImage('$img'),
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
                        child: InkWell(
                          child:Center(
                          child: Icon(
                            Icons.favorite_border, size: 20,),
                        ),
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
                        productID: productID,
                        type: type,
                        cost: cost,
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
/*

Widget buildResultCard(data) {
  return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      elevation: 2.0,
      child: Container(
          child: Center(
              child: Text(data['firstName'],
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20.0,
                ),
              )
          )
      )
  );
}*/
