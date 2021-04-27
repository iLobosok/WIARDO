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

import 'dart:async';
import 'dart:math';
import 'package:country_picker/country_picker.dart';
import 'package:styled_widget/styled_widget.dart';
import 'dart:ui';
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
      user.MyItems.length;
    });
    return MaterialApp(
      home: Scaffold(
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
      ActionsRow(),
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
    _buildActionItem('Wallet', Icons.attach_money),
    _buildActionItem('Delivery', Icons.card_giftcard),
    _buildActionItem('Message', Icons.message),
    _buildActionItem('Service', Icons.room_service),
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