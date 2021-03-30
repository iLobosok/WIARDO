import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_login_screen/model/User.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_login_screen/ui/Shop.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';

FirebaseStorage storage = FirebaseStorage.instance;
File _image;


class AddProduct extends StatefulWidget {
  final Users user;

  AddProduct({Key key, @required this.user, this.title, this.description, this.inst}) : super(key: key);
  final String title, description, inst;
  @override
  _AdgProductState createState() {
    return _AdgProductState(user);
  }
}

class _AdgProductState extends State<AddProduct> {
  final Users user;
  _AdgProductState(this.user);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.grey[900],
        ),
        backgroundColor: Colors.grey[900],
        body: Center(
            child: SingleChildScrollView(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: 15,),
                    Text("Add your product",
                        style: TextStyle(
                          color:Colors.white,
                          fontSize: 30,
                        )),
                    AddProducts(user: user,),
                  ]),
            )),
      ),
    );
  }
}



class AddProducts extends StatefulWidget {
  final Users user;
  AddProducts({Key key, @required this.user}) : super(key: key);

  @override
  _AddProductsState createState() {
    return _AddProductsState(user);
  }
}

class _AddProductsState extends State<AddProducts> {
  final firestoreInstance = FirebaseFirestore.instance;
  final Users user;
  _AddProductsState(this.user);
  final _formKey = GlobalKey<FormState>();
  final listOfPets = ["T-shirts", "Tops", "Bras", "Shirts", "Dresses", "Skirts", "Pants", "Shoppers", "Shorts", "Socks", "Shoes", "Sweaters", "Jeans", "Masks"];
  String dropdownValue = 'Shoppers';
  final titleController = TextEditingController();
  final ImagePicker _imagePicker = ImagePicker();
  final descriptionController = TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  GlobalKey<FormState> _key = new GlobalKey();
  AutovalidateMode _validate = AutovalidateMode.disabled;
  final costController = TextEditingController();
  final dbRef = FirebaseDatabase.instance.reference().child("Data");
  String title, description, productID, product, inst;
  Future<void> retrieveLostData() async {
    final LostData response = await _imagePicker.getLostData();
    if (response == null) {
      return;
    }
    if (response.file != null) {
      setState(() {
        _image = File(response.file.path);
      });
    }
  }
  var imgUrl = '';
  _onCameraClick() async {
    inst = '${user.insta.toString()}';
    Random random = new Random();
    int randomNumber = random.nextInt(9999999);
    productID = '$randomNumber';
    _image = await ImagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 70
    );
    if (_image != null)
      setState(() {
        _image = File(_image.path);
      });
    Reference reference =
    storage.ref().child("productImg/${productID}");
    if (_image != null)
      setState(() {
        _image = File(_image.path);
      });
    //Upload the file to firebase
    UploadTask uploadTask = reference.putFile(_image);
    TaskSnapshot taskSnapshot = await uploadTask;
    imgUrl = '${await taskSnapshot.ref.getDownloadURL()}';
    print(imgUrl);
    return imgUrl;
  }

  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: SingleChildScrollView(
            child: Container(
              color: Colors.grey[900],
              child: Column(
                children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(20.0),
                  child: TextFormField(
                    controller: titleController,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Name of item",
                      hintStyle: TextStyle(color:Colors.white),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    // The validator receives the text that the user has entered.
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Enter product name';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(20.0),
                  child: TextFormField(
                    controller: descriptionController,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Description of item",
                      hintStyle: TextStyle(color:Colors.white),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    // The validator receives the text that the user has entered.
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Enter product description';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(20.0),
                  child: DropdownButtonFormField(
                    value: dropdownValue,
                    style: TextStyle(color: Colors.white),
                    dropdownColor: Colors.black,
                    icon: Icon(Icons.arrow_downward),
                    decoration: InputDecoration(
                      hintText: "Select type of item",
                      hintStyle: TextStyle(color:Colors.white),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    items: listOfPets.map((String value) {
                      return new DropdownMenuItem<String>(
                        value: value,
                        child: new Text(value),
                      );
                    }).toList(),
                    onChanged: (String newValue) {
                      setState(() {
                        dropdownValue = newValue;
                      });
                    },
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please Select Type';
                      }
                      // if (value > 5000)
                      //   {
                      //     return 'Very high cost';
                      //   }
                      // if (value < 1)
                      // {
                      //   return 'Very low cost';
                      // }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(20.0),
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    controller: costController,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Enter cost in \$",
                      hintStyle: TextStyle(color:Colors.white),

                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    // The validator receives the text that the user has entered.
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please Enter the cost of item';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, top: 32, right: 8, bottom: 8),
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: <Widget>[
                      CircleAvatar(
                        radius: 85,
                        backgroundColor: Colors.grey.shade400,
                        child: ClipOval(
                          child:InkWell(
                            onTap: (){
                              _onCameraClick();
                            },
                            child: SizedBox(
                              width: 170,
                              height: 170,
                              child: _image == null
                                  ? Image.asset(
                                'assets/images/placeholder.jpg',
                                fit: BoxFit.fitWidth,
                              )
                                  : Image.file(
                                _image,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),

                    ],
                  ),
                ),
                Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child:RaisedButton(
                            color: Colors.green,
                            onPressed: () {
                              if (_formKey.currentState.validate()) {

                                updateListOfSelfItems(
                                  name: titleController.text,
                                  description: descriptionController.text,
                                  cost: costController.text,
                                  inst: inst.toString(),
                                  type: dropdownValue,
                                  imgUrl: imgUrl,
                                  productID: createID(),
                                );
                              }

                              MaterialPageRoute(builder: (context) => Shop(/**/));
                              descriptionController.clear();
                              costController.clear();
                              titleController.clear();
                            },
                            child: Text('Add item', style: TextStyle(color: Colors.white),),
                          ),
                        ),
                      ],
                    )
                ),
              ]
          ),
            )
      )
    );
}

  @override
  void dispose() {
    _passwordController.dispose();
    _image = null;
    super.dispose();
  }
  void updateListOfSelfItems({String productID,String imgUrl,String name,String type, String cost, String inst, String description}) {
    var date = DateTime.now();
    print(date);
    dbRef.child('$productID').set({
      "name": name,
      "description": description,
      "cost": cost,
      "instagram" : inst,
      "type": type,
      "imgUrl": imgUrl,
      "productID":productID,
    }).then((_) {
      var firebaseUser = FirebaseAuth.instance.currentUser;
      firestoreInstance
          .collection("users")
          .doc(firebaseUser.uid)
          .get()
          .then((DocumentSnapshot ds) {
              Map myItems = ds['MyItems'];
              Map<String, List<String>> currentInfo = {
                productID: [
                  productID,
                  imgUrl,
                  name,
                  type,
                  cost,
                  description,
                  inst,
                ]
              };
              myItems.addAll(currentInfo);
                firestoreInstance
                    .collection("users")
                    .doc(firebaseUser.uid)
                    .update({"MyItems": myItems})
                    .then((_) {});
      });
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Successfully Added',style: TextStyle(color: Colors.white),),backgroundColor: Colors.green,)
      );
    }).catchError((onError) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(onError))
      );
    });
  }
  String createID(){
    var firebaseUser = FirebaseAuth.instance.currentUser;
    RegExp exp = RegExp(r"[^\w]+");
    DateTime date = DateTime.now();
    String formattedDate =  date.toString().replaceAll(exp, '');
    String productID = formattedDate + firebaseUser.uid.toString().substring(0,5);
    print(productID);
    return(productID);
  }
}