/*MIT License

Copyright (c) 2019 Rein Gundersen Bentdal

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

/*

The MIT License (MIT)
Copyright (c) 2018 Felix Angelov

Permission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated documentation
files (the "Software"), to deal in the Software without restriction,
including without limitation the rights to use, copy, modify, merge,
publish, distribute, sublicense, and/or sell copies of the Software,
and to permit persons to whom the Software is furnished to do so,
subject to the following conditions:

The above copyright notice and this permission notice shall be included
in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE
USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

import 'dart:async';
import 'dart:math';
import 'package:confetti/confetti.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_picker/country_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart';
import 'package:styled_widget/styled_widget.dart';
import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter_login_screen/animation/AnimationProfile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_screen/model/Settings.dart';
import 'package:flutter_login_screen/model/VIP.dart';
import 'package:share/share.dart';
import 'package:flutter/services.dart';
import 'package:flutter_login_screen/model/User.dart';

class Stat extends StatefulWidget {
  final Users user;

  Stat({Key key, @required this.user}) : super(key: key);

  @override
  State createState() {
    return _HomeState(user);
  }
}

class _HomeState extends State<Stat> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final Users user;
  String imseller = 'Seller';
  _HomeState(this.user);
  String dropdownValue = 'Menu';
  @override
  Widget build(BuildContext context) {
    setState(() {
      user.VIP;
      user.birtday;
      user.country;
      user.MyItems.length;
    });
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(child: UserPage(user: user)),
      ),
    );
  }

  ConfettiController _controllerCenter;
  ConfettiController _controllerCenterRight;
  ConfettiController _controllerCenterLeft;
  ConfettiController _controllerTopCenter;
  ConfettiController _controllerBottomCenter;

  @override
  void initState() {
    _controllerCenter =
        ConfettiController(duration: const Duration(seconds: 10));
    _controllerCenterRight =
        ConfettiController(duration: const Duration(seconds: 10));
    _controllerCenterLeft =
        ConfettiController(duration: const Duration(seconds: 10));
    _controllerTopCenter =
        ConfettiController(duration: const Duration(seconds: 10));
    _controllerBottomCenter =
        ConfettiController(duration: const Duration(seconds: 10));
    super.initState();
  }

  @override
  void dispose() {
    _controllerCenter.dispose();
    _controllerCenterRight.dispose();
    _controllerCenterLeft.dispose();
    _controllerTopCenter.dispose();
    _controllerBottomCenter.dispose();
    super.dispose();
  }
}

class UserPage extends StatelessWidget {

  final Users user;
  const UserPage({Key key, this.user}) : super(key: key);
  @override

  Widget build(BuildContext context) {
    if (user.birtday == '02-05')
    {
      ConfettiController _controllerCenter;
      ConfettiController _controllerCenterRight;
      ConfettiController _controllerCenterLeft;
      ConfettiController _controllerTopCenter;
      ConfettiController _controllerBottomCenter;
      print('hp');
      _controllerCenter =
          ConfettiController(duration: const Duration(seconds: 10));
      _controllerCenterRight =
          ConfettiController(duration: const Duration(seconds: 10));
      _controllerCenterLeft =
          ConfettiController(duration: const Duration(seconds: 10));
      _controllerTopCenter =
          ConfettiController(duration: const Duration(seconds: 10));
      _controllerBottomCenter =
          ConfettiController(duration: const Duration(seconds: 10));
      Text _display(String text) {
        return Text(
          text,
          style: const TextStyle(color: Colors.white, fontSize: 20),
        );
      }
      Path drawStar(Size size) {
        // Method to convert degree to radians
        double degToRad(double deg) => deg * (pi / 180.0);

        const numberOfPoints = 5;
        final halfWidth = size.width / 2;
        final externalRadius = halfWidth;
        final internalRadius = halfWidth / 2.5;
        final degreesPerStep = degToRad(360 / numberOfPoints);
        final halfDegreesPerStep = degreesPerStep / 2;
        final path = Path();
        final fullAngle = degToRad(360);
        path.moveTo(size.width, halfWidth);

        for (double step = 0; step < fullAngle; step += degreesPerStep) {
          path.lineTo(halfWidth + externalRadius * cos(step),
              halfWidth + externalRadius * sin(step));
          path.lineTo(halfWidth + internalRadius * cos(step + halfDegreesPerStep),
              halfWidth + internalRadius * sin(step + halfDegreesPerStep));
        }
        path.close();
        return path;
      }

      @override
      Widget build(BuildContext context) {
        return Stack(
          children: <Widget>[
            //CENTER -- Blast
            Align(
              alignment: Alignment.center,
              child: ConfettiWidget(
                confettiController: _controllerCenter,
                blastDirectionality: BlastDirectionality
                    .explosive, // don't specify a direction, blast randomly
                shouldLoop:
                true, // start again as soon as the animation is finished
                colors: const [
                  Colors.green,
                  Colors.blue,
                  Colors.pink,
                  Colors.orange,
                  Colors.purple
                ], // manually specify the colors to be used
                createParticlePath: drawStar, // define a custom shape/path.
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: FlatButton(
                  onPressed: () {
                    _controllerCenter.play();
                  },
                  child: _display('blast\nstars')),
            ),

            //CENTER RIGHT -- Emit left
            Align(
              alignment: Alignment.centerRight,
              child: ConfettiWidget(
                confettiController: _controllerCenterRight,
                blastDirection: pi, // radial value - LEFT
                particleDrag: 0.05, // apply drag to the confetti
                emissionFrequency: 0.05, // how often it should emit
                numberOfParticles: 20, // number of particles to emit
                gravity: 0.05, // gravity - or fall speed
                shouldLoop: false,
                colors: const [
                  Colors.green,
                  Colors.blue,
                  Colors.pink
                ], // manually specify the colors to be used
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: FlatButton(
                  onPressed: () {
                    _controllerCenterRight.play();
                  },
                  child: _display('pump left')),
            ),

            //CENTER LEFT - Emit right
            Align(
              alignment: Alignment.centerLeft,
              child: ConfettiWidget(
                confettiController: _controllerCenterLeft,
                blastDirection: 0, // radial value - RIGHT
                emissionFrequency: 0.6,
                minimumSize: const Size(10,
                    10), // set the minimum potential size for the confetti (width, height)
                maximumSize: const Size(50,
                    50), // set the maximum potential size for the confetti (width, height)
                numberOfParticles: 1,
                gravity: 0.1,
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: FlatButton(
                  onPressed: () {
                    _controllerCenterLeft.play();
                  },
                  child: _display('singles')),
            ),

            //TOP CENTER - shoot down
            Align(
              alignment: Alignment.topCenter,
              child: ConfettiWidget(
                confettiController: _controllerTopCenter,
                blastDirection: pi / 2,
                maxBlastForce: 5, // set a lower max blast force
                minBlastForce: 2, // set a lower min blast force
                emissionFrequency: 0.05,
                numberOfParticles: 50, // a lot of particles at once
                gravity: 1,
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: FlatButton(
                  onPressed: () {
                    _controllerTopCenter.play();
                  },
                  child: _display('goliath')),
            ),
            //BOTTOM CENTER
            Align(
              alignment: Alignment.bottomCenter,
              child: ConfettiWidget(
                confettiController: _controllerBottomCenter,
                blastDirection: -pi / 2,
                emissionFrequency: 0.01,
                numberOfParticles: 20,
                maxBlastForce: 100,
                minBlastForce: 80,
                gravity: 0.3,
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: FlatButton(
                  onPressed: () {
                    _controllerBottomCenter.play();
                  },
                  child: _display('hard and infrequent')),
            ),
          ],
        );
      }
    }
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('dd-mm').format(now);
    print(formattedDate);

    final page = ({Widget child}) => Styled.widget(child: child)
        .padding(vertical: 30, horizontal: 20)
        .constrained(minHeight: MediaQuery.of(context).size.height - (2 * 30))
        .scrollable();

    return <Widget>[

      Text(
        'Statistics',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
      ).alignment(Alignment.center).padding(bottom: 20),
      UserCard(user: user),
      ActionsRow(user: user),
      Settings(),
    ].toColumn().parent(page);
  }
}

class UserCard extends StatelessWidget {
  final Users user;
  const UserCard({Key key, this.user}) : super(key: key);
  Widget _buildUserRow() {
    return <Widget>[
      SizedBox(
          height: 40,
          width: 40,
          child: ( (user.profilePictureURL) != '' || (user.profilePictureURL) != null ) ? CircleAvatar(
            //circle avatar
            radius: 30.0,
            backgroundImage: NetworkImage('${user.profilePictureURL}'),
            backgroundColor: Colors.transparent,
          ) : Icon(Icons.account_circle)
              .decorated(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
          )
              .constrained(height: 50, width: 50)
              .padding(right: 10)
      ),
      <Widget>[
        SizedBox(width: 10,),
        Text(
          '${user.firstName} ${user.lastName}',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ).padding(bottom: 5),
        Text(
          'Seller',
          style: TextStyle(
            color: Colors.white.withOpacity(0.6),
            fontSize: 12,
          ),
        ),
      ].toColumn(crossAxisAlignment: CrossAxisAlignment.start),
    ].toRow();
  }

  Widget _buildUserStats() {
    return <Widget>[
      _buildUserStatsItem('${user.subs}', 'Followers'),
      _buildUserStatsItem('${user.MyItems.length}', 'Goods'),
      _buildUserStatsItem('${user.VIP}', 'VIP'),
    ]
        .toRow(mainAxisAlignment: MainAxisAlignment.spaceAround)
        .padding(vertical: 10);
  }

  Widget _buildUserStatsItem(String value, String text) => <Widget>[
    Text(value).fontSize(20).textColor(Colors.white).padding(bottom: 5),
    Text(text).textColor(Colors.white.withOpacity(0.6)).fontSize(12),
  ].toColumn();

  @override
  Widget build(BuildContext context) {
    return <Widget>[_buildUserRow(), _buildUserStats()]
        .toColumn(mainAxisAlignment: MainAxisAlignment.spaceAround)
        .padding(horizontal: 20, vertical: 10)
        .decorated(
        color: Color(0xff3977ff), borderRadius: BorderRadius.circular(20))
        .elevation(
      5,
      shadowColor: Color(0xff3977ff),
      borderRadius: BorderRadius.circular(20),
    )
        .height(175)
        .alignment(Alignment.center);
  }
}

class ActionsRow extends StatelessWidget {
  final firestoreInstance = FirebaseFirestore.instance;
  final Users user;
   ActionsRow({Key key, this.user}) : super(key: key);
  Widget _buildActionItem(String name, IconData icon) {
    final Widget actionIcon = Icon(icon, size: 20, color: Color(0xFF42526F))
        .alignment(Alignment.center)
        .ripple()
        .constrained(width: 50, height: 50)
        .backgroundColor(Color(0xfff6f5f8))
        .clipOval()
        .padding(bottom: 5);

    final Widget actionText = Text(
      name,
      style: TextStyle(
        color: Colors.black.withOpacity(0.8),
        fontSize: 12,
      ),
    );

    return <Widget>[
      actionIcon,
      actionText,
    ].toColumn().padding(vertical: 20);
  }

  @override
  Widget build(BuildContext context) => <Widget>[
   user.country != "" ? _buildActionItem('${user.country}', Icons.public) : InkWell(child:_buildActionItem('Country', Icons.public),
    onTap:()
    {
      showCountryPicker(
        context: context,
        showPhoneCode: false,
        onSelect: (Country country) => user.country = '${country.displayName}',
      );
    },),
   user.birtday == "" ? InkWell(
     onTap: () async {
         var datePicked = await DatePicker.showSimpleDatePicker(
           context,
           // initialDate: DateTime(1994),
           firstDate: DateTime(1960),
           // lastDate: DateTime(2012),
           dateFormat: "dd-MMMM",
           locale: DateTimePickerLocale.en_us,
           looping: true,

         );
         print(datePicked.day);
         user.birtday = '${datePicked.day}-${datePicked.month}';
         var firebaseUser = FirebaseAuth.instance.currentUser;
         String datebir = '${datePicked.day}-${datePicked.month}';
         firestoreInstance
             .collection("users")
             .doc(firebaseUser.uid)
             .update({"birthday": datebir})
             .then((_) {});
         firestoreInstance
             .collection("users")
             .doc(firebaseUser.uid)
             .update({"country": user.country})
             .then((_) {});
     },
     child: _buildActionItem('Age', Icons.cake),
   ) : _buildActionItem('${user.birtday}', Icons.celebration,),
    _buildActionItem('Verification',  Icons.fact_check),
    _buildActionItem('Support', Icons.help),
  ].toRow(mainAxisAlignment: MainAxisAlignment.spaceAround);
}

class SettingsItemModel {
  final IconData icon;
  final Color color;
  final String title;
  final String description;
  const SettingsItemModel({
    @required this.color,
    @required this.description,
    @required this.icon,
    @required this.title,
  });
}

const List<SettingsItemModel> settingsItems = [
  SettingsItemModel(
    icon: Icons.location_on,
    color: Color(0xff8D7AEE),
    title: 'Address',
    description: 'Ensure your harvesting address',
  ),
  SettingsItemModel(
    icon: Icons.lock,
    color: Color(0xffF468B7),
    title: 'Privacy',
    description: 'System permission change',
  ),
  SettingsItemModel(
    icon: Icons.notifications,
    color: Color(0xff5FD0D3),
    title: 'Notifications',
    description: 'Take over the news in time',
  ),
  SettingsItemModel(
    icon: Icons.question_answer,
    color: Color(0xffBFACAA),
    title: 'Support',
    description: 'We are here to help',
  ),
];

class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) => settingsItems
      .map((settingsItem) => SettingsItem(
    settingsItem.icon,
    settingsItem.color,
    settingsItem.title,
    settingsItem.description,
  ))
      .toList()
      .toColumn();
}

class SettingsItem extends StatefulWidget {
  SettingsItem(this.icon, this.iconBgColor, this.title, this.description);

  final IconData icon;
  final Color iconBgColor;
  final String title;
  final String description;

  @override
  _SettingsItemState createState() => _SettingsItemState();
}

class _SettingsItemState extends State<SettingsItem> {
  bool pressed = false;

  @override
  Widget build(BuildContext context) {
    final settingsItem = ({Widget child}) => Styled.widget(child: child)
        .alignment(Alignment.center)
        .borderRadius(all: 15)
        .ripple()
        .backgroundColor(Colors.white, animate: true)
        .clipRRect(all: 25) // clip ripple
        .borderRadius(all: 25, animate: true)
        .elevation(
      pressed ? 0 : 20,
      borderRadius: BorderRadius.circular(25),
      shadowColor: Color(0x30000000),
    ) // shadow borderRadius
        .constrained(height: 80)
        .padding(vertical: 12) // margin
        .gestures(
      onTapChange: (tapStatus) => setState(() => pressed = tapStatus),
      onTapDown: (details) => print('tapDown'),
      onTap: () {
        showCountryPicker(
          context: context,
          showPhoneCode: false,
          onSelect: (Country country) => print('Select country: ${country.displayName}'),
        );
      },
    )

        .animate(Duration(milliseconds: 150), Curves.easeOut);

    final Widget icon = Icon(widget.icon, size: 20, color: Colors.white)
        .padding(all: 12)
        .decorated(
      color: widget.iconBgColor,
      borderRadius: BorderRadius.circular(30),
    )
        .padding(left: 15, right: 10);

    final Widget title = Text(
      widget.title,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 16,
      ),
    ).padding(bottom: 5);

    final Widget description = Text(
      widget.description,
      style: TextStyle(
        color: Colors.black26,
        fontWeight: FontWeight.bold,
        fontSize: 12,
      ),
    );

    return settingsItem(
      child: <Widget>[
        icon,
        <Widget>[
          title,
          description,
        ].toColumn(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
      ].toRow(),
    );
  }
}