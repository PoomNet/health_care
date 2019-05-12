import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:myapp/screens/home_screen.dart';
import 'package:myapp/screens/signup_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

GoogleSignIn _googleSignIn = new GoogleSignIn(
  scopes: <String>[
    'email',
  ],
);

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  GoogleSignInAccount _currentUser;

  Future<Null> _handleSignIn() async {
    try {
      _currentUser = await _googleSignIn.signIn();
      print(_currentUser);
    } catch (error) {
      print(error);
    }
  }

  TextEditingController ctrlUsername = TextEditingController();
  TextEditingController ctrlPassword = TextEditingController();

  final _formkey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body : Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage('assets/pic/login-bg.jpg'))),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Form(
                key: _formkey,
                child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text('Health Care', style: TextStyle(fontSize: 40.0, color: Colors.grey, fontWeight: FontWeight.bold), ),
                  SizedBox(
                    height: 150.0,
                  ),
                  TextFormField(
                    validator: (String value ){
                      if (value.isEmpty) return 'กรุณาใส่ข้อมูล';
                    },
                    controller: ctrlUsername,
                    decoration: InputDecoration(
                      errorStyle: TextStyle(fontSize: 10.0),
                      prefixIcon: Icon(Icons.person),
                      labelText: 'Username',
                      filled: true,
                      fillColor: Colors.white54,
                      border: InputBorder.none
                    ),
                  ),SizedBox(
                    height: 15.0,
                  ),
                  TextFormField(
                    validator: (String value ){
                      if (value.isEmpty) return 'กรุณาใส่รหัสผ่าน';
                    },
                    controller: ctrlPassword,
                    obscureText: true,
                    decoration: InputDecoration(
                      errorStyle: TextStyle(fontSize: 10.0),
                      prefixIcon: Icon(Icons.vpn_key),
                      labelText: 'Password',
                      filled: true,
                      fillColor: Colors.white54,
                      border: InputBorder.none
                    ),
                  ),SizedBox(
                    height: 20.0,
                  ),
                  RaisedButton(
                    onPressed: () => doLogin() , color: Colors.pink[200], child: Text('Login', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),),
                  ),FlatButton(
                    onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpPage()));}, child: Text('Sign Up', style: TextStyle(color: Colors.white, fontSize: 10),),
                  ),
                  FlatButton(
                    onPressed: () {}, child: Text('Forget Password', style: TextStyle(color: Colors.white, fontSize: 10),),
                  ),Divider(
                    height: 20.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      FloatingActionButton(child: Icon(FontAwesomeIcons.google, color: Colors.red,),backgroundColor: Colors.white,onPressed: () => _handleSignIn(),),

                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
  doLogin() {

    if (_formkey.currentState.validate()){

      String username = ctrlUsername.text;
      String password = ctrlPassword.text;

      if (username == 'waiwarit' && password == '123456'){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MainPage()));
      } else{
        print('invaild');
      }
    }
  }


}