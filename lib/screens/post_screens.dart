import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/screens/post_describe.dart';

import 'current_post.dart';

class PostPage extends StatefulWidget {
  PostPage({Key key}) : super(key: key);

  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  var category = 'all';
  int _radioValue = 7;
  var filter = false;

  var comment = [];
  var post = [];
  var user;
  var check_user = 0;
  var check_post = 0;

  void _handleRadioValueChange(int value) {
    setState(() {
      _radioValue = value;
    });
    setState(() {
      switch (_radioValue) {
        case 7:
          category = 'all';
          break;
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

  Widget _buildfilterBut() {
    if (!filter) {
      return RaisedButton(
        child: Text("Filter"),
        onPressed: () {
          setState(() {
            filter = true;
          });
        },
      );
    } else {
      return Column(
      );
    }
  }

  Widget _buildRadio() {
    if (filter) {
      return Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              new Radio(
                value: 7,
                groupValue: _radioValue,
                onChanged: _handleRadioValueChange,
              ),
              new Text('all'),
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
          RaisedButton(
            child: Text("Close"),
            onPressed: () {
              setState(() {
                filter = false;
              });
            },
          )
        ],
      );
    } else {
      return Column();
    }
  }

  Widget _buildPost(BuildContext context, DocumentSnapshot document) {
    if (category == "all") {
      var check_user = 0;
      var check_post = 0;
      return Card(
          child: ListTile(
        title: Text(document['cause']),
        subtitle: Text(document['symptom']),
        onTap: () {
          Currentpost.CAUSE = document['cause'];
          Currentpost.SYMPTOM = document['symptom'];
          Currentpost.DESCRIBE = document['describe'];
          Currentpost.CATEGORY = document['category'];
          Currentpost.USER = document['user'];
          Currentpost.IMAGE = document['image'];
          FirebaseDatabase.instance
              .reference()
              .once()
              .then((DataSnapshot data) {
            for (check_user; check_user < data.value.length; check_user++) {
              if (data.value[check_user] != null) {
                if (data.value[check_user]['user']['name'] ==
                    Currentpost.USER) {
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
            comment = data.value[check_user]['post'][check_post]['comment'];
            Currentpost.COMMENT = comment;
          });
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Showpost()));
        },
      ));
    } else if (category == document['category']) {
      var check_user = 0;
      var check_post = 0;
      print(category);
      print(document['category']);
      return Card(
          child: ListTile(
        title: Text(document['cause']),
        subtitle: Text(document['symptom']),
        onTap: () {
          Currentpost.CAUSE = document['cause'];
          Currentpost.SYMPTOM = document['symptom'];
          Currentpost.DESCRIBE = document['describe'];
          Currentpost.CATEGORY = document['category'];
          Currentpost.USER = document['user'];
          Currentpost.IMAGE = document['image'];
          FirebaseDatabase.instance
              .reference()
              .once()
              .then((DataSnapshot data) {
            for (check_user; check_user < data.value.length; check_user++) {
              if (data.value[check_user] != null) {
                if (data.value[check_user]['user']['name'] ==
                    Currentpost.USER) {
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
            comment = data.value[check_user]['post'][check_post]['comment'];
            Currentpost.COMMENT = comment;
          });
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Showpost()));
        },
      ));
    }
    else{
      return Column();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: <Widget>[
        _buildfilterBut(),
        _buildRadio(),
        StreamBuilder(
          stream: Firestore.instance.collection('post').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: Column(
                  children: <Widget>[
                    Text(
                      "No Data Found..",
                      textAlign: TextAlign.center,
                    )
                  ],
                ),
              );
            } else {
              return Container(
                  height: 300,
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: snapshot.data.documents.length,
                    itemBuilder: (context, index) =>
                        _buildPost(context, snapshot.data.documents[index]),
                  ));
            }
          },
        ),
      ],
    ));
  }
}