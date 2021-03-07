import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_login_screen/animation/FadeAnimation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_screen/model/config.dart';
import 'package:url_launcher/url_launcher.dart';
class ProductInformation extends StatefulWidget {
  final img;
  final cost;
  final type;
  final name;
  final description;
  final String inst;
  final String productID;

  @override
  const ProductInformation({
    Key key,
    this.img,
    this.cost,
    this.type,
    this.name,
    this.description,
    this.inst,
    this.productID
  }) : super(key: key);
  ProductInfo createState() => ProductInfo(
      img: img,
      cost:cost,
      type: type,
      name: name,
      description: description,
      inst: inst,
      productId: productID);
}


class ProductInfo extends State<ProductInformation> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final String img;
  final String name;
  final String cost;
  final String type;
  final String description;
  final String inst;
  final String productId;
  bool _isFavorite = false;
  ProductInfo({
    this.inst,
    this.img,
    this.cost,
    this.type,
    this.name,
    this.description,
    this.productId
  });

  _launchURL() async {
    String url = 'https://www.instagram.com/$inst/';
    if (await canLaunch(url)) {
    await launch(url);
    } else {
    throw 'Could not launch $url';
    }
  }
  @override
  Widget build(BuildContext context) {
    final firestoreInstance = FirebaseFirestore.instance;
    return Scaffold(
      key: _scaffoldKey,
      body: SingleChildScrollView(
          child: Hero(
            tag: 'red',
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: double.infinity,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage('$img'),
                      fit: BoxFit.cover
                  ),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey[400],
                        blurRadius: 10,
                        offset: Offset(0, 10)
                    )
                  ]
              ),
              child: Stack(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 50),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        InkWell(
                          child:Container(
                            width: 45,
                            height: 45,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white
                            ),
                            child: Icon(
                              Icons.arrow_back,
                              color: Colors.black,
                              size: 20,
                            ),
                          ),
                          onTap: (){
                            Navigator.of(context).pop();
                          },
                        ),
                         SizedBox(height: 10,),

                        _isFavorite == true ? InkWell(
                          child:Container(
                            width: 35,
                            height: 35,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white
                            ),
                            child: Center(
                              child: Icon(
                                Icons.favorite_border,
                                size: 20,
                                color: Colors.red,
                              ),
                            ),
                          ),
                          onTap: (){
                            _isFavorite = false;
                            setState(() {
                            });
                          },
                        ) : InkWell (
                        child:Container(
                          width: 35,
                          height: 35,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white
                          ),
                          child: Center(
                            child: Icon(
                                Icons.favorite_border,
                                size: 20,
                              color: Colors.black,
                            ),
                          ),
                        ),
                          onTap: (){
                            _isFavorite = true;
                            setState(() {
                              var firebaseUser = FirebaseAuth.instance.currentUser;
                              firestoreInstance
                                  .collection("users")
                                  .doc(firebaseUser.uid)
                                  .get()
                                  .then((DocumentSnapshot ds) {
                                    Map favs = ds['favorites'];
                                    Map<String, List<String>> currentInfo = {productId: [productId,img,name,type,cost,description,inst]};
                                    favs.addAll(currentInfo);
                                    print(favs);
                                    firestoreInstance
                                      .collection("users")
                                      .doc(firebaseUser.uid)
                                      .update({"favorites": favs}).then((_) {
                                        print("success!");
                                      });
                                  });
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    width: MediaQuery.of(context).size.width,
                    height: 500,
                    child: FadeAnimation(1.5,
                    Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.bottomRight,
                              colors: [
                                Colors.black.withOpacity(.9),
                                Colors.black.withOpacity(.0),
                              ]
                          )
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          FadeAnimation(1.3,
                              Text(
                                "$name",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 50,
                                    fontWeight: FontWeight.bold
                                ),
                              )
                          ),
                          SizedBox(height: 5,),
                          FadeAnimation(1.3,
                            InkWell(
                                child:Text(
                                  "Details",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                              onTap: (){
                                  displayBottomSheet(context: context, description: description);
                              },
                            ),
                          ),
                          SizedBox(height: 20,),
                          FadeAnimation(1.5,
                             Container(
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15)
                              ),
                              child: InkWell(
                                child:Center(
                                  child: Text('Buy', style: TextStyle(fontWeight: FontWeight.bold),)
                              ),
                                onTap: (){
                                  _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text('Moving to seller profile..',style: TextStyle(color: Colors.white),),backgroundColor: Colors.green,));
                                  _launchURL();
                                },
                            ),
                            ),
                          ),
                      SizedBox(height: 30,),
                        ],
                      ),
                    )),
                  )
                ],
              ),
            ),
          )
      ),
    );
  }
  void displayBottomSheet({BuildContext context, String description}) {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
       context: context,
       builder: (ctx) {
         return Container(
           decoration: BoxDecoration(
             color: Colors.black87,
             borderRadius: BorderRadius.only(topRight: Radius.circular(40), topLeft: Radius.circular(40),),
             border: Border.all(width: 3,color: Colors.black12, style: BorderStyle.solid),

           ),
                height: MediaQuery
                  .of(context)
                  .size
                  .height * 0.33,
                child: Padding(
                  padding: EdgeInsets.all(Paddings.getPadding(context, 0.02)),
                  child: Center(
                    child: ListView(
                        children:  [
                          Padding(
                            padding: EdgeInsets.all(Paddings.getPadding(context, 0.03)),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Center(
                                child:Text("Details",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                              ),
                            ),
                          ),
                      SingleChildScrollView(
                       child:Text("$description", style: TextStyle(color:Colors.white, ),),
                      ),
                        ],
                    ),
                  ),
                  ),
          );
        }
    );
  }
}



