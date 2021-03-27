import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_login_screen/ui/Shop.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_login_screen/model/User.dart';
import 'package:flutter_login_screen/services/Authenticate.dart';
import 'package:flutter_login_screen/ui/home/Test.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';



import '../../constants.dart' as Constants;
import '../../main.dart';
import '../../services/helper.dart';
import '../Shop.dart';

final _fireStoreUtils = FireStoreUtils();

class LoginScreen extends StatefulWidget {
  @override
  State createState() {
    return _LoginScreen();
  }
}

class _LoginScreen extends State<LoginScreen> {
  GlobalKey<FormState> _key = new GlobalKey();
  AutovalidateMode _validate = AutovalidateMode.disabled;
  String email = '', password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],

      body: Form(
        key: _key,
        autovalidateMode: _validate,
        child: ListView(
          children: <Widget>[
            Padding(
              padding:
                  const EdgeInsets.only(top: 32.0, right: 16.0, left: 16.0),
              child: Center(
                child:Text(
                'Welcome back!',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold),
              ),
              ),
            ),
            Center(
              child: Lottie.network(
                //Lottie
                'https://assets4.lottiefiles.com/packages/lf20_nqB8Mn.json',
                width: 320,
                repeat: true,
                height: 320,
                fit: BoxFit.fill,
              ),
            ),
            ConstrainedBox(
              constraints: BoxConstraints(minWidth: double.infinity),
              child: Padding(
                padding:
                    const EdgeInsets.only(top: 32.0, right: 24.0, left: 24.0),
                child: TextFormField(
                  style: TextStyle(color: Colors.white,fontSize: 18.0),
                    textAlignVertical: TextAlignVertical.center,
                    textInputAction: TextInputAction.next,
                    validator: validateEmail,
                    onSaved: (String val) {
                      email = val;
                    },
                    onFieldSubmitted: (_) =>
                        FocusScope.of(context).nextFocus(),
                    keyboardType: TextInputType.emailAddress,
                    cursorColor: Color(Constants.COLOR_PRIMARY),
                    decoration: InputDecoration(
                        contentPadding:
                            new EdgeInsets.only(left: 16, right: 16),
                        fillColor: Colors.white,
                        hintText: 'Email',
                        hintStyle: TextStyle(color:Colors.white),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide: BorderSide(
                                color: Color(Constants.COLOR_PRIMARY),
                                width: 2.0)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ))),
              ),
            ),
            ConstrainedBox(
              constraints: BoxConstraints(minWidth: double.infinity),
              child: Padding(
                padding:
                    const EdgeInsets.only(top: 32.0, right: 24.0, left: 24.0),
                child: TextFormField(
                    style: TextStyle(color: Colors.white,fontSize: 18.0),
                    textAlignVertical: TextAlignVertical.center,
                    validator: validatePassword,
                    onSaved: (String val) {
                      password = val;
                    },
                    onFieldSubmitted: (password) async {
                      await login();
                    },
                    obscureText: true,
                    textInputAction: TextInputAction.done,
                    cursorColor: Color(Constants.COLOR_PRIMARY),
                    decoration: InputDecoration(
                        contentPadding:
                            new EdgeInsets.only(left: 16, right: 16),
                        fillColor: Colors.white,
                        hintText: 'Password',
                        hintStyle: TextStyle(color:Colors.white),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide: BorderSide(
                                color: Color(Constants.COLOR_PRIMARY),
                                width: 2.0)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ))),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(right: 40.0, left: 40.0, top: 40),
              child: ConstrainedBox(

                constraints: const BoxConstraints(minWidth: double.infinity),
                child: RaisedButton(
                  color: Color(0xFF5DB075),
                  child: Text(
                    'Log In',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  textColor: Colors.white,
                  splashColor: Color(Constants.COLOR_PRIMARY),
                  onPressed: () async {
                    await login();
                  },
                  padding: EdgeInsets.only(top: 12, bottom: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  login() async {
    if (_key.currentState.validate()) {
      _key.currentState.save();
      showProgress(context, 'Logging in, please wait...', false);
      Users user = await loginWithUserNameAndPassword();
      if (user != null && user.ban != true)
        pushAndRemoveUntil(context, Shop(user: user), false);
            //HomeScreen(user: user), false);
    } else {
      setState(() {
        _validate = AutovalidateMode.onUserInteraction;
      });
    }
  }

  Future<Users> loginWithUserNameAndPassword() async {
    try {
      auth.UserCredential result = await auth.FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: email.trim(), password: password.trim());
      DocumentSnapshot documentSnapshot = await FireStoreUtils.firestore
          .collection(Constants.USERS)
          .doc(result.user.uid)
          .get();
      Users user;
      if (documentSnapshot != null && documentSnapshot.exists) {
        user = Users.fromJson(documentSnapshot.data());
        user.active = true;
        await FireStoreUtils.updateCurrentUser(user);
        hideProgress();
        MyAppState.currentUser = user;
      }
      return user;
    } on auth.FirebaseAuthException catch (exception) {
      hideProgress();
      switch ((exception).code) {
        case "invalid-email":
          showAlertDialog(context, 'Couldn\'t Authenticate', 'malformedEmail');
          break;
        case "wrong-password":
          showAlertDialog(context, 'Couldn\'t Authenticate', 'Wrong password');
          break;
        case "user-not-found":
          showAlertDialog(context, 'Couldn\'t Authenticate',
              'No user corresponds to this email');
          break;
        case "user-disabled":
          showAlertDialog(
              context, 'Couldn\'t Authenticate', 'This user is disabled');
          break;
        case 'too-many-requests':
          showAlertDialog(context, 'Couldn\'t Authenticate',
              'Too many requests, Please try again later.');
          break;
      }
      print(exception.toString());
      return null;
    } catch (e) {
      hideProgress();
      showAlertDialog(
          context, 'Couldn\'t Authenticate', 'Login failed. Please try again.');
      print(e.toString());
      return null;
    }
  }
}
