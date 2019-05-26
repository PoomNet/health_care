import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:myapp/data/users.dart';
import 'package:myapp/screens/addpost_screen.dart';
import 'package:myapp/screens/current_login.dart';
import 'package:myapp/screens/current_post.dart';
import 'package:myapp/screens/login_screen.dart';
import 'package:myapp/screens/map_screen.dart';
import 'package:myapp/screens/post_screens.dart';
import 'package:myapp/screens/profile_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/services/authentication.dart';

import '../map.dart';

GoogleSignIn _googleSignIn = new GoogleSignIn(
  scopes: <String>[
    'email',
  ],
);

class MainPage extends StatefulWidget {
  MainPage({Key key, this.userinfo, this.onSignedOut, this.auth})
      : super(key: key);
  final User userinfo;
  final VoidCallback onSignedOut;
  final BaseAuth auth;

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  var user="12";
  var email="12";
  var check_user = 0;
  var img = "https://firebasestorage.googleapis.com/v0/b/healthcare-ce7be.appspot.com/o/user-icon.png?alt=media&token=cfe54db6-e40d-4771-b8ce-1c0edae35f23";

  static final FacebookLogin facebookSignIn = new FacebookLogin();

  Future<Null> _handleSignOut() async {
    await facebookSignIn.logOut();

    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginSignUpPage()));
  }

  @override
  initState() {
    super.initState();
    // Add listeners to this class
    FirebaseDatabase.instance.reference().once().then((DataSnapshot data) {
      print(data.value.length);
      print("This is " + widget.userinfo.email);
      print(Currentpost.USER);
      setState(() {
        print(111111);
        user=Currentlogin.USER;
        email=Currentlogin.EMAIL;
      });

      for (check_user; check_user < data.value.length; check_user++) {
        print(data.value.length.runtimeType);
        print(check_user < data.value.length);
        print(check_user);
        if (data.value[check_user] != null) {
          if (data.value[check_user]['user']['name'] ==
              widget.userinfo.displayname) {
            //ใส่ชื่อuserไว้เชคว่ามีแล้วหรือยัง
            if (data.value[check_user]['user']['image'] != null) {
              setState(() {
                img = data.value[check_user]['user']['image'];
              Currentlogin.IMAGE=img;
              });
            }

            break;
          } else if (check_user == data.value.length - 1) {
            FirebaseDatabase.instance
                .reference()
                .child((check_user + 1).toString())
                .child("user")
                .set({
              "name": Currentlogin.USER, //ใส่ข้อมูลuser
            });
            break;
          }
        }
      }
    });
  }

  _signOut() async {
    await widget.auth.signOut();
    widget.onSignedOut();
  }

  int currentIndex = 0;
  List pages = [PostPage(), Map_Screen(), ProfilePage()];

  Widget name(){
    if(widget.userinfo.displayname==null){
      return Column();
    }
    else{
      return UserAccountsDrawerHeader(
          currentAccountPicture: CircleAvatar(
            backgroundColor: Colors.white10,
          ),
          accountName: Text(widget.userinfo.displayname),
          accountEmail: Text(widget.userinfo.email),
          decoration: BoxDecoration(
               image: DecorationImage(fit: BoxFit.cover, image: NetworkImage(img))

              ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    // print(Currentpost.USER);

    // Currentpost.USER=widget.userinfo.displayname;

    TextStyle myStyle = TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold);

    Widget bottomNavbar = BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (int index) {
        setState(() {
          currentIndex = index;
        });
      },
      items: [
        BottomNavigationBarItem(
            icon: Icon(Icons.home), title: Text('หน้าจอหลัก')),
        BottomNavigationBarItem(
            icon: Icon(Icons.map), title: Text('ตำแหน่งของคุณ')),
        BottomNavigationBarItem(
            icon: Icon(Icons.people), title: Text('Profile'))
      ],
    );

    Widget appBar = AppBar(
      title: Text('HealthCare', style: myStyle),
      centerTitle: true,
      actions: <Widget>[
        new IconButton(icon: new Icon(Icons.search), onPressed: () {}),
      ],
    );

    Widget floatingAction = FloatingActionButton(
      backgroundColor: Colors.red,
      onPressed: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => AddPage(widget.userinfo)));
      },
      child: Icon(Icons.add),
    );

    Widget drawer = Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the Drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
      // Important: Remove any padding from the ListView.
      padding: EdgeInsets.zero,
      children: <Widget>[
        name(),
        ListTile(
          leading: Icon(Icons.home),
          title: Text('หน้าหลัก'),
          trailing: Icon(Icons.keyboard_arrow_right),
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => PostPage()));
          },
        ),
        ListTile(
          leading: Icon(Icons.settings),
          title: Text('ตั้งค่า'),
          subtitle: Text('ตั่งค่าผู้ใช้'),
          trailing: Icon(Icons.keyboard_arrow_right),
          onTap: () {},
        ),
        SizedBox(
          height: 50,
        ),
        Divider(
          height: 30,
          color: Colors.black,
        ),
        ListTile(
          leading: Icon(Icons.exit_to_app),
          title: Text('ออกจากระบบ'),
          subtitle: Text('Logout'),
          onTap: () => _signOut(),
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
