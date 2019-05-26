import 'package:flutter/material.dart';
import 'package:myapp/screens/current_login.dart';
import 'package:myapp/screens/current_post.dart';
import 'package:myapp/data/users.dart';
import 'package:myapp/screens/likepost.dart';
import 'package:myapp/screens/show_user_post.dart';

import 'addimagepro.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key key}) : super(key: key);


  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       body: Container(
           decoration: new BoxDecoration(
          image: new DecorationImage(
            image: new AssetImage("assets/pic/bg.jpg"),
            fit: BoxFit.cover,
          ),
        ),
         child: Center(
           
           child: Column(
           children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Image.asset('assets/pic/user.png', width: 100,),
              ),
              
              ListTile(
                 leading: Icon(Icons.person),
                 title: Center(
                   child: Row(children: <Widget>[
                          Text('User : ',style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(Currentlogin.USER),
                   ],),
                 )

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
                RaisedButton(
              shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),


              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => UserPostPage()));

              },
              textColor: Colors.white,
            padding: const EdgeInsets.all(0.0),
            child: Container(
              decoration: new BoxDecoration(
                gradient: LinearGradient(
                  colors: <Color>[
                    Color(0xFFF06292),
                    Color(0xFFF48FB1),
                    Color(0xFFF8BBD0),

                  ],
                ),
                borderRadius: new BorderRadius.circular(20.0),

              ),
              padding: const EdgeInsets.all(10.0),
              child: const Text(
                'Your Post',
                style: TextStyle(fontSize: 15)
              ),
              
            ),
          ),

          SizedBox(width: 10,),
                       RaisedButton(
              shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),


              onPressed: () {
                 Navigator.push(context, MaterialPageRoute(builder: (context) => LikePostPage()));

              },
              textColor: Colors.white,
            padding: const EdgeInsets.all(0.0),
            child: Container(
              decoration: new BoxDecoration(
                gradient: LinearGradient(
                  colors: <Color>[
                    Color(0xFFF06292),
                    Color(0xFFF48FB1),
                    Color(0xFFF8BBD0),

                  ],
                ),
                borderRadius: new BorderRadius.circular(20.0),

              ),
              padding: const EdgeInsets.all(10.0),
              child: const Text(
                'The Post You Like',
                style: TextStyle(fontSize: 15)
              ),
              
            ),
          ), 
          RaisedButton(
            child: Text("add pro"),
            onPressed:(){
               Navigator.push(context, MaterialPageRoute(builder: (context) => Addimagepro()));
            },
          )
     
                
              ],
            ),

             
           
           ],
         )),
       ),
    );
  }
}