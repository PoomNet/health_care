import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('HealthCare'),
      ),
      body: Center(
        child: Text('Main Page', style: TextStyle(fontSize: 45.0, color: Colors.black54),),
      ),
    );
  }
}