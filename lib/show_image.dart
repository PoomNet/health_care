import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class Showimage extends StatefulWidget {//หน้าโชข้อมูลแต่ละโพสต์
  @override
  State<StatefulWidget> createState() => new ShowimageState();
  // TODO: implement createState

}


class ShowimageState extends State<Showimage> {

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("flutter"),
        ),
        body: StreamBuilder(
          stream: Firestore.instance.collection('post').snapshots(),
          builder: (context, snapshot) {
              return Column  (
                children: <Widget>[
                  Container(
                    child: new Image.network(snapshot.data.documents[1]['describe']),
                  )
                ],
              );
          },
        ));
  }
}
