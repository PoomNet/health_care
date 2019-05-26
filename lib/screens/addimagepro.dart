import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myapp/data/users.dart';
import 'package:myapp/screens/current_login.dart';
import 'package:path/path.dart';

import 'current_post.dart';
import 'home_screen.dart';

class Addimagepro extends StatefulWidget {
  //หน้าใส่รูปเข้าfirebase
  // User userinfo;
  Addimagepro();
  @override
  State<StatefulWidget> createState() => new AddimageState();
  // TODO: implement createState

}

var check_user = 0;
var new_post =0;
File image;
String filename;

class AddimageState extends State<Addimagepro> {
  // User userinf2;
  Future _getImage() async {
    var selectedImage =
        await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      image = selectedImage;
      filename = basename(image.path);
    });
  }

  @override
  initState() {
    super.initState();
    // Add listeners to this class
    FirebaseDatabase.instance.reference().once().then((DataSnapshot data) {
      for (check_user; check_user < data.value.length; check_user++) {
        if (data.value[check_user] != null) {
          if (data.value[check_user]['user']['name'] == Currentlogin.USER) {
            //ไว้เชคuser
            break;
          }
        }
      }
      new_post = data.value[check_user]['post'].length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("flutter"),
      ),
      body: Center(
        child: image == null ? Text("select image") : uploadArea(context),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _getImage,
        tooltip: 'Increment',
        child: Icon(Icons.image),
      ),
    );
  }

  Widget uploadArea(context) {
    return Column(
      children: <Widget>[
        Image.file(image, width: 150),
        RaisedButton(
          color: Colors.yellowAccent,
          child: Text('Add Image'),
          onPressed: () {
            uploadImage();
            // Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //         builder: (context) => MainPage(userinfo: userinf2,)));
            Navigator.pop(context);
          },
        )
      ],
    );
  }
}

Future<String> uploadImage() async {
  StorageReference ref = FirebaseStorage.instance.ref().child(filename);
  StorageUploadTask uploadTask = ref.putFile(image);

  var downUrl = await (await uploadTask.onComplete).ref.getDownloadURL();
  var url = downUrl.toString();
  Currentlogin.IMAGE = url;

  print("download URL : $url");

  FirebaseDatabase.instance
                                  .reference()
                                  .child(check_user.toString()).child("user").child("image")
                                  .set(url);

  // Firestore.instance.runTransaction((Transaction transaction) async {
  //   CollectionReference reference = Firestore.instance.collection('post');

  //   await reference.add({
  //     "image": url,
  //     "cause": Currentpost.CAUSE,
  //     "symptom": Currentpost.SYMPTOM,
  //     "category": Currentpost.CATEGORY,
  //     "describe": Currentpost.DESCRIBE,
  //     "user":Currentpost.USER,
  //   });
  // });
  image = null;
}
