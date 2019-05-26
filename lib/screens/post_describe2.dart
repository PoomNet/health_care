import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myapp/screens/likepost.dart';
import 'package:myapp/screens/sqlpost.dart';
import 'package:path/path.dart';

import 'current_post.dart';

class Showpost2 extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new ShowpostState2();
  // TODO: implement createState

}

class ShowpostState2 extends State<Showpost2> {
  DataAccess dataAccess = DataAccess();
  var checksql = 0;
  var com = [];
  var comment = [];
  var post = [];
  var user;
  var check_user = 0;
  var check_post = 0;
  var new_com = 0;
  var checkcom = 0;
  final commentCon = TextEditingController();

  void check() async {
    await dataAccess.open();

    dataAccess.getAllUser().then((r) {
      for (var i = 0; i < r.length; i++) {
        if (r[i].cause == Currentpost.CAUSE) {
          setState(() {
            checksql = 1;
          });
        }
      }
    });
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
    if (checkcom == 0) {
      return RaisedButton.icon(
        icon: Icon(Icons.comment),
        label: Text("Show Comments"),
        textColor: Colors.white,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        color: Colors.greenAccent,
        onPressed: () {
          setState(() {
            checkcom = 1;
          });
        },
      );
    } else {
      return Column();
    }
  }

  Widget buildList() {
    if (checkcom == 0) {
      return Column();
    } else if (Currentpost.COMMENT != null) {
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
    } else {
      return Column();
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

  Widget buildlike() {
    if (checksql == 1) {
      return Column();
    } else {
      return RaisedButton.icon(
          color: Colors.redAccent,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          textColor: Colors.white,
          icon: Icon(Icons.favorite),
          label: Text("like post"),
          onPressed: () async {
            await dataAccess.open();

            dataAccess.getAllUser().then((r) {
              for (var i = 0; i < r.length; i++) {
                if (r[i].cause == Currentpost.CAUSE) {
                  checksql = 1;
                }
              }
            });
            if (checksql == 0) {
              ProfileItem data =
                  ProfileItem(); //สร้างไว้สร้างข้อมูลใหม่ไม่ต้องมีidจะสร้างให้เอง
              data.cause = Currentpost.CAUSE;
              data.symptom = Currentpost.SYMPTOM;
              data.category = Currentpost.CATEGORY;
              data.describe = Currentpost.DESCRIBE;
              data.user = Currentpost.USER;
              data.image = Currentpost.IMAGE;
              await dataAccess.insertUser(data);
            } else {
              print("cant add");
            }
            setState(() {
              checksql = 1;
            });
          });
    }
  }

  Widget buildunlike() {
    if (checksql == 1) {
      return RaisedButton.icon(
          color: Colors.blueGrey,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          textColor: Colors.white,
          icon: Icon(Icons.favorite_border),
          label: Text("unlike post"),
          onPressed: () async {
            await dataAccess.open();
            dataAccess.getAllUser().then((r) {
              for (var i = 0; i < r.length; i++) {
                if (r[i].cause == Currentpost.CAUSE) {
                  dataAccess.delete(r[i].id);
                }
              }
            });
            setState(() {
              checksql = 0;
            });
          });
    } else {
      return Column();
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: true,
        appBar: AppBar(
          centerTitle: true,
          leading: new Container(),
          title: Text(Currentpost.CAUSE),
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
                Navigator.push(
              context, MaterialPageRoute(builder: (context) => LikePostPage()));
              },
            )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Container(
            height: 500,
            child: ListView(
              children: <Widget>[
                Container(
                  child: Column(
                    children: <Widget>[
                      buildIm(),
                      ListTile(
                        leading: Icon(Icons.subject),
                        title: Text(Currentpost.CAUSE),
                      ),
                      ListTile(
                        leading: Icon(Icons.not_listed_location),
                        title: Text(Currentpost.SYMPTOM),
                      ),
                      ListTile(
                        leading: Icon(Icons.speaker_notes),
                        title: Text(Currentpost.DESCRIBE),
                      ),
                      ListTile(
                        leading: Icon(Icons.account_circle),
                        title: Text(Currentpost.USER),
                      ),
                      buildlike(),
                      buildunlike(),
                      buildbut(),
                      buildList(),
                      TextFormField(
                          decoration: new InputDecoration(
                              labelText: "Comment",
                              fillColor: Colors.white,
                              border: new OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(25.0),
                                borderSide: new BorderSide(),
                              ),
                              focusedBorder: new OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(25.0),
                                borderSide:
                                    new BorderSide(color: Colors.greenAccent),
                              ),
                              hintText: "Write your comment here"),
                          keyboardType: TextInputType.multiline,
                          maxLines: 3,
                          controller: commentCon,
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Please fill subject";
                            }
                          }),
                      ConstrainedBox(
                        constraints:
                            const BoxConstraints(minWidth: double.infinity),
                        child: RaisedButton.icon(
                            icon: Icon(Icons.add_comment),
                            color: Colors.blueAccent,
                            textColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0)),
                            label: Text("Comment"),
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
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}