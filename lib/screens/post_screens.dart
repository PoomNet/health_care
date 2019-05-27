import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/rendering.dart';
import 'package:myapp/screens/post_describe.dart';
import 'package:carousel_pro/carousel_pro.dart';

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
      return RaisedGradientButton(
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 150, right: 5),
              child: Text(
                "ค้นหาตามหมวดหมู่",
                style: TextStyle(color: Colors.white),
              ),
            ),
            Icon(Icons.search, color: Colors.white)
          ],
        ),
        gradient: LinearGradient(
          colors: <Color>[Color(0xff843270), Color(0xff8e5981)],
        ),
        onPressed: () {
          setState(() {
            filter = true;
          });
        },
      );
    } else {
      return Column();
    }
  }

  Widget _buildRadio() {
    if (filter) {
      return Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: new Align(
                alignment: Alignment.centerLeft,
                child: new Text(
                  "สุขภาพทั่วไป",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                )),
          ),
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: new Align(
                alignment: Alignment.centerLeft,
                child: new Text(
                  "เพศ",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                )),
          ),
          Row(
            children: <Widget>[
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
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: new Align(
                alignment: Alignment.centerLeft,
                child: new Text(
                  "เพิ่มเติม",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                )),
          ),
          Row(
            children: <Widget>[
              new Radio(
                value: 7,
                groupValue: _radioValue,
                onChanged: _handleRadioValueChange,
              ),
              new Text('ทั้งหมด'),
              new Radio(
                value: 3,
                groupValue: _radioValue,
                onChanged: _handleRadioValueChange,
              ),
              new Text('อุบัติเหตุ'),
              new Radio(
                value: 6,
                groupValue: _radioValue,
                onChanged: _handleRadioValueChange,
              ),
              new Text('อื่นๆ'),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 5),
            child: RaisedGradientButton(
              child: Text("Close", style: TextStyle(color: Colors.white)),
              gradient: LinearGradient(
                colors: <Color>[Color(0xff843270), Color(0xff8e5981)],
              ),
              onPressed: () {
                setState(() {
                  filter = false;
                });
              },
            ),
          )
        ],
      );
    } else {
      return Container(
        height: 200,
        child: Carousel(
          boxFit: BoxFit.cover,
          images: [
            AssetImage('assets/pic/carou1.jpg'),
            AssetImage('assets/pic/carou2.jpg'),
            AssetImage('assets/pic/carou3.jpg'),
            AssetImage('assets/pic/carou4.jpg'),
            AssetImage('assets/pic/carou5.jpg')
          ],
          animationCurve: Curves.fastOutSlowIn,
          animationDuration: Duration(microseconds: 2000),
        ),
      );
    }
  }

  Widget _buildPost(BuildContext context, DocumentSnapshot document) {
    if (category == "all") {
      var check_user = 0;
      var check_post = 0;
      return Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          color: Colors.pink[50],
          margin: const EdgeInsets.all(10),
          child: ListTile(
            leading: Icon(Icons.person),
            trailing: Icon(Icons.keyboard_arrow_right),
            title: Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Wrap(
                children: <Widget>[
                  Text('Topic : ',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(document['cause']),
                ],
              ),
            ),
            subtitle: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: Wrap(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text('Symptom : ' + document['symptom'],
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 2),
                  child: Wrap(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text('Published by : ' + document['user'],
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                )
              ],
            ),
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
                    if (data.value[check_user]['post'][check_post]
                            ['describe'] ==
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
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          color: Colors.pink[50],
          child: Container(
            child: ListTile(
              leading: Icon(Icons.person),
              trailing: Icon(Icons.keyboard_arrow_right),
              title: Padding(
                padding: const EdgeInsets.only(top: 2, bottom: 2),
                child: Wrap(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Topic : ' + document['cause'],
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
              subtitle: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: Wrap(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text('Symptom : ' + document['symptom'],
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 2),
                    child: Wrap(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text('Published by : ' + document['user'],
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  )
                ],
              ),
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
                  for (check_user;
                      check_user < data.value.length;
                      check_user++) {
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
                      if (data.value[check_user]['post'][check_post]
                              ['describe'] ==
                          Currentpost.DESCRIBE) {
                        break;
                      }
                    }
                  }
                  comment =
                      data.value[check_user]['post'][check_post]['comment'];
                  Currentpost.COMMENT = comment;
                });
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Showpost()));
              },
            ),
          ));
    } else {
      return Column();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(children: <Widget>[
      Column(
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
                  height: 600,
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: snapshot.data.documents.length,
                    itemBuilder: (context, index) =>
                        _buildPost(context, snapshot.data.documents[snapshot.data.documents.length-index-1]),
                  ),
                );
              }
            },
          ),
        ],
      ),
    ]));
  }
}

//customize button
class RaisedGradientButton extends StatelessWidget {
  final Widget child;
  final Gradient gradient;
  final double width;
  final double height;
  final Function onPressed;

  const RaisedGradientButton({
    Key key,
    @required this.child,
    this.gradient,
    this.width = double.infinity,
    this.height = 50.0,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 35.0,
      decoration: BoxDecoration(gradient: gradient, boxShadow: [
        BoxShadow(
          color: Colors.grey[500],
          offset: Offset(0.0, 1.5),
          blurRadius: 1.5,
        ),
      ]),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
            onTap: onPressed,
            child: Center(
              child: child,
            )),
      ),
    );
  }
}
