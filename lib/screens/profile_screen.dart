import 'package:flutter/material.dart';
import 'package:myapp/screens/current_login.dart';
import 'package:myapp/screens/current_post.dart';
import 'package:myapp/data/users.dart';
import 'package:myapp/screens/likepost.dart';
import 'package:myapp/screens/show_user_post.dart';

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
           Text(Currentlogin.EMAIL),
           Text(Currentlogin.USER),
           RaisedButton(child: Text("YOUR POST"),
           onPressed: (){
            //  UserPostPage
            Navigator.push(context, MaterialPageRoute(builder: (context) => UserPostPage()));
           },),
           RaisedButton(child: Text("The post u like"),
           onPressed: (){
             Navigator.push(context, MaterialPageRoute(builder: (context) => LikePostPage()));
           },)
         ],
       )),
    );
  }
}