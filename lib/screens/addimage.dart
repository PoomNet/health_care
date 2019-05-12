import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myapp/data/users.dart';
import 'package:path/path.dart';

import 'current_post.dart';
import 'home_screen.dart';

class Addimage extends StatefulWidget {//หน้าใส่รูปเข้าfirebase
User userinfo;
  Addimage(this.userinfo);
  @override
  State<StatefulWidget> createState() =>  new AddimageState();
    // TODO: implement createState

}
  File image;
  String filename;
class AddimageState extends State<Addimage> {


  Future _getImage() async{
    var selectedImage = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      image = selectedImage;
      filename=basename(image.path);
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("flutter"),
      ),
      body: Center(
        child: image==null?Text("select image"): uploadArea(context),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _getImage,
        tooltip: 'Increment',
        child: Icon(Icons.image),
      ),
    );
  }

  Widget uploadArea(context){
    return Column(
      children: <Widget>[
        Image.file(image, width: 100),
        RaisedButton(
        color: Colors.yellowAccent,
        child: Text('Add more Image'),
        onPressed: (){
          uploadImage();
          _getImage();
        },
      ),
      RaisedButton(
        color: Colors.yellowAccent,
        child: Text('Post'),
        onPressed: (){
          uploadImage();
          Navigator.push(
                context, MaterialPageRoute(builder: (context) => MainPage(widget.userinfo)));
        },
      )
    ],
    );
}
}

Future<String> uploadImage() async{
  StorageReference ref = FirebaseStorage.instance.ref().child(filename);
  StorageUploadTask uploadTask = ref.putFile(image);

  var downUrl = await (await uploadTask.onComplete).ref.getDownloadURL();
  var url = downUrl.toString();

  print("download URL : $url");
  Firestore.instance.runTransaction(
                                  (Transaction transaction) async {
                                CollectionReference reference =
                                    Firestore.instance.collection('post');

                                await reference.add({
                                  "image": url,
                                  "cause": Currentpost.CAUSE,
                                  "symptom": Currentpost.SYMPTOM,
                                  "category": Currentpost.CATEGORY,
                                  "describe": Currentpost.DESCRIBE,
                                });
                                  });
}