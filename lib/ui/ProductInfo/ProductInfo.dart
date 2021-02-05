import 'package:flutter_login_screen/animation/FadeAnimation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_screen/ui/Shop.dart';
class ProductInformation extends StatefulWidget {

  @override
  ProductInfo createState() => ProductInfo();
}

class ProductInfo extends State<ProductInformation> {

bool _isFavorite = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          child: Hero(
            tag: 'red',
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: double.infinity,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage('https://firebasestorage.googleapis.com/v0/b/chat-b43aa.appspot.com/o/images%2Fid-0xiGjOHeZwfHJNxCHJJMtryEZjp2%2Fhash-29503656?alt=media&token=a030a049-f6b3-4b87-ae6d-449bd917fd11'),
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
                          FadeAnimation(1.3, Text("Night cow", style: TextStyle(color: Colors.white, fontSize: 50, fontWeight: FontWeight.bold),)),
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
                                Scaffold.of(context).showSnackBar(
                                    SnackBar(content: Text('Successfully Added',style: TextStyle(color: Colors.white),),backgroundColor: Colors.green,)
                                );
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