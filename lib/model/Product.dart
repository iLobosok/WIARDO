import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  String title = '';
  String description = '';
  String instagram = '';
  bool active = false;
  String productID;
  Timestamp lastOnlineTimestamp = Timestamp.now();
  String productPictureURL = '';

  Product(
      { this.title,
        this.instagram,
        this.description,
        this.productID,
        this.productPictureURL,
        this.active,});


  factory Product.fromJson(Map<String, dynamic> parsedJson) {
    return new Product(
        title: parsedJson['title'] ?? '',
        instagram: parsedJson['instagram'] ?? '',
        description: parsedJson['description'] ?? '',
        productID: parsedJson['ProductID'] ?? '',
        active: parsedJson['active'] ?? false,
        productPictureURL: parsedJson['ProductImage'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {
      'instagram' : this.instagram,
      'title': this.title,
      'description': this.description,
      'productId': this.productID,
      'active': this.active,
      'ImageURL': this.productPictureURL,
    };
  }
}