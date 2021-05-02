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

import 'package:confetti/confetti.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_picker/country_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart';
import 'package:styled_widget/styled_widget.dart';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
  ConfettiController _controllerCenter;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final Users user;
  String imseller = 'Seller';

  _HomeState(this.user);

  String dropdownValue = 'Menu';
  @override
  void initState() {
    _controllerCenter = ConfettiController(duration: const Duration(seconds: 10));
    _controllerCenter.play();
    super.initState();
  }

  @override
  void dispose() {
    _controllerCenter.dispose();
    super.dispose();
  }

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
        backgroundColor: Colors.grey[900],
        body: SafeArea(child: UserPage(user: user)),
      ),
    );
  }
}

class UserPage extends StatelessWidget {

  final Users user;
  const UserPage({Key key, this.user}) : super(key: key);
  @override

  Widget build(BuildContext context) {

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
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32, color: Colors.white),
      ).alignment(Alignment.center).padding(bottom: 20),
      UserCard(user: user),
      ActionsRow(user: user),
      Statistics(user: user),
    ].toColumn().parent(page);
  }
}

class Statistics extends StatelessWidget{
  final Users user;
  List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];

  Statistics({Key key, this.user}) : super(key: key);

  @override

  Widget build(BuildContext context) {

    SizedBox(height: 100,);
    bool showAvg = false;
    int touchedIndex;
    return SingleChildScrollView(
    child:Stack(
      children: <Widget>[
        AspectRatio(

          aspectRatio: 1.70,
          child: Container(
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(18),
                ),
                color: Color(0xff232d37)),
            child: Padding(
              padding: const EdgeInsets.only(right: 18.0, left: 12.0, top: 24, bottom: 12),
              child: LineChart(
                showAvg ? avgData() : mainData(),
              ),
            ),
          ),
        ),
        SizedBox(height: 100,),

      ],
    ),
    );
  }

  LineChartData mainData() {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          getTextStyles: (value) =>
          const TextStyle(color: Color(0xff68737d), fontWeight: FontWeight.bold, fontSize: 16),
          getTitles: (value) {
            switch (value.toInt()) {
              case 2:
                return 'MAR';
              case 5:
                return 'JUN';
              case 8:
                return 'SEP';
            }
            return '';
          },
          margin: 8,
        ),
        leftTitles: SideTitles(
          showTitles: true,
          getTextStyles: (value) => const TextStyle(
            color: Color(0xff67727d),
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
          getTitles: (value) {
            switch (value.toInt()) {
              case 1:
                return '10k';
              case 3:
                return '30k';
              case 5:
                return '50k';
            }
            return '';
          },
          reservedSize: 28,
          margin: 12,
        ),
      ),
      borderData:
      FlBorderData(show: true, border: Border.all(color: const Color(0xff37434d), width: 1)),
      minX: 0,
      maxX: 11,
      minY: 0,
      maxY: 6,
      lineBarsData: [
        LineChartBarData(
          spots: [
            FlSpot(0, 3),
            FlSpot(2.6, 2),
            FlSpot(4.9, 5),
            FlSpot(6.8, 3.1),
            FlSpot(8, 4),
            FlSpot(9.5, 3),
            FlSpot(11, 4),
          ],
          isCurved: true,
          colors: gradientColors,
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            colors: gradientColors.map((color) => color.withOpacity(0.3)).toList(),
          ),
        ),
      ],
    );
  }

  LineChartData avgData() {
    return LineChartData(
      lineTouchData: LineTouchData(enabled: false),
      gridData: FlGridData(
        show: true,
        drawHorizontalLine: true,
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          getTextStyles: (value) =>
          const TextStyle(color: Color(0xff68737d), fontWeight: FontWeight.bold, fontSize: 16),
          getTitles: (value) {
            switch (value.toInt()) {
              case 2:
                return 'MAR';
              case 5:
                return 'JUN';
              case 8:
                return 'SEP';
            }
            return '';
          },
          margin: 8,
        ),
        leftTitles: SideTitles(
          showTitles: true,
          getTextStyles: (value) => const TextStyle(
            color: Color(0xff67727d),
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
          getTitles: (value) {
            switch (value.toInt()) {
              case 1:
                return '10k';
              case 3:
                return '30k';
              case 5:
                return '50k';
            }
            return '';
          },
          reservedSize: 28,
          margin: 12,
        ),
      ),
      borderData:
      FlBorderData(show: true, border: Border.all(color: const Color(0xff37434d), width: 1)),
      minX: 0,
      maxX: 11,
      minY: 0,
      maxY: 6,
      lineBarsData: [
        LineChartBarData(
          spots: [
            FlSpot(0, 3.44),
            FlSpot(2.6, 3.44),
            FlSpot(4.9, 3.44),
            FlSpot(6.8, 3.44),
            FlSpot(8, 3.44),
            FlSpot(9.5, 3.44),
            FlSpot(11, 3.44),
          ],
          isCurved: true,
          colors: [
            ColorTween(begin: gradientColors[0], end: gradientColors[1]).lerp(0.2),
            ColorTween(begin: gradientColors[0], end: gradientColors[1]).lerp(0.2),
          ],
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(show: true, colors: [
            ColorTween(begin: gradientColors[0], end: gradientColors[1]).lerp(0.2).withOpacity(0.1),
            ColorTween(begin: gradientColors[0], end: gradientColors[1]).lerp(0.2).withOpacity(0.1),
          ]),
        ),
      ],
    );
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
      SizedBox(width: 10,),
      <Widget>[
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
    final Widget actionIcon = Icon(icon, size: 20, color: Colors.white)
        .alignment(Alignment.center)
        .ripple()
        .constrained(width: 50, height: 50)
        .backgroundColor(Color(0xff232d37))
        .clipOval()
        .padding(bottom: 5);

    final Widget actionText = Text(
      name,
      style: TextStyle(
        color: Colors.white,
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
      var firebaseUser = FirebaseAuth.instance.currentUser;
      showCountryPicker(
        context: context,
        showPhoneCode: false,
        onSelect: (Country country) {
          print('Select country: ${country.displayName}');
          String count = '${country.displayNameNoCountryCode}';
          String result = count.substring(0, count.indexOf(' ')); //delete everything after country name
          user.country = '$result';
          print(result);
        },
         );
      firestoreInstance
          .collection("users")
          .doc(firebaseUser.uid)
          .update({"country": user.country})
          .then((_) {});
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
     },
     child: _buildActionItem('Age', Icons.cake),
   ) : _buildActionItem('${user.birtday}', Icons.celebration,),
    _buildActionItem('Verification',  Icons.fact_check),
    _buildActionItem('Support', Icons.help),
  ].toRow(mainAxisAlignment: MainAxisAlignment.spaceAround);
}
