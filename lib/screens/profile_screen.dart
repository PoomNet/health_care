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

            ListTile(
               leading: Icon(Icons.person),
               title: Row(children: <Widget>[
                      Text('User : ',style: TextStyle(fontWeight: FontWeight.bold)),
                Text(Currentlogin.USER),
               ],)

           ),

           ListTile(
               leading: Icon(Icons.email),
               title: Row(children: <Widget>[
                  Text('E-mail : ',style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(Currentlogin.EMAIL),
               ],)

           ),

          
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RaisedButton(child: Text("YOUR POST"),
           onPressed: (){
            //  UserPostPage
            Navigator.push(context, MaterialPageRoute(builder: (context) => UserPostPage()));
           },),
                ),
           Padding(
             padding: const EdgeInsets.all(8.0),
             child: Row(
              children: <Widget>[
                 RaisedButton(child: Row(
                   children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(right : 8.0),
                        child: Text("THE POST YOU LIKE"),
                      ),
                      Icon(Icons.favorite_border)
                   ],
                 ),
             onPressed: (){
               Navigator.push(context, MaterialPageRoute(builder: (context) => LikePostPage()));
             },),
              ],
             ),
            
           )
              
            ],
          ),
           
         
         ],
       )),
    );
  }
}