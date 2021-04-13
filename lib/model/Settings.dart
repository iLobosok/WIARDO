import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_screen/model/item_card.dart';
import 'package:flutter_login_screen/ui/auth/AuthScreen.dart';
import 'User.dart';

class SettingsPage extends StatelessWidget {
  final Users user;

  SettingsPage({Key key, @required this.user}) : super(key: key);


  Widget _arrow() {
    return Icon(
      Icons.edit,
      size: 20.0,
      color: Colors.white,
    );
  }
  Widget _leave() {
    return Icon(
      Icons.exit_to_app,
      size: 20.0,
      color: Colors.red,
    );
  }
  Widget _VIP() {
    return Icon(
      Icons.stars,
      size: 20.0,
      color: Colors.white,
    );
  }

  Widget _pic() {
    return Icon(
      Icons.photo,
      color:Colors.white,
      size: 20.0,
    );
  }


  @override
  Widget build(BuildContext context) {

    var brightness = MediaQuery.of(context).platformBrightness;
    TextEditingController emailController = new TextEditingController();
    TextEditingController idController = new TextEditingController();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        title: Text(
          'Settings',
          style: TextStyle(
              fontWeight: FontWeight.bold
          ),
        ),
      ),
      body: Container(
        color: (brightness == Brightness.dark) ? Color(0xFFF7F7F7) : Colors.grey[900],
        child: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Container(
                color: (brightness == Brightness.dark) ? Color(0xFFF7F7F7) : Colors.grey[900],
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ItemCard(
                      title: '${user.fullName()}',
                      textColor: Colors.white,
                      color: (brightness == Brightness.dark) ? Colors.white : Colors.grey[900],
                      rightWidget: null,
                      callback: () {
                      },
                    ),
                    SizedBox(
                      height: 50,
                    ),
                  Row(
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.only(left: 20.0, right: 20.0),
                        height: 20,
                      width: 200,
                      child:TextField(
                        controller: emailController,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Change Email (${user.email})",
                            hintStyle: TextStyle(color: Colors.grey, fontSize: 15)),
                      ),
                      ),
                      SizedBox(width: 120,),
                    InkWell(
                      onTap: (){
                        if (emailController.text.length != 0)
                          {
                            user.email = emailController.text;
                          }
                      },
                      child:Icon(Icons.check,
                    color: Colors.green,
                    size: 25,),
                    ),
                    ],),
                    // ItemCard(
                    //   title: 'Change Email (${user.email})',
                    //   textColor: Colors.white,
                    //   color: (brightness == Brightness.dark) ? Colors.white : Colors.grey[900],
                    //   rightWidget: _arrow(),
                    //   callback: () {
                    //     print('Tap Settings Item 02');
                    //   },
                    // ),
                    ItemCard(
                      title: 'Change Picture',

                      textColor: Colors.white,
                      color: (brightness == Brightness.dark) ? Colors.white : Colors.grey[900],
                      rightWidget: _pic(),
                      callback: () {
                        print('Tap Settings Item 03');
                      },
                    ),
                    ItemCard(
                      title: 'Change ID (${user.userID})',

                      textColor: Colors.white,
                      color: (brightness == Brightness.dark) ? Colors.white : Colors.grey[900],
                      rightWidget: _arrow(),
                      callback: () {
                        print('Tap Settings Item 04');
                      },
                    ),
                    ItemCard(
                      title: 'Try VIP',

                      textColor: Colors.white,
                      color: (brightness == Brightness.dark) ? Colors.white : Colors.grey[900],
                      rightWidget: _VIP(),
                      callback: () {
                        print('Tap Settings Item 06');
                      },
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    InkWell(
                      onTap: () async {
                        Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) =>
                                AuthScreen()));
                        await FirebaseAuth.instance.signOut();
                      },
                    child:ItemCard(
                      title: 'Log Out',
                      rightWidget: _leave(),
                      color: (brightness == Brightness.dark) ? Colors.white  : Colors.grey[900],
                      textColor: Colors.red,
                    ),
                    ),
                    SizedBox(
                      height: 100,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}