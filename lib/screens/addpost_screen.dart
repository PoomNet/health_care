import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myapp/data/users.dart';

import 'addimage.dart';
import 'current_post.dart';

class AddPage extends StatefulWidget {
User userinfo;
  AddPage(this.userinfo);
  _AddPageState createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  final cause = TextEditingController();
  final symptom = TextEditingController();
  // final category = TextEditingController();
  final describe = TextEditingController();
  var category = 'การกิน';
  final _formKey = GlobalKey<FormState>();

  int _radioValue = 0;

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
        appBar: AppBar(title: Text("Create post")),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.red,
          onPressed: () {
            Currentpost.CAUSE = cause.text;
        Currentpost.SYMPTOM = symptom.text;
        Currentpost.DESCRIBE = describe.text;
        Currentpost.CATEGORY = category;
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Addimage(widget.userinfo)));
          },
          child: Icon(Icons.image),
        ),
        body: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(labelText: "Cause"),
                  controller: cause,
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Please fill subject";
                    }
                  },
                  onSaved: (value) => print(value),
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: "Symptom"),
                  controller: symptom,
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Please fill subject";
                    }
                  },
                  onSaved: (value) => print(value),
                ),
                Column(
                  children: <Widget>[
                    Row(
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
                        new Radio(
                          value: 2,
                          groupValue: _radioValue,
                          onChanged: _handleRadioValueChange,
                        ),
                        new Text('ลดน้ำหนัก'),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        new Radio(
                          value: 3,
                          groupValue: _radioValue,
                          onChanged: _handleRadioValueChange,
                        ),
                        new Text('อุบัติเหตุ'),
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
                      ],
                    ),
                  ],
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: "Describe"),
                  controller: describe,
                  keyboardType: TextInputType.multiline,
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
                        child: RaisedButton(
                            child: Text("Save"),
                            onPressed: () {
                              Firestore.instance.runTransaction(
                                  (Transaction transaction) async {
                                CollectionReference reference =
                                    Firestore.instance.collection('post');

                                await reference.add({
                                  "cause": cause.text,
                                  "symptom": symptom.text,
                                  "category": category,
                                  "describe": describe.text,
                                });
                                cause.clear();
                                symptom.clear();
                                // category.clear();
                                describe.clear();
                              });
                              Navigator.pop(context);
                            }))
                  ],
                )
              ],
            )));
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
