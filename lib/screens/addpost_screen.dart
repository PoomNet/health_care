import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myapp/data/users.dart';
import 'package:myapp/screens/current_login.dart';

import 'addimage.dart';
import 'current_post.dart';
import 'home_screen.dart';

class AddPage extends StatefulWidget {
  User userinfo;
  AddPage(this.userinfo);
  _AddPageState createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  User userinf2;
  var check_user = 0;
  var new_post = 0;

  final cause = TextEditingController();
  final symptom = TextEditingController();
  // final category = TextEditingController();
  final describe = TextEditingController();
  var category = 'การกิน';
  final _formKey = GlobalKey<FormState>();

  int _radioValue = 0;

  @override
  initState() {
    super.initState();
    // Add listeners to this class
    FirebaseDatabase.instance.reference().once().then((DataSnapshot data) {
      print(data.value.length);
      for (check_user; check_user < data.value.length; check_user++) {
        print(data.value.length.runtimeType);
        print(check_user < data.value.length);
        print(check_user);
        if (data.value[check_user] != null) {
          if (data.value[check_user]['user']['name'] ==
              widget.userinfo.displayname) {
            //ไว้เชคuser
            break;
          } else if (check_user == data.value.length - 1) {
            FirebaseDatabase.instance
                .reference()
                .child((check_user + 1).toString())
                .child("user")
                .set({
              "name": Currentlogin.USER, //ใส่ข้อมูลuser
            });
            break;
          }
        }
      }

      new_post = data.value[check_user]['post'].length;
    });
  }

  void _handleRadioValueChange(int value) {
    setState(() {
      _radioValue = value;

      switch (_radioValue) {
        case 0:
          category = 'การกิน';
          break;
        case 1:
          category = 'การออกกำลังกาย';
          break;
        case 2:
          category = 'ลดน้ำหนัก';
          break;
        case 3:
          category = 'อุบัติเหตุ';
          break;
        case 4:
          category = 'ผู้หญิง';
          break;
        case 5:
          category = 'ผู้ชาย';
          break;
        case 6:
          category = 'อื่นๆ';
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: true,
        appBar: AppBar(
          title: Text("Create post"),
          actions: <Widget>[],
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.red,
          onPressed: () {
            if (_formKey.currentState.validate()) {
              Currentpost.CAUSE = cause.text;
              Currentpost.SYMPTOM = symptom.text;
              Currentpost.DESCRIBE = describe.text;
              Currentpost.CATEGORY = category;
              Currentpost.USER = widget.userinfo.displayname;
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Addimage(widget.userinfo)));
            }
          },
          child: Icon(Icons.image),
        ),
        body: Container(
          height: 500,
          child: ListView(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(10.0),
                child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        TextFormField(
                          autofocus: true,
                          decoration: new InputDecoration(
                              labelText: "Topic",
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
                              hintText: "Your topic here"),
                          keyboardType: TextInputType.text,
                          controller: cause,
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Please fill subject";
                            }
                          },
                          onSaved: (value) => print(value),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 8.0, 0, 0),
                          child: TextFormField(
                            decoration: new InputDecoration(
                                labelText: "Description",
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
                                hintText: "Your description here"),
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            controller: symptom,
                            validator: (value) {
                              if (value.isEmpty) {
                                return "Please fill subject";
                              }
                            },
                            onSaved: (value) => print(value),
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.fromLTRB(30.0, 0, 0, 0),
                              child: Row(
                                children: <Widget>[
                                  new Radio(
                                    value: 0,
                                    groupValue: _radioValue,
                                    onChanged: _handleRadioValueChange,
                                  ),
                                  new Text('การกิน'),
                                  new Radio(
                                    value: 1,
                                    groupValue: _radioValue,
                                    onChanged: _handleRadioValueChange,
                                  ),
                                  new Text('การออกกำลังกาย'),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
                              child: Row(
                                children: <Widget>[
                                  new Radio(
                                    value: 2,
                                    groupValue: _radioValue,
                                    onChanged: _handleRadioValueChange,
                                  ),
                                  new Text('ลดน้ำหนัก'),
                                  new Radio(
                                    value: 3,
                                    groupValue: _radioValue,
                                    onChanged: _handleRadioValueChange,
                                  ),
                                  new Text('อุบัติเหตุ'),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
                              child: Row(children: <Widget>[
                                new Radio(
                                  value: 4,
                                  groupValue: _radioValue,
                                  onChanged: _handleRadioValueChange,
                                ),
                                new Text('ผู้หญิง'),
                                new Radio(
                                  value: 5,
                                  groupValue: _radioValue,
                                  onChanged: _handleRadioValueChange,
                                ),
                                new Text('ผู้ชาย'),
                                new Radio(
                                  value: 6,
                                  groupValue: _radioValue,
                                  onChanged: _handleRadioValueChange,
                                ),
                                new Text('อื่นๆ'),
                              ]),
                            )
                          ],
                        ),
                        TextFormField(
                          decoration: new InputDecoration(
                              labelText: "Details",
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
                              hintText: "Add more details here"),
                          controller: describe,
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Please fill subject";
                            }
                          },
                          onSaved: (value) => print(value),
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(
                                child: RaisedButton.icon(
                                    icon: Icon(Icons.send),
                                    label: Text("Post"),
                                    textColor: Colors.white,
                                    color: Colors.greenAccent,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0)),
                                    onPressed: () {
                                      if (_formKey.currentState.validate()) {
                                        FirebaseDatabase.instance
                                            .reference()
                                            .child(check_user.toString())
                                            .child("post")
                                            .child(new_post.toString())
                                            .set({
                                          "cause": cause.text,
                                          "symptom": symptom.text,
                                          "category": category,
                                          "describe": describe.text,
                                          "image": "",
                                        });

                                        Firestore.instance.runTransaction(
                                            (Transaction transaction) async {
                                          CollectionReference reference =
                                              Firestore.instance
                                                  .collection('post');

                                          await reference.add({
                                            "cause": cause.text,
                                            "symptom": symptom.text,
                                            "category": category,
                                            "describe": describe.text,
                                            "image": "",
                                            "user": widget.userinfo.displayname,
                                          });
                                          cause.clear();
                                          symptom.clear();
                                          // category.clear();
                                          describe.clear();
                                        });
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => MainPage(
                                                      userinfo: userinf2,
                                                    )));
                                      }
                                    }))
                          ],
                        )
                      ],
                    )),
              ),
            ],
          ),
        ));
  }

  @override
  void dispose() {
    cause.dispose();
    symptom.dispose();
    // category.dispose();
    describe.dispose();
    super.dispose();
  }
}
