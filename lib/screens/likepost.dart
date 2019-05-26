import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/data/users.dart';
import 'package:myapp/screens/post_describe.dart';
import 'package:myapp/screens/sqlpost.dart';

import 'current_post.dart';

class LikePostPage extends StatefulWidget {
  
  LikePostPage();

  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<LikePostPage> {
  List<ProfileItem> _todoItems = List();
  DataAccess _dataAccess= DataAccess();
  var comment = [];
  var post = [];
  var user;
  var check_user = 0;
  var check_post = 0;

  @override
  initState() {
    super.initState();
    _dataAccess.open().then((result) {
      _dataAccess.getAllUser().then((r) {
        for (var i = 0; i < r.length; i++) {
            setState(() {
              _todoItems.add(r[i]);
            });
        }
        print(_todoItems);
      });
    });
  }

  Widget _buildPost(BuildContext context, List<ProfileItem> document) {
    return ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: document.length,
                        itemBuilder: (context, index) =>
                            new Card(
                              color: Colors.pink[50],
        margin: const EdgeInsets.all(10),
          child: ListTile(
      title: Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Row(
            children: <Widget>[
              Text('Topic : ',style: TextStyle(fontWeight: FontWeight.bold)),
              Text(document[index].cause),
            ],
          ),
        ),       
        subtitle: Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Row(
            children: <Widget>[
              Text('Describe : ',style: TextStyle(fontWeight: FontWeight.bold)),
              Text(document[index].symptom),            
              ],
          ),
        ),              
        
        
        onTap: () {
          Currentpost.CAUSE = document[index].cause;
          Currentpost.SYMPTOM = document[index].symptom;
          Currentpost.DESCRIBE = document[index].describe;
          Currentpost.CATEGORY = document[index].category;
          Currentpost.USER = document[index].user;
          Currentpost.IMAGE = document[index].image;
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
      )),
                      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("flutter"),
        ),
        body: _buildPost(context, _todoItems)
        );
  }
}
