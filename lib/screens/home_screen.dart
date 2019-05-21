import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:myapp/data/users.dart';
import 'package:myapp/screens/addpost_screen.dart';
import 'package:myapp/screens/current_post.dart';
import 'package:myapp/screens/login_screen.dart';
import 'package:myapp/screens/map_screen.dart';
import 'package:myapp/screens/post_screens.dart';
import 'package:myapp/screens/profile_screen.dart';

import '../map.dart';

GoogleSignIn _googleSignIn = new GoogleSignIn(
  scopes: <String>[
    'email',
  ],
);

class MainPage extends StatefulWidget {
  User userinfo;
  MainPage(this.userinfo);
  
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  static final FacebookLogin facebookSignIn = new FacebookLogin();

  Future<Null> _handleSignOut() async {

    await facebookSignIn.logOut();
    
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => LoginPage()));
  }

  

  int currentIndex = 0;
  List pages = [PostPage(), Map_Screen(), ProfilePage()];

  @override
  Widget build(BuildContext context) {

    Currentpost.USER=widget.userinfo.displayname;

    TextStyle myStyle = TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold);

    Widget bottomNavbar = BottomNavigationBar(currentIndex: currentIndex, 
    onTap: (int index){
      setState(() {
        currentIndex = index;
      });
    }
    ,items: [
    BottomNavigationBarItem(icon: Icon(Icons.home), title: Text('หน้าจอหลัก')),
    BottomNavigationBarItem(icon: Icon(Icons.map), title: Text('ตำแหน่งของคุณ')),
    BottomNavigationBarItem(icon: Icon(Icons.people), title: Text('Profile'))
    ],);

    Widget appBar = AppBar(
      title: Text('HelthCare', style: myStyle ),
      centerTitle: true,
      actions: <Widget>[
         new IconButton(icon: new Icon(Icons.search),onPressed: (){}),
        ],
      );

    Widget floatingAction = FloatingActionButton(
    backgroundColor: Colors.red
    ,onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context) => AddPage(widget.userinfo)));}, child: Icon(Icons.add),);

    Widget drawer = Drawer(
  // Add a ListView to the drawer. This ensures the user can scroll
  // through the options in the Drawer if there isn't enough vertical
  // space to fit everything.
    child: ListView(
    // Important: Remove any padding from the ListView.
    padding: EdgeInsets.zero,
    children: <Widget>[
      UserAccountsDrawerHeader(
        currentAccountPicture: CircleAvatar(
          backgroundImage: NetworkImage(widget.userinfo.photoUrl),
        // backgroundColor: Colors.white10,
         ),
         accountName: Text(widget.userinfo.displayname),
         accountEmail: Text(widget.userinfo.email),
         decoration: BoxDecoration(
           image: DecorationImage(fit: BoxFit.cover, image: NetworkImage(widget.userinfo.photoUrl))
         ),
        ),
      
      ListTile(
        leading: Icon(Icons.home),
        title: Text('หน้าหลัก'),
        trailing: Icon(Icons.keyboard_arrow_right),
        onTap: () {

        },
      ),
      ListTile(
        leading:Icon(Icons.settings),
        title: Text('ตั้งค่า'),
        subtitle: Text('ตั่งค่าผู้ใช้'),
        trailing: Icon(Icons.keyboard_arrow_right),
        onTap: () {
        },
      ),
      SizedBox(
        height: 50,
      ),Divider(
        height: 30,
        color: Colors.black,
      ),
      ListTile(
        leading:Icon(Icons.exit_to_app),
        title: Text('ออกจากระบบ'),
        subtitle: Text('Logout'),

        onTap: () => _handleSignOut(),
      ),
    ],
  ));


    return Scaffold(
      appBar: appBar,
      drawer: drawer,
      body: pages[currentIndex],
      floatingActionButton: floatingAction,
      bottomNavigationBar: bottomNavbar,
    );
  }
}