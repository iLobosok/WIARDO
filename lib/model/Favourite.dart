/*MIT License

Copyright (c) 2018 Romain Rastel

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.*/

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_login_screen/model/User.dart';
import 'package:flutter_login_screen/ui/ProductInfo/ProductInfo.dart';
import 'package:flutter_login_screen/database/Data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:flutter_slidable/flutter_slidable.dart';




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
  DatabaseReference databaseReference = FirebaseDatabase.instance.reference(); // инициализация бд
  Favouriteping(this.user);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDataFromFirebaseAndBuildList();
  }

  @override
  Widget build(BuildContext context) {
    getDataFromFirebaseAndBuildList(); //вызываем функцию, которая создаст список виджетов и отрисует их
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
                          'Your favourite items',
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
               child: dataList.length == 0 || dataList == null
               ? Container(
                   height: MediaQuery.of(context).size.height * 0.6,
                   width: MediaQuery.of(context).size.width,
                   child: Align(
                    alignment: Alignment.center,
                       child:CircularProgressIndicator(
                         backgroundColor: Colors.yellow[600],
                       )
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
      setState(() {});
    }
    );
  }


  Widget CardUI({String name, String productID, String type, String cost, String img, String inst, BuildContext context, String description}) {
    String text = '$img';
    String subject = 'Check this item $productID';
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.25,
      actions: <Widget>[

        InkWell(
          onTap: (){
            final RenderBox box = context.findRenderObject();
            Share.share(text,
                subject: subject,
                sharePositionOrigin:
                box.localToGlobal(Offset.zero) &
                box.size);
           setState(() {
           });
            },
        child:IconSlideAction(
          caption: 'Share',
          color: Colors.indigo,
          icon: Icons.share,
        ),
        ),
        ],
      secondaryActions: <Widget>[
         IconSlideAction(
          caption: 'Delete',
          color: Colors.red[500],
          icon: Icons.delete,
          onTap: () => deleteItem(productID: productID),
        ),
      ],
      child: Card(
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
                          image: NetworkImage('$img'), fit: BoxFit.cover),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey[900],
                            blurRadius: 10,
                            offset: Offset(0, 10))
                      ]),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                    Text(
                                      '$name',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold),
                                    ),
                                SizedBox(
                                  height: 10,
                                ),
                                    Text(
                                      '$type',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 15),
                                    ),
                              ],
                            ),
                          ),
                        ],
                      ), // пример карточки и визуала
                          Text(
                            '$cost\$',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                                fontWeight: FontWeight.bold),
                          ),
                    ],
                  ),
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProductInformation(
                                inst: inst,
                                img: img,
                                name: name,
                                description: description,
                                productID: productID,
                                type: type,
                                cost: cost,
                              )));
                },
              ),
            ],
          ),
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
        setState(() {

        });
      });
  });
}
}