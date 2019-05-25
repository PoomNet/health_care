import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myapp/screens/sqlpost.dart';
import 'package:path/path.dart';

import 'current_post.dart';

class Showpost extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new ShowpostState();
  // TODO: implement createState

}

class ShowpostState extends State<Showpost> {
  DataAccess dataAccess = DataAccess();
  var com = [];
  var comment = [];
  var post = [];
  var user;
  var check_user = 0;
  var check_post = 0;
  var new_com = 0;
  var aaa = 0;
  final commentCon = TextEditingController();

  void check() async{
    await dataAccess.open();

                  dataAccess.getAllUser().then((r) {
        for (var i = 0; i < r.length; i++) {
            if(r[i].cause==Currentpost.CAUSE){
              print(r[i]);
            }
      }});
      // await dataAccess.close();
  }

  Widget _createTodoItemWidget(var item) {
    return ListTile(
      title: Text(item),
    );
  }

  @override
  initState() {
    super.initState();
    check();
    // Add listeners to this class
    FirebaseDatabase.instance.reference().once().then((DataSnapshot data) {
      for (check_user; check_user < data.value.length; check_user++) {
        if (data.value[check_user] != null) {
          if (data.value[check_user]['user']['name'] == Currentpost.USER) {
            user = data.value[check_user]['user'];
            break;
          }
        }
      }
      if (data.value[check_user]['post'] != null) {
        for (check_post;
            check_post < data.value[check_user]['post'].length;
            check_post++) {
          if (data.value[check_user]['post'][check_post]['describe'] ==
              Currentpost.DESCRIBE) {
            break;
          }
        }
      }
      comment = new List<String>.from(
          data.value[check_user]['post'][check_post]['comment']);
      new_com = data.value[check_user]['post'][check_post]['comment'].length;
      Currentpost.COMMENT = comment;
    });
  }

  Widget buildbut() {
    if (Currentpost.COMMENT == null) {
      return RaisedButton(
        child: Text("Show Comments"),
        onPressed: () {
          setState(() {
            aaa = 1;
          });
        },
      );
    } else {
      return Column();
    }
  }

  Widget buildList() {
    if (Currentpost.COMMENT == null) {
      return Column();
    } else {
      return Container(
          height: 75.0,
          child: new ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: Currentpost.COMMENT.length,
            itemBuilder: (BuildContext context, int index) {
              return Text(
                Currentpost.COMMENT[index],
              );
            },
          ));
    }
  }

  Widget buildIm() {
    if (Currentpost.IMAGE == "") {
      return Column();
    } else {
      return Image.network(
        Currentpost.IMAGE,
        width: 100,
      );
    }
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
              onPressed: () {
                Currentpost.CAUSE = "";
                Currentpost.SYMPTOM = "";
                Currentpost.DESCRIBE = "";
                Currentpost.USER = "";
                Currentpost.COMMENT = null;
                Navigator.pop(context);
              },
            )
          ],
        ),
        body: Column(
          children: <Widget>[
            buildIm(),
            Text(Currentpost.CAUSE),
            Text(Currentpost.SYMPTOM),
            Text(Currentpost.DESCRIBE),
            Text(Currentpost.USER),
            buildbut(),
            buildList(),
            TextFormField(
                decoration: InputDecoration(labelText: "comment"),
                controller: commentCon,
                validator: (value) {
                  if (value.isEmpty) {
                    return "Please fill subject";
                  }
                }),
            RaisedButton(
                child: Text("comment"),
                onPressed: () {
                  FirebaseDatabase.instance
                      .reference()
                      .child(check_user.toString())
                      .child("post")
                      .child(check_post.toString())
                      .child("comment")
                      .child(new_com.toString())
                      .set(commentCon.text);
                  com;
                  comment.add(commentCon.text);
                  Currentpost.COMMENT = comment;
                  setState(() {
                    commentCon.clear();
                  });
                }),
            RaisedButton(
                child: Text("like post"),
                onPressed: () async {
                  await dataAccess.open();

                  dataAccess.getAllUser().then((r) {
        for (var i = 0; i < r.length; i++) {
            if(r[i].cause==Currentpost.CAUSE){
              print(r[i]);
            }
      }});

                  ProfileItem data =
                      ProfileItem(); //สร้างไว้สร้างข้อมูลใหม่ไม่ต้องมีidจะสร้างให้เอง
                  data.cause = Currentpost.CAUSE;
                  data.symptom = Currentpost.SYMPTOM;
                  data.category = Currentpost.CATEGORY;
                  data.describe = Currentpost.DESCRIBE;
                  data.user = Currentpost.USER;
                  data.image = Currentpost.IMAGE;
                  print(data);
                  await dataAccess.insertUser(data);
                  print(11111111);
                }),
            RaisedButton(
                child: Text("unlike post"),
                onPressed: () async {
                  await dataAccess.open();
                  dataAccess.getAllUser().then((r) {
        for (var i = 0; i < r.length; i++) {
            if(r[i].cause==Currentpost.CAUSE){
              dataAccess.delete(r[i].id);
            }
      }});
                }),
          ],
        ));
  }
}
