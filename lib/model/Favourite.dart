import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_login_screen/model/User.dart';
import 'package:flutter_login_screen/ui/ProductInfo/ProductInfo.dart';
import 'package:flutter_login_screen/database/Data.dart';
import 'package:flutter_login_screen/animation/FadeAnimation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class Favourite extends StatefulWidget {
  final Users user;

  const Favourite({Key key, this.user}) : super(key: key);

  @override
  State createState() {
    return Favouriteping(user);
  }
}

class Favouriteping extends State<Favourite> {
  final Users user;
  var WidgetList = List<Widget>();
  List images_collection = [];
  List<Data> dataList = [
  ]; //тут будет список виджетов данных для виджетов, котрый создастся при чтении данных с бд
  DatabaseReference databaseReference = FirebaseDatabase.instance
      .reference(); // инициализация бд

  Favouriteping(this.user);

  @override
  Widget build(BuildContext context) {
    getDataFromFirebaseAndBuildCarousel();
    getDataFromFirebaseAndBuildList(); //вызываем функцию, которая создаст список виджетов и отрисует их
    setState(() {});

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(''),
        backgroundColor: Colors.black,
        actions: <Widget>[
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
                    SizedBox(height: 20,),
                    Center(
                      child:Text(
                      'Your favourites items',
                      style: TextStyle(color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.bold),
                    ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 40,
              ),
                    // тут должен отображаться отдельный список с понравившимися карточками (надо ещё настроить правильное получение их в getdatafromFirebase)
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
              height: 200,
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
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold),)),
                            SizedBox(height: 10,),
                            FadeAnimation(1.1, Text('$type',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15),)),

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
                            Icons.delete_outline_outlined, size: 20,),
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