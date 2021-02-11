import 'package:flutter/cupertino.dart';

class Paddings{
  static double getPadding(context, double pad){
    var Padding_1 = MediaQuery.of(context).size.width * pad;
    return Padding_1;
  }
  
}