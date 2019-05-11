import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:myapp/screens/map_screen.dart';
import 'package:myapp/screens/post_screens.dart';
import 'package:myapp/screens/profile_screen.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  int currentIndex = 0;
  List pages = [PostPage(), MyMapPage(), ProfilePage()];


  

  @override
  Widget build(BuildContext context) {

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
    title: Text('HelthCare', style: myStyle ),centerTitle: true,);

    Widget floatingAction = FloatingActionButton(
    backgroundColor: Colors.red
    ,onPressed: () {}, child: Icon(Icons.add),);

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
          backgroundImage: NetworkImage('https://randomuser.me/api/portraits/med/women/69.jpg'),
        // backgroundColor: Colors.white10,
         ),
        ),
      
      ListTile(
        leading: Icon(Icons.home),
        title: Text('หน้าหลัก'),
        trailing: Icon(Icons.keyboard_arrow_down),
        onTap: () {

        },
      ),
      ListTile(
        leading:Icon(Icons.settings),
        title: Text('ตั้งค่า'),
        subtitle: Text('ตั่งค่าผู้ใช้'),
        trailing: Icon(Icons.arrow_drop_down),
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
        leading:Icon(Icons.group),
        title: Text('ออกจากระบบ'),
        subtitle: Text('Logout'),
        trailing: Icon(Icons.keyboard_return),
        onTap: () {
        },
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