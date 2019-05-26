import 'package:flutter/material.dart';
import 'package:myapp/screens/current_login.dart';
import 'package:myapp/screens/login_screen.dart';
import 'package:myapp/services/authentication.dart';
import 'package:myapp/screens/post_screens.dart';
import 'package:myapp/screens/home_screen.dart';
import 'package:myapp/data/users.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/screens/current_post.dart';
class RootPage extends StatefulWidget {
  RootPage({this.auth});
  final BaseAuth auth;
  @override
  State<StatefulWidget> createState() => new _RootPageState();
}
enum AuthStatus {
  NOT_DETERMINED,
  NOT_LOGGED_IN,
  LOGGED_IN,
}

class _RootPageState extends State<RootPage> {
  AuthStatus authStatus = AuthStatus.NOT_DETERMINED;
  User user = User();
  String _userId = "";
  String _test ='';
  @override
  void initState() {
    super.initState();
    widget.auth.getCurrentUser().then((user) {
      setState(() {
        if (user != null) {
          _userId = user?.uid;
          _test = user.email;
        }
        authStatus =
            user?.uid == null ? AuthStatus.NOT_LOGGED_IN : AuthStatus.LOGGED_IN;
      });
    });
  }


  void _onLoggedIn() {
    widget.auth.getCurrentUser().then((user){
      setState(() {
        _userId = user.uid.toString();
        _test = user.email;
      });
    });
    setState(() {
      authStatus = AuthStatus.LOGGED_IN;
      
    });
  }

  void _onSignedOut() {
    setState(() {
      authStatus = AuthStatus.NOT_LOGGED_IN;
      _userId = "";
      _test = "";
    });
  }

  Widget _buildWaitingScreen() {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    switch (authStatus) {
      case AuthStatus.NOT_DETERMINED:
        return _buildWaitingScreen();
        break;
      case AuthStatus.NOT_LOGGED_IN:
        return new LoginSignUpPage(
          auth: widget.auth,
          onSignedIn: _onLoggedIn,
        );
        break;
      case AuthStatus.LOGGED_IN:
        if (_userId.length > 0 && _userId != null) {
          user.email =_test;
          Firestore _store = Firestore.instance;
   _store.collection('register')
   .document(user.email).get().then((doc){
    setState(() {
      user.displayname = doc.data['name'];
      Currentlogin.USER=doc.data['name'];
      Currentlogin.EMAIL=doc.data['email'];
      

    });
  });
          return new MainPage(
            userinfo: user,
            onSignedOut: _onSignedOut,
            auth: widget.auth,

          );
        } else return _buildWaitingScreen();
        break;
      default:
        return _buildWaitingScreen();
    }
  }
}
