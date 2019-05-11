import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';

import 'current_post.dart';
import 'post_describe.dart';
import 'post_screen.dart';


class PostDescribeScreen extends StatefulWidget {
  //โชแต่ละโพสทั้งหมด
  @override
  State<StatefulWidget> createState() => new PostDescribeScreenState();
  // TODO: implement createState

}

class PostDescribeScreenState extends State<PostDescribeScreen> {
  Widget _buildTodoItem(BuildContext context, DocumentSnapshot document) {
    return Card(
        child: ListTile(
      title: Text(document['cause']),
      subtitle: Text(document['symptom']),
      onTap: () {
        Currentpost.CAUSE = document['cause'];
        Currentpost.SYMPTOM = document['symptom'];
        Currentpost.DESCRIBE = document['describe'];
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Showpost()));
      },
    ));
  }

  void _addTodoItem() async {
    await Navigator.push(
        context, MaterialPageRoute(builder: (context) => Addpost()));
  }

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
                    new FloatingActionButton(
                      onPressed: () {},
                      child: Icon(Icons.add),
                    ),
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
              new FloatingActionButton(
                onPressed: () {},
                child: Icon(Icons.add),
              );
            }
          },
        ),
        // floatingActionButton: FloatingActionButton(
        //     child: Icon(Icons.add),
        //     onPressed: () {
        //       Navigator.push(
        //           context, MaterialPageRoute(builder: (context) => Addpost()));
        //     })
            );
  }
}
