// Project was initially copied from https://github.com/blackmann/story_view
// Copyright 2019 De-Great Yartey. All rights reserved.
// Copyright 2020 Awaik. All rights reserved.
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are
// met:
//
//    * Redistributions of source code must retain the above copyright
// notice, this list of conditions and the following disclaimer.
//    * Redistributions in binary form must reproduce the above
// copyright notice, this list of conditions and the following disclaimer
// in the documentation and/or other materials provided with the
// distribution.
//    * Neither the name of De-Great Yartey nor the names of its
// contributors may be used to endorse or promote products derived from
// this software without specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
// "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
// LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
// A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
// OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
// SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
// LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
// DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
// THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
// OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_login_screen/model/AddingProduct.dart';
import 'package:flutter_login_screen/model/Favourite.dart';
import 'package:flutter_login_screen/model/User.dart';
import 'package:flutter_login_screen/model/config.dart';
import 'package:flutter_login_screen/model/selfproducts.dart';
import 'package:flutter_login_screen/ui/ProductInfo/ProductInfo.dart';
import 'package:flutter_login_screen/ui/home/Test.dart';
import 'package:flutter_login_screen/database/Data.dart';
import 'package:flutter_login_screen/animation/FadeAnimation.dart';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/cupertino.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class VIPScreen extends StatefulWidget {
  final Users user;

  VIPScreen({Key key, @required this.user}) : super(key: key);

  @override
  State createState() {
    return _VIPState();
  }
}

class _VIPState extends State<VIPScreen> {

  var WidgetList = List<Widget>();
  List images_collection = [];
  List<Data> dataList = [
  ]; //тут будет список виджетов данных для виджетов, котрый создастся при чтении данных с бд
  DatabaseReference databaseReference = FirebaseDatabase.instance
      .reference(); // инициализация бд

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDataFromFirebaseAndBuildCarousel(1);
    //вызываем функцию, которая создаст список виджетов и отрисует их
  }
  @override
  Widget build(BuildContext context) {
    var getScreenHeight = MediaQuery.of(context).size.height;
    getDataFromFirebaseAndBuildCarousel(0);
    setState(() {});
    return Scaffold(
      backgroundColor: Color(0xFFFDFAF5),
      body:Stack(
        children: <Widget>[
      Center(
    child:CarouselSlider(
      options: CarouselOptions(
        height: getScreenHeight,
        viewportFraction: 1,
        enlargeCenterPage: true,
        initialPage: 0,
        autoPlay: true,
        reverse: false,
        enableInfiniteScroll: true,
        autoPlayInterval: Duration(seconds: 5),
        autoPlayAnimationDuration: Duration(
            milliseconds: 3000),
        scrollDirection: Axis.horizontal,
      ),
      items: images_collection.map((imgUrl) {
        return Builder(
          builder: (BuildContext context) {
            return Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: ClipRRect(
                child: FittedBox(
                fit: BoxFit.fill,
                child: Image.network(
                  imgUrl,
                  fit: BoxFit.cover,
                ),
                ),
              ),
            );
          },
        );
      }).toList(),
    ),),
          Positioned.fill(
            bottom: 50,
            child: Container(
              child: Align(
                alignment: Alignment.bottomCenter,
                child:FadeAnimation(1,
                  InkWell(
                    onTap: ()
                    {
                      _launchVIP();
                    },
                    child:Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      height: 50,
                      width: 200,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40),
                          color: Colors.green
                      ),
                      child: Align(
                        child: Text("Try VIP",
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
    ],
      ),
    );
  }
  void getDataFromFirebaseAndBuildCarousel(int d) {
    databaseReference.once().then((DataSnapshot snapshot) { //получаем данные
      var keys = snapshot.value['VIP'].keys; //получаем ключи
      var values = snapshot.value['VIP']; //получаем значения
      for (var key in keys) {
        images_collection.add(values[key]);
      }
      d==1 ? setState((){}) : print(d);
    }
    );
  }
  _launchVIP() async {
    const url = 'https://www.donationalerts.com/c/wiardo';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}

