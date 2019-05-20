import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_demo/services/authentication.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_login_demo/models/todo.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatefulWidget {
  HomePage({
    Key key, this.auth, this.userId, this.onSignedOut,this.user,
    
    }
    ) 
      : super(key: key);
  final BaseAuth auth;
  final VoidCallback onSignedOut;
  final String userId;
  final String user;
  @override
  String name(){
    return this.userId;
  }

  @override
  State<StatefulWidget> createState() => new _HomePageState();
}
class _HomePageState extends State<HomePage> {
  List<Todo> _todoList;
  
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final DocumentReference documentReference = Firestore.instance.document("baby/dummy");
  final _textEditingController = TextEditingController();
  StreamSubscription<Event> _onTodoAddedSubscription;
  StreamSubscription<Event> _onTodoChangedSubscription;
  
  bool _isEmailVerified = false;
  void _add() {
    Map<String, dynamic> data = <String, dynamic>{
      "name": "Pawan Kumar",
      "test": 'abcd'
    };
    documentReference.setData(data).whenComplete(() {
    }).catchError((e) => print(e));
  }
  _signOut() async {
      try {
        await widget.auth.signOut();
        widget.onSignedOut();
      } catch (e) {
        print(e);
      }
    }
  @override
 Widget build(BuildContext context) {
   return Scaffold(
     appBar: new AppBar(
          title: new Text('Show Data in account'),
          actions: <Widget>[
            new FlatButton(
                child: new Text('${widget.user}',
                    style: new TextStyle(fontSize: 17.0, color: Colors.white)),
                onPressed: _signOut)
          ],
        ),
     body: _buildBody(context),
  
     
   );
 }

 Widget _buildBody(BuildContext context) {
 return StreamBuilder<QuerySnapshot>(
   stream: Firestore.instance.collection('register').where('name',isEqualTo: widget.user).snapshots(),
   builder: (context, snapshot) {
     if (!snapshot.hasData) return LinearProgressIndicator();

     return _buildList(context, snapshot.data.documents);
   },
 );
}

 Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
   return ListView(
     padding: const EdgeInsets.only(top: 20.0),
     children: snapshot.map((data) => _buildListItem(context, data)).toList(),
   );
 }

 Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
 final record = Record.fromSnapshot(data);
   return Padding(
     key: ValueKey(record.name),
     padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
     child: Container(
       decoration: BoxDecoration(
         border: Border.all(color: Colors.grey),
         borderRadius: BorderRadius.circular(5.0),
       ),
       child: ListTile(
         title: Text(record.name),
         trailing: Text(record.votes.toString()+"  -Km:  "+record.km.toString()),
         onTap: () => record.reference.updateData({'votes': record.votes + 1}),
       ),
     ),
   );
 }
}

class Record {
 final String name;
 final String test;
 final int votes;
 final int km;
 final int id;
 final int tree;
 final DocumentReference reference;

 Record.fromMap(Map<String, dynamic> map, {this.reference})
     : assert(map['name'] != null ),
       assert(map['id'] != null||map['id'] == null),
       assert(map['name'] == null || map['name'] != null ),
       assert(map['km'] == null || map['km'] != null ),
       assert(map['tree'] == null || map['tree'] != null ),
       name = map['name'],
       votes = map['votes'],
       test = map['name'],
       km = map['km'],
       tree = map['tree'],
       id = map['votes'];
       
// void maia1(){
//   if (name == 'test'){
//     return 0
//   }
// }
 Record.fromSnapshot(DocumentSnapshot snapshot)
     : this.fromMap(snapshot.data, reference: snapshot.reference);

 @override
 String toString() => "Record<$name:$votes$km$tree>";
}