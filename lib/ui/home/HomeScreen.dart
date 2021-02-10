import 'dart:math';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_screen/constants.dart';
import 'package:flutter_login_screen/model/User.dart';
import 'package:flutter_login_screen/services/Authenticate.dart';
import 'package:flutter_login_screen/ui/auth/AuthScreen.dart';



import '../../main.dart';
import '../../services/helper.dart';

class HomeScreen extends StatefulWidget {
  final User user;

  HomeScreen({Key key, @required this.user}) : super(key: key);

  @override
  State createState() {
    return _HomeState(user);
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

class _HomeState extends State<HomeScreen> {
  final User user;
  String imseller = 'I\'m seller';
  _HomeState(this.user);
  @override
  Widget build(StatefulBuilder) {
    if ((user.seller) != true)
      {
        imseller = 'I\'m buyer';
      }
    return new Scaffold(
        body: new Stack(
          children: <Widget>[
            Positioned(
                width:  MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Column(
                  children: <Widget>[
                    Container(
                      height: 250,
                      width: double.maxFinite,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage('$image_to_print')),
                      ),
                      child: ClipRRect( // make sure we apply clip it properly
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                          child: Container(

                            child:Container(
                                width: 150.0,
                                height: 150.0,
                                decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    image: DecorationImage(
                                        image: NetworkImage(
                                            '${user.profilePictureURL}'),
                                        fit: BoxFit.cover),
                                    borderRadius: BorderRadius.all(Radius.circular(75.0)),
                                    boxShadow: [
                                      BoxShadow(blurRadius: 7.0, color: Colors.black)
                                    ])),
                            alignment: Alignment.center,
                            color: Colors.grey.withOpacity(0.1),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 45.0),
                    Text(
                      '${user.firstName} ${user.lastName}',
                      style: TextStyle(
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Montserrat'),
                    ),
                    Text(
                      '$imseller',
                      style: TextStyle(
                          fontSize: 17.0,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Montserrat'),
                    ),
                    SizedBox(height: 15.0),
                    Text(
                      '${user.bio}',
                      style: TextStyle(
                          fontSize: 17.0,
                          fontStyle: FontStyle.italic,
                          fontFamily: 'Montserrat'),
                    ),
                    SizedBox(height: 25.0),
                 Row(
                  children: <Widget>[
                    Container(
                        height: 30.0,
                        width: 95.0,
                        child: Material(
                          borderRadius: BorderRadius.circular(20.0),
                          shadowColor: Colors.redAccent,
                          color: Colors.red,
                          elevation: 7.0,
                          child: GestureDetector(
                            onTap: () {},
                            child: Center(
                              child:InkWell(
                              child: Text(
                                'Log out',
                                style: TextStyle(color: Colors.white, fontFamily: 'Montserrat'),
                              ),
                                onTap: () async {
                                  user.active = false;
                                  user.lastOnlineTimestamp = Timestamp.now();
                                  FireStoreUtils.updateCurrentUser(user);
                                  await auth.FirebaseAuth.instance.signOut();
                                  MyAppState.currentUser = null;
                                  pushAndRemoveUntil(context, AuthScreen(), false);
                                },
                              ),
                              ),
                            ),
                          ),
                        ),
                  ],
                 ),
                ],
          ),
            ),
          ],
        ));
  }
}

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    // TODO: implement shouldReclip
    return true;
  }


