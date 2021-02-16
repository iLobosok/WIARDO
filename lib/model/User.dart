import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class User {
  String email = '';
  String firstName = '';
  String bio = '';
  String lastName = '';
  String phoneNumber = '';
  bool active = false;
  int subs = 1;
  bool ban = false;
  Timestamp lastOnlineTimestamp = Timestamp.now();
  String userID;
  String profilePictureURL = '';
  bool selected = false;
  bool seller = false;
  String appIdentifier = '${Platform.operatingSystem}';

  User(
      {this.email,
      this.firstName,
        this.seller,
        this.subs,
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

  factory User.fromJson(Map<String, dynamic> parsedJson) {
    return new User(
        email: parsedJson['email'] ?? '',
        subs: parsedJson['subscribers'] ?? 0,
        seller: parsedJson['seller'] ?? false,
        firstName: parsedJson['firstName'] ?? '',
        lastName: parsedJson['lastName'] ?? '',
        bio: parsedJson['bio'] ?? '',
        active: parsedJson['active'] ?? false,
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