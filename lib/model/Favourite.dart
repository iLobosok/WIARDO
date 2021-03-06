import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  final firestoreInstance = FirebaseFirestore.instance;
  
  List images_collection = [];
  List<Data> dataList = []; //тут будет список виджетов данных для виджетов, котрый создастся при чтении данных с бд
  DatabaseReference databaseReference = FirebaseDatabase.instance
      .reference(); // инициализация бд

  Favouriteping(this.user);
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDataFromFirebaseAndBuildList();

  }
  @override
  Widget build(BuildContext context) {
    //getDataFromFirebaseAndBuildList(); //вызываем функцию, которая создаст список виджетов и отрисует их
    //setState(() {});
    //print("dataList $dataList");
    //print("dataList len ${dataList.length}");
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
                        child: Text(
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
               ? Container(
                   height: MediaQuery.of(context).size.height * 0.6,
                   width: MediaQuery.of(context).size.width,
                   child: Align(
                    alignment: Alignment.center,
                       child:CircularProgressIndicator()
                   )
               )
               : ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: dataList.length,
                      itemBuilder: (_, index) {
                        return CardUI(
                            name: dataList[index].name,
                            productID: dataList[index].productID,
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
    var firebaseUser = FirebaseAuth.instance.currentUser;
    dataList.clear();
    firestoreInstance
        .collection("users")
        .doc(firebaseUser.uid)
        .get()
        .then((DocumentSnapshot ds) {
      Map favs = ds['favorites'];
      var values = favs.values; //получаем значения
      for (var i in values) {
        Data data = Data(
            img: i[1],
            name: i[2],
            type: i[3],
            cost: i[4],
            inst: i[6],
            description: i[5],
            productID: i[0]
        );
        dataList.add(data);
      }
      print(dataList);
      setState(() {});
    }
    );
  }


  Widget CardUI({String name, String productID, String type, String cost, String img, String inst, BuildContext context, String description}) {
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
                        FadeAnimation(1.2, InkWell(
                          child: Container(
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
                          ),
                          onTap: (){
                            print("deleted!");
                            deleteItem(productID: productID);
                            //getDataFromFirebaseAndBuildList();
                            setState(() {});
                          },
                        ),
                        )
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
  
  void deleteItem({String productID}){
    var firebaseUser = FirebaseAuth.instance.currentUser;
    firestoreInstance
        .collection("users")
        .doc(firebaseUser.uid)
        .get()
        .then((DocumentSnapshot ds) {
      Map favs = ds['favorites'];
      favs.remove("$productID");
      firestoreInstance
          .collection("users")
          .doc(firebaseUser.uid)
          .update({"favorites": favs}).then((_) {
        getDataFromFirebaseAndBuildList();
      });
  });
}
}