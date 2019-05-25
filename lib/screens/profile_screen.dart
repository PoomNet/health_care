import 'package:flutter/material.dart';
import 'package:myapp/screens/current_post.dart';
import 'package:myapp/data/users.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key key}) : super(key: key);


  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       body: Center(child: Column(
         children: <Widget>[
           Text(Currentpost.EMAIL),
           Text(Currentpost.USER),
           RaisedButton(child: Text("YOUR POST"),
           onPressed: (){},),
           RaisedButton(child: Text("The post u like"),
           onPressed: (){},)
         ],
       )),
    );
  }
}