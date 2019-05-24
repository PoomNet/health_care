import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/data/users.dart';
import 'package:myapp/screens/post_describe.dart';

import 'current_post.dart';

class UserPostPage extends StatefulWidget {
  User userinfo;
  UserPostPage(this.userinfo);

  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<UserPostPage> {

  var comment = [];
  var post = [];
  var user;
  var check_user = 0;
  var check_post = 0;


  Widget _buildPost(BuildContext context, DocumentSnapshot document) {
    if (document['user'] == widget.userinfo.displayname) {
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
    }
    else{
      return Column();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("flutter"),),
        body: Column(
      children: <Widget>[
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
