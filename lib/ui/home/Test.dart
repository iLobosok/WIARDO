import 'dart:math';
import 'dart:ui';
import 'package:flutter_login_screen/animation/AnimationProfile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_login_screen/constants.dart';
import 'package:flutter_login_screen/model/User.dart';
import 'package:flutter_login_screen/services/Authenticate.dart';
import 'package:flutter_login_screen/ui/auth/AuthScreen.dart';



import '../../main.dart';
import '../../services/helper.dart';

class HomeScreenx extends StatefulWidget {
  final User user;

  HomeScreenx({Key key, @required this.user}) : super(key: key);

  @override
  State createState() {
    return _HomeState(user);
  }
}

class _HomeState extends State<HomeScreenx> {
  final User user;
  String imseller = 'Seller';
  _HomeState(this.user);
  @override
  Widget build(BuildContext context) {
    if ((user.seller) != true)
    {
      imseller = 'Buyer';
    }
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: <Widget>[
          CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                expandedHeight: 450,
                backgroundColor: Colors.black,
                flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.pin,
                  background: Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: NetworkImage('${user.profilePictureURL}'),
                            fit: BoxFit.cover
                        )
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.bottomRight,
                              colors: [
                                Colors.black,
                                Colors.black.withOpacity(.3)
                              ]
                          )
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            FadeAnimation(1, Text('${user.firstName} ${user.lastName}', style:
                            TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 40)
                              ,)),
                            SizedBox(height: 20,),
                            Row(
                              children: <Widget>[
                                FadeAnimation(1.2,
                                    Text('$imseller', style: TextStyle(color: Colors.grey, fontSize: 16),)
                                ),
                                SizedBox(width: 50,),
                                FadeAnimation(1.3, Text('${user.subs} Subscribers', style:
                                TextStyle(color: Colors.grey, fontSize: 16)
                                  ,))
                              ],
                            ),

                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildListDelegate([
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        FadeAnimation(1.6, Text('${user.bio}',
                          style: TextStyle(color: Colors.grey, height: 1.4),)),
                        SizedBox(height: 40,),
                        FadeAnimation(1.6,
                            Text("Profile ID", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),)
                        ),
                        SizedBox(height: 10,),
                        FadeAnimation(1.6,
                            InkWell(
                              onTap: () {Clipboard.setData(new ClipboardData(text: '${user.userID}'));},
                              child:Text('${user.userID}', style: TextStyle(color: Colors.grey),),)
                        ),
                        SizedBox(height: 120,)
                      ],
                    ),
                  )
                ]),
              )
            ],
          ),
          Positioned.fill(
            bottom: 50,
            child: Container(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: FadeAnimation(2,
                  InkWell(
                    onTap: ()
                    {
                      user.subs +=1;
                      int i =0;

                    },
                    child:Container(
                    margin: EdgeInsets.symmetric(horizontal: 30),
                    height: 50,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Colors.blueAccent
                    ),
                    child: Align(
                          child: Text("Follow",
                            style: TextStyle(color: Colors.white),
                    ),
                    ),
                  ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget makeVideo({image}) {
    return AspectRatio(
      aspectRatio: 1.5/ 1,
      child: Container(
        margin: EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            image: DecorationImage(
                image: AssetImage(image),
                fit: BoxFit.cover
            )
        ),
        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.bottomRight,
                  colors: [
                    Colors.black.withOpacity(.9),
                    Colors.black.withOpacity(.3)
                  ]
              )
          ),
          child: Align(
            child: Icon(Icons.play_arrow, color: Colors.white, size: 70,),
          ),
        ),
      ),
    );
  }
}
