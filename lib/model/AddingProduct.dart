import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_login_screen/model/Product.dart';
import 'package:flutter_login_screen/services/Authenticate.dart';
import 'package:flutter_login_screen/services/helper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_login_screen/ui/Shop.dart';
import 'dart:io';

File _image;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(AddingProduct());
}

class AddingProduct extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Products',
      home: AddProduct(title: 'Adding product'),
    );
  }
}

class AddProduct extends StatefulWidget {
  AddProduct({Key key, this.title, this.description}) : super(key: key);
  final String title, description;
  GlobalKey<FormState> _key = new GlobalKey();
  AutovalidateMode _validate = AutovalidateMode.disabled;

  @override
  _AdgProductState createState() => _AdgProductState();
}

class _AdgProductState extends State<AddProduct> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: SingleChildScrollView(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("Add your product",
                      style: TextStyle(
                          fontSize: 30,
                          )),
                  RegisterPet(),
                ]),
          )),
    );

  }
}



class RegisterPet extends StatefulWidget {
  RegisterPet({Key key}) : super(key: key);

  @override
  _RegisterPetState createState() => _RegisterPetState();
}

class _RegisterPetState extends State<RegisterPet> {
  final _formKey = GlobalKey<FormState>();
  final listOfPets = ["Shoppers", "Shirts", "T-Shirts", "Shoes", "Pants", "Masks", "Glasses"];
  String dropdownValue = 'Shoppers';
  final titleController = TextEditingController();
  final ImagePicker _imagePicker = ImagePicker();
  final descriptionController = TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  GlobalKey<FormState> _key = new GlobalKey();
  AutovalidateMode _validate = AutovalidateMode.disabled;
  final costController = TextEditingController();
  final dbRef = FirebaseDatabase.instance.reference().child("Products");
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
  _onCameraClick() {
    final action = CupertinoActionSheet(
      message: Text(
        "Add picture",
        style: TextStyle(fontSize: 15.0),
      ),
      actions: <Widget>[
        CupertinoActionSheetAction(
          child: Text("Choose from gallery"),
          isDefaultAction: false,
          onPressed: () async {
            Navigator.pop(context);
            PickedFile image =
            await _imagePicker.getImage(source: ImageSource.gallery);
            if (image != null)
              setState(() {
                _image = File(image.path);
              });
          },
        ),
        CupertinoActionSheetAction(
          child: Text("Take a picture"),
          isDestructiveAction: false,
          onPressed: () async {
            Navigator.pop(context);
            PickedFile image =
            await _imagePicker.getImage(source: ImageSource.camera);
            if (image != null)
              setState(() {
                _image = File(image.path);
              });
          },
        )
      ],
      cancelButton: CupertinoActionSheetAction(
        child: Text("Cancel"),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
    showCupertinoModalPopup(context: context, builder: (context) => action);
  }
  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: SingleChildScrollView(
            child: Column(children: <Widget>[
              Padding(
                padding: EdgeInsets.all(20.0),
                child: TextFormField(
                  controller: titleController,
                  decoration: InputDecoration(
                    hintText: "Name of item",
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
                  decoration: InputDecoration(
                    hintText: "Description of item",
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
                  icon: Icon(Icons.arrow_downward),
                  decoration: InputDecoration(
                    hintText: "Select type of item",
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
                  decoration: InputDecoration(
                    hintText: "Enter cost \$",
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
                    radius: 65,
                    backgroundColor: Colors.grey.shade400,
                    child: ClipOval(
                      child: SizedBox(
                        width: 170,
                        height: 170,
                        child: _image == null
                            ? Image.asset(
                          'assets/images/placeholder.png',
                          fit: BoxFit.cover,
                        )
                            : Image.file(
                          _image,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 80,
                    right: 0,
                    child: FloatingActionButton(
                        backgroundColor: Colors.lightBlue,
                        child: Icon(Icons.camera_alt),
                        mini: true,
                        onPressed: _onCameraClick),
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
                  borderRadius: BorderRadius.circular(20),
                      child:RaisedButton(
                        color: Colors.green,
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            dbRef.push().set({
                              "Title": titleController.text,
                              "Description": descriptionController.text,
                              "Cost": costController.text,
                              "type": dropdownValue
                            }).then((_) {
                              Scaffold.of(context).showSnackBar(
                                  SnackBar(content: Text('Successfully Added',style: TextStyle(color: Colors.white),),backgroundColor: Colors.green,)
                              );
                            }).catchError((onError) {
                              Scaffold.of(context)
                                  .showSnackBar(SnackBar(content: Text(onError)));
                            });
                          }
                          MaterialPageRoute(builder: (context) => Shop(/**/));
                          descriptionController.clear();
                          costController.clear();
                          titleController.clear();
                        },
                        child: Text('Done', style: TextStyle(color: Colors.white),),
                      ),
                      ),
                    ],
                  )),
            ])));
  }
 @override
  void dispose() {
    super.dispose();
    descriptionController.dispose();
    costController.dispose();
    titleController.dispose();
  }
}