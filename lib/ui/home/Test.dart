/*Copyright 2017, the Flutter project authors. All rights reserved.

Redistribution and use in source and binary forms, with or without modification,
are permitted provided that the following conditions are met:

    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above
      copyright notice, this list of conditions and the following
      disclaimer in the documentation and/or other materials provided
      with the distribution.
    * Neither the name of Google Inc. nor the names of its
      contributors may be used to endorse or promote products derived
      from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.*/

import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:flutter_login_screen/animation/AnimationProfile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_screen/model/Settings.dart';
import 'package:flutter_login_screen/model/VIP.dart';
import 'package:share/share.dart';
import 'package:flutter/services.dart';
import 'package:flutter_login_screen/model/User.dart';

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


class HomeScreenx extends StatefulWidget {
  final Users user;

  HomeScreenx({Key key, @required this.user}) : super(key: key);

  @override
  State createState() {
    return _HomeState(user);
  }
}

class _HomeState extends State<HomeScreenx> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final Users user;
  String imseller = 'Seller';
  _HomeState(this.user);
  String dropdownValue = 'Menu';
  @override
  Widget build(BuildContext context) {
    setState(() {
      user.VIP;
      user.seller;
      print('${user.VIP}');
    });
    if ((user.seller) != true)
    {
      imseller = 'Buyer';
    }
    if (user.profilePictureURL == null || user.profilePictureURL == '') {
      user.profilePictureURL = image_to_print;
    }
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.black,
      body: Stack(
        children: <Widget>[
          CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                expandedHeight: 400,
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
                            Row(
                              children: <Widget>[
                                FadeAnimation(1, Text('${user.firstName} ${user.lastName}', style:
                                TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 40),)),
                                SizedBox(width: 10,),
                                  FadeAnimation(1, user.VIP == true ? Image.asset(
                                  'assets/images/verificated.png',
                                  fit: BoxFit.fill,
                                  height: 25,
                                  width: 25,

                                ) : null),
                              ],
                            ),
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
                            Column(
                              children: <Widget>[
                            Row(
                            children: <Widget>[
                            Text("Profile ID", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),),
                            SizedBox(width: 200,),
                              user.VIP == true ? ElevatedButton(
                                  child: Text(
                                      "Try VIP".toUpperCase(),
                                      style: TextStyle(fontSize: 14, color: Colors.white)
                                  ),
                                  style: ElevatedButton.styleFrom(shape: new RoundedRectangleBorder(
                                    borderRadius: new BorderRadius.circular(30.0),
                                  ),),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) =>
                                            VIPScreen(user: user,)));
                                  }
                              ) : Text('VIP', style: TextStyle(color:Colors.transparent),),
                            ],),],),),
                        SizedBox(height: 10,),
                        FadeAnimation(1.6,
                            InkWell(
                              onTap: () {
                                Clipboard.setData(new ClipboardData(text: '${user.userID}'));
                                var scaffoldKey = _scaffoldKey;
                                scaffoldKey.currentState.showSnackBar(SnackBar(content: Text('Copied!',style: TextStyle(color: Colors.white),),backgroundColor: Colors.green,));
                              },
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
         /* Positioned.fill(
            bottom: 50,
            child: Container(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: user.seller == true ? FadeAnimation(2,
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
                ) : null,
              ),
            ),
          )*/
        ],
      ),
    );
  }
}
