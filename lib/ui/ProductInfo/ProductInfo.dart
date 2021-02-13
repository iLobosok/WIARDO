import 'package:flutter_login_screen/animation/FadeAnimation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_screen/ui/Shop.dart';
class ProductInformation extends StatefulWidget {

  final img;
  final name;
  @override
  const ProductInformation({Key key, this.img, this.name}) : super(key: key);
  ProductInfo createState() => ProductInfo(img: img, name: name);
}

class ProductInfo extends State<ProductInformation> {
final _scaffoldKey = GlobalKey<ScaffoldState>();
final img;
final name;
ProductInfo({this.img,this.name});

bool _isFavorite = false;
  @override
  Widget build(BuildContext context) {
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
                         SizedBox(height: 10,),
                        InkWell(
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
                            ),
                          ),
                        ),
                          onTap: (){
                            _isFavorite = !_isFavorite;
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
                    child: FadeAnimation(1, Container(
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
                          FadeAnimation(1.3, Text("$name", style: TextStyle(color: Colors.white, fontSize: 50, fontWeight: FontWeight.bold),)),
                          SizedBox(height: 5,),
                          FadeAnimation(1.3, InkWell(child:Text("Details", style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),)),),
                          SizedBox(height: 20,),
                          FadeAnimation(1.5, Container(
                            height: 50,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15)
                            ),
                            child: InkWell(
                              child:Center(
                                child: Text('Add to cart', style: TextStyle(fontWeight: FontWeight.bold),)
                            ),
                              onTap: (){
                                _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text('Successfully Added',style: TextStyle(color: Colors.white),),backgroundColor: Colors.green,));
                              },
                            ),
                          )),
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
}