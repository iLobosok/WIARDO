import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import "package:flutter/material.dart";
import 'package:flutter_login_screen/database/Data.dart';
import 'package:flutter_login_screen/ui/ProductInfo/ProductInfo.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:share/share.dart';
import 'User.dart';


class SelfProducts extends StatefulWidget {
  final Users user;

  SelfProducts({@required this.user});

  @override
  State createState() {
    return _SelfProductsState(user);
  }
}

class _SelfProductsState extends State<SelfProducts> {
  final dbRef = FirebaseDatabase.instance.reference().child("Data");
  List<Data> dataList =[];
  final firestoreInstance = FirebaseFirestore.instance;
  @override
 void initState() {
    super.initState();
    getDataFromFirebaseAndBuildList();
  }
  final Users user;
  _SelfProductsState(this.user);
  Widget build(BuildContext context) {
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
                    borderRadius: BorderRadius.vertical(bottom: Radius.circular(30))),
                    padding: EdgeInsets.all(20.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(height: 20,),
                        Center(
                          child: Text(
                            'Your items',
                            style: TextStyle(color: Colors.white,
                              fontSize: 25,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(
                    height: 40,
                  ),

                  Container(
                    child: dataList.length == 0
                    ? Container(
                        height: MediaQuery.of(context).size.height * 0.6,
                        width: MediaQuery.of(context).size.width,
                        child: Align(
                          alignment: Alignment.center,
                          child:CircularProgressIndicator()
                        ),
                    )
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: dataList.length,
                        itemBuilder: (_, index) {
                              return cardUI(
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
  void deleteItem({String productID}){
    var firebaseUser = FirebaseAuth.instance.currentUser;
    firestoreInstance
        .collection("users")
        .doc(firebaseUser.uid)
        .get()
        .then((DocumentSnapshot ds) {
      List myItems = ds['MyItems'];
      myItems.remove("$productID");
      firestoreInstance
          .collection("users")
          .doc(firebaseUser.uid)
          .update({"MyItems": myItems}).then((_) {
        dbRef.child('$productID').remove().then((_){
          getDataFromFirebaseAndBuildList();
          setState(() {});
        });
      });
    });
  }
  void getDataFromFirebaseAndBuildList() {
    var firebaseUser = FirebaseAuth.instance.currentUser;
    var dbRef = FirebaseDatabase.instance.reference().child("Data");
    dataList.clear();
    firestoreInstance
        .collection("users")
        .doc(firebaseUser.uid)
        .get()
        .then((DocumentSnapshot ds) {
          List myItems = ds['MyItems'];
          dbRef.once().then((DataSnapshot ds){
            for(String item in myItems){
              Data data = Data(
                img: ds.value[item]['imgUrl'],
                name: ds.value[item]['name'],
                productID: ds.value[item]['productID'],
                description: ds.value[item]['description'],
                inst: ds.value[item]['inst'],
                cost: ds.value[item]['cost'],
                type: ds.value[item]['type'],
              );
              dataList.add(data);
            }
            setState(() {});
          });
      }
    );
  }

  Widget cardUI({String name, String productID, String type, String cost, String img, String inst, BuildContext context, String description}) {
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
                box.size
            );
            setState(() {});
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
}

