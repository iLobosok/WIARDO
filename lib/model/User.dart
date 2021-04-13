import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';


class Users {
  String email = '';
  String firstName = '';
  String bio = '';
  List favorites = [];
  List MyItems = [];
  String lastName = '';
  String phoneNumber = '';
  bool active = false;
  int subs = 1;
  bool ban = false;
  bool VIP = false;
  Timestamp lastOnlineTimestamp = Timestamp.now();
  String userID;
  String profilePictureURL = '';
  String insta;
  bool selected = false;
  bool seller = false;
  String appIdentifier = '${Platform.operatingSystem}';

  Users(
      {this.email,
      this.firstName,
        this.seller,
        this.subs,
        this.insta,
        this.MyItems,
        this.VIP,
        this.favorites,
      this.bio,
      this.phoneNumber,
      this.lastName,
      this.ban,
      this.active,
      this.lastOnlineTimestamp,
      this.userID,
      this.profilePictureURL});


  String fullName() {
    return '$firstName $lastName';
  }

  factory Users.fromJson(Map<String, dynamic> parsedJson) {
    return new Users(
        email: parsedJson['email'] ?? '',
        subs: parsedJson['subscribers'] ?? 0,
        seller: parsedJson['seller'] ?? false,
        firstName: parsedJson['firstName'] ?? '',
        lastName: parsedJson['lastName'] ?? '',
        bio: parsedJson['bio'] ?? '',
        insta: parsedJson['instagram'] ?? '',
        VIP: parsedJson['vip'] ?? false,
        active: parsedJson['active'] ?? false,
        favorites: parsedJson['favorites'] ?? {},
        MyItems: parsedJson['MyItems'] ?? {},
        ban: parsedJson['banned'] ?? false,
        lastOnlineTimestamp: parsedJson['lastOnlineTimestamp'],
        phoneNumber: parsedJson['phoneNumber'] ?? '',
        userID: parsedJson['id'] ?? parsedJson['userID'] ?? '',
        profilePictureURL: parsedJson['profilePictureURL'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {
      'bio' : this.bio,
      'email': this.email,
      'subcribers' : this.subs,
      'seller': this.seller,
      'instagram' : this.insta,
      'favorites': this.favorites,
      'vip' : this.VIP,
      'MyItems' : this.MyItems,
      'firstName': this.firstName,
      'lastName': this.lastName,
      'phoneNumber': this.phoneNumber,
      'id': this.userID,
      'active': this.active,
      'banned': this.ban,
      'lastOnlineTimestamp': this.lastOnlineTimestamp,
      'profilePictureURL': this.profilePictureURL,
      'appIdentifier': this.appIdentifier
    };
  }
}