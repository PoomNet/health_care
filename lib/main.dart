import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:myapp/screens/home_screen.dart';
import 'package:myapp/screens/signup_screen.dart';
import 'package:myapp/screens/root_page.dart';
import 'package:myapp/services/authentication.dart';

import 'screens/login_screen.dart';


void main() {
  runApp(new MyApp());
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Healthcare',
      theme: ThemeData(primaryColor: Colors.pink),
      home: RootPage(auth: new Auth()),
      debugShowCheckedModeBanner: false,
    );
  }
}