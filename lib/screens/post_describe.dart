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
  var comment=[];
  var post = [];
  var user;
  var check_user = 0;
  var check_post = 0;
  var new_com = 0;
  final commentCon = TextEditingController();

  @override
  initState() {
    super.initState();
    // Add listeners to this class
    FirebaseDatabase.instance.reference().once().then((DataSnapshot data) {
      print(data.value);
      print(data.value.length);
      print(data.value[1]['user']['name']);
      print(Currentpost.USER);
      for (check_user; check_user < data.value.length; check_user++) {
        if (data.value[check_user] != null) {
          if (data.value[check_user]['user']['name'] == Currentpost.USER) {
            user = data.value[check_user]['user'];
            break;
          }
        }
      }
      print(data.value[check_user]['post'][check_post]['describe']);
      print(Currentpost.DESCRIBE);
      if (data.value[check_user]['post'] != null) {
        for (check_post; check_post < data.value[check_user]['post'].length; check_post++) {
          if(data.value[check_user]['post'][check_post]['describe']==Currentpost.DESCRIBE){
            break;
          }
        }
      }
      new_com=data.value[check_user]['post'][check_post]['comment'].length;
    });
  }
  

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
                        Currentpost.USER = "";
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
                  Text(Currentpost.USER),
                  TextFormField(
                    decoration: InputDecoration(labelText: "comment"),
                  controller: commentCon,
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Please fill subject";
                    }
                  }
                  ),
                  RaisedButton(
                            child: Text("Save"),
                            onPressed: () {
                              FirebaseDatabase.instance
                                  .reference()
                                  .child(check_user.toString()).child("post").child(check_post.toString()).child("comment").child(new_com.toString())
                                  .set(commentCon.text);
                                  // commentCon.dispose();
                            })
                ],
              ),
            )
          ],
        ));
  }
}
