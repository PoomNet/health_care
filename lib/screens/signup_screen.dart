import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {

  final _formkey = GlobalKey<FormState>();
  TextEditingController fullName;
  TextEditingController phoneNumber;
  TextEditingController email;
  TextEditingController password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Back'),
        backgroundColor: Colors.pinkAccent[100]
      ),
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage('assets/pic/login-bg.jpg'))),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Form(
              key: _formkey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Sign Up', style: TextStyle(fontSize: 30, color: Colors.white),),
                  ),
                  TextFormField(
                      validator: (String value ){
                        if (value.isEmpty) return 'กรุณาใส่ข้อมูล';
                      },
                      controller: fullName,
                      decoration: InputDecoration(
                        errorStyle: TextStyle(fontSize: 10.0),
                        prefixIcon: Icon(Icons.person),
                        labelText: 'Fullname',
                        filled: true,
                        fillColor: Colors.white24,
                        border: InputBorder.none,
                        labelStyle: TextStyle(fontSize: 15)
                      ),
                  ),SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                      validator: (String value ){
                        if (value.isEmpty) return 'กรุณาอีเมลล์';
                      },
                      controller: email,
                      decoration: InputDecoration(
                        errorStyle: TextStyle(fontSize: 10.0),
                        prefixIcon: Icon(Icons.email),
                        labelText: 'Email',
                        filled: true,
                        fillColor: Colors.white24,
                        border: InputBorder.none,
                        labelStyle: TextStyle(fontSize: 15)
                      ),
                  ),SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                      validator: (String value ){
                        if (value.isEmpty) return 'กรุณาเบอร์โทรศัพท์';
                      },
                      controller: phoneNumber,
                      decoration: InputDecoration(
                        errorStyle: TextStyle(fontSize: 10.0),
                        prefixIcon: Icon(Icons.phone_in_talk),
                        labelText: 'Telephone',
                        filled: true,
                        fillColor: Colors.white24,
                        border: InputBorder.none,
                        labelStyle: TextStyle(fontSize: 15)
                      ),
                  ),SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                      validator: (String value ){
                        if (value.isEmpty) return 'กรุณาระบุ Password';
                      },
                      controller: password,
                      obscureText: true,
                      decoration: InputDecoration(
                        errorStyle: TextStyle(fontSize: 10.0),
                        prefixIcon: Icon(Icons.vpn_lock),
                        labelText: 'Password',
                        filled: true,
                        fillColor: Colors.white24,
                        border: InputBorder.none,
                        labelStyle: TextStyle(fontSize: 15)
                      ),
                  ),SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                      validator: (String value ){
                        if (value.isEmpty) return 'กรุณาระบุ Confirm Password';
                      },
                      controller: phoneNumber,
                      decoration: InputDecoration(
                        errorStyle: TextStyle(fontSize: 10.0),
                        prefixIcon: Icon(Icons.vpn_key),
                        labelText: 'Confirm Password',
                        filled: true,
                        fillColor: Colors.white24,
                        border: InputBorder.none,
                        labelStyle: TextStyle(fontSize: 15)
                      ),
                  ),SizedBox(
                    height: 10.0,
                  ),
                  RaisedButton(
                    onPressed: () => doSignUp() , color: Colors.pink[300], child: Text('Register', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),),)
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
  doSignUp(){
    if (_formkey.currentState.validate()){



     
    }

  }
}