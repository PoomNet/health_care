import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Addpost extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new AddpostState();
}

class AddpostState extends State<Addpost> {
  final cause = TextEditingController();
  final symptom = TextEditingController();
  final category = TextEditingController();
  final describe = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Create post")),
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
                TextFormField(
                  decoration: InputDecoration(labelText: "Category"),
                  controller: category,
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Please fill subject";
                    }
                  },
                  onSaved: (value) => print(value),
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: "Describe"),
                  controller: describe,
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
                                    Firestore.instance.collection('bandnames');

                                await reference.add({
                                  "cause": cause.text,
                                  "symptom": symptom.text,
                                  "category": category.text,
                                  "describe": describe.text,
                                });
                                cause.clear();
                                symptom.clear();
                                category.clear();
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
    category.dispose();
    describe.dispose();
    super.dispose();
  }
}
