import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

import 'current_post.dart';

class Showpost extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new ShowpostState();
  // TODO: implement createState

}


class ShowpostState extends State<Showpost> {

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: new Container(),
          title: Text("flutter"),
          actions: <Widget>[
                  new IconButton(
                    icon: new Icon(Icons.close),
                    color: Colors.white,
                    onPressed: (){
                        Currentpost.CAUSE = "";
                        Currentpost.SYMPTOM = "";
                        Currentpost.DESCRIBE = "";
                        Navigator.pop(context);
                      },
                  )
                ],
        ),
        body: ListView(
          children: <Widget>[
            Container(
              height: 500,
              child: Column(
                children: <Widget>[
                  Text(Currentpost.CAUSE),
                  Text(Currentpost.SYMPTOM),
                  Text(Currentpost.DESCRIBE),
                ],
              ),
            )
          ],
        ));
  }
}
