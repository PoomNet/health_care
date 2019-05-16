import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/screens/post_describe.dart';

import 'current_post.dart';


class PostPage extends StatefulWidget {
  PostPage({Key key}) : super(key: key);

  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  Widget _buildTodoItem(BuildContext context, DocumentSnapshot document) {
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
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Showpost()));
      },
    ));
  }

  // void _addTodoItem() async {
  //   await Navigator.push(
  //       context, MaterialPageRoute(builder: (context) => Addpost()));
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder(
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
              return ListView.builder(
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) =>
                    _buildTodoItem(context, snapshot.data.documents[index]),
              );
            }
          },
        ),
            );
  }
}