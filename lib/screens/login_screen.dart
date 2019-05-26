import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:myapp/data/users.dart';
import 'package:myapp/screens/root_page.dart';
import 'package:myapp/services/authentication.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

FirebaseAuth a;

GoogleSignIn _googleSignIn = new GoogleSignIn(
  scopes: <String>[
    'email',
  ],
);

class LoginSignUpPage extends StatefulWidget {
  LoginSignUpPage({this.auth, this.onSignedIn});
  final BaseAuth auth;
  final VoidCallback onSignedIn;

  @override
  State<StatefulWidget> createState() => new _LoginSignUpPageState();
}

enum FormMode { LOGIN, SIGNUP }

class _LoginSignUpPageState extends State<LoginSignUpPage> {
  GoogleSignInAccount _currentUser;
  static final FacebookLogin facebookSignIn = new FacebookLogin();

  Future<Null> _facebookLogin() async {
    final FacebookLoginResult result =
        await facebookSignIn.logInWithReadPermissions(['email']);

    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        final FacebookAccessToken accessToken = result.accessToken;
        print(accessToken.token);
        await getFacebookInfo(accessToken.token);
        break;
      case FacebookLoginStatus.cancelledByUser:
        print('Login cancelled by the user.');
        break;
      case FacebookLoginStatus.error:
        print('Something went wrong with the login process.\n'
            'Here\'s the error Facebook gave us: ${result.errorMessage}');
        break;
    }
  }

  Future<Null> _handleSignIn() async {
    try {
      _currentUser = await _googleSignIn.signIn();
      ctrlUsername.text = _currentUser.email;
      ctrlPassword.text = '002007Le';
      _validateAndSubmit();
    } catch (error) {
      print(error);
    }
  }

  Future getFacebookInfo(token) async {
    String url =
        'https://graph.facebook.com/v2.8/me?fields=picture.type(large),email,first_name,last_name&access_token=$token';
    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        ctrlUsername.text = jsonResponse['email'];
        ctrlPassword.text = '002007Le';
        _validateAndSubmit();
      } else {
        print('Connection error!!');
      }
    } catch (error) {
      print(error);
    }
  }

  final _formKey = new GlobalKey<FormState>();

  String _email;
  String _password;
  String _errorMessage;
  int type = 0;
  String _name;
  // String _tree;
  // String _km;
  // String _picture;
  // String _step;
  // String _usernam

  // Initial form is login form
  FormMode _formMode = FormMode.LOGIN;
  bool _isIos;
  bool _isLoading;

  // Check if form is valid before perform login or signup
  bool _validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  // Perform login or signup
  void _validateAndSubmit() async {
    String email = '';
    setState(() {
      _errorMessage = "";
      _isLoading = true;
    });
    if (_validateAndSave()) {
      String userId = "";
      final DocumentReference documentReference =
          Firestore.instance.document("register/" + _email);
      try {
        if (_formMode == FormMode.LOGIN) {
          userId = await widget.auth.signIn(_email, _password);
          print('Signed in: ${widget.auth.isEmailVerified()}');
        } else {
          userId = await widget.auth.signUp(_email, _password);
          widget.auth.sendEmailVerification();

          Map<String, dynamic> data = <String, dynamic>{
            "email": _email,
            "name": _name,
            "picture": ""
          };
          documentReference.setData(data).whenComplete(() {
            print("Document Added");
          }).catchError((e) => print(e));

          _showVerifyEmailSentDialog();
          print('Signed up user: $userId');
        }
        setState(() {
          _isLoading = false;
        });

        if (userId.length > 0 &&
            userId != null &&
            _formMode == FormMode.LOGIN) {
          widget.onSignedIn();
        }
      } catch (e) {
        print('Error: $e');
        setState(() {
          _isLoading = false;
          if (_isIos) {
            _errorMessage = e.details;
          } else
            _errorMessage = e.message;
        });
      }
    }
  }

  @override
  void initState() {
    _errorMessage = "";
    _isLoading = false;
    super.initState();
  }

  void _changeFormToSignUp() {
    _formKey.currentState.reset();
    _errorMessage = "";
    setState(() {
      _formMode = FormMode.SIGNUP;
    });
    this.type = 1;
  }

  void _changeFormToLogin() {
    _formKey.currentState.reset();
    _errorMessage = "";
    setState(() {
      _formMode = FormMode.LOGIN;
    });
    this.type = 0;
  }

  @override
  Widget build(BuildContext context) {
    _isIos = Theme.of(context).platform == TargetPlatform.iOS;
    return new Scaffold(
        appBar: new AppBar(
          title: new Text('Health Care'),
        ),
        body: Stack(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Image.asset('assets/pic/login-wall.jpg'),
                Container(
                  padding: new EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * .15,
                      right: 20.0,
                      left: 20.0),
                  child: Card(
                      child: Padding(
                    padding: EdgeInsets.all(10),
                    child: _showBody(),
                  )),
                )
              ],
            ),
            // _showCircularProgress(),
          ],
        ));
  }

  Widget _showCircularProgress() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    return Container(
      height: 0.0,
      width: 0.0,
    );
  }

  void _showVerifyEmailSentDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Verify your account"),
          content:
              new Text("Link to verify account has been sent to your email"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Dismiss"),
              onPressed: () {
                _changeFormToLogin();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _showBody() {
    return new Container(
        padding: EdgeInsets.all(16.0),
        child: new Form(
          key: _formKey,
          child: new ListView(
            shrinkWrap: true,
            children: <Widget>[
              // _showLogo(),
              _showEmailInput(),
              _showNameInput(),
              _showPasswordInput(),
              _showPrimaryButton(),
              _showSecondaryButton(),
              _showErrorMessage(),
              __showFoatingAction()
            ],
          ),
        ));
  }

  bool visible = false;
  Widget _showNameInput() {
    type == 1 ? visible = true : visible = false;
    return Visibility(
      visible: visible,
      child: Padding(
        padding: const EdgeInsets.only(top: 10, right: 10),
        child: new TextFormField(
          maxLines: 1,
          keyboardType: TextInputType.text,
          autofocus: false,
          decoration: new InputDecoration(
              hintText: 'Name',
              icon: new Icon(
                Icons.person,
                color: Colors.grey,
              )),
          validator: (value) => value.isEmpty ? 'Name can\'t be empty' : null,
          onSaved: (value) => _name = value,
        ),
      ),
    );
  }

  Widget _showErrorMessage() {
    if (_errorMessage.length > 0 && _errorMessage != null) {
      return new Text(
        _errorMessage,
        style: TextStyle(
            fontSize: 13.0,
            color: Colors.red,
            height: 1.0,
            fontWeight: FontWeight.w300),
      );
    } else {
      return new Container(
        height: 0.0,
      );
    }
  }

  // Widget _showLogo() {
  //   return new Hero(
  //     tag: 'hero',
  //     child: Padding(
  //       padding: EdgeInsets.fromLTRB(0.0, 70.0, 0.0, 0.0),
  //       child: CircleAvatar(
  //         backgroundColor: Colors.transparent,
  //         radius: 48.0,
  //         child: Image.asset('assets/flutter-icon.png'),
  //       ),
  //     ),
  //   );
  // }
  TextEditingController ctrlUsername = TextEditingController();
  TextEditingController ctrlPassword = TextEditingController();

  Widget _showEmailInput() {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: new TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.emailAddress,
        controller: ctrlUsername,
        autofocus: false,
        decoration:
            new InputDecoration(icon: Icon(Icons.email), hintText: 'Email'),
        validator: (value) => value.isEmpty ? 'Email can\'t be empty' : null,
        onSaved: (value) => _email = value,
      ),
    );
  }

  Widget _showPasswordInput() {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: new TextFormField(
        maxLines: 1,
        obscureText: true,
        autofocus: false,
        controller: ctrlPassword,
        decoration: new InputDecoration(
            hintText: 'Password',
            icon: new Icon(
              Icons.lock,
              color: Colors.grey,
            )),
        validator: (value) => value.isEmpty ? 'Password can\'t be empty' : null,
        onSaved: (value) => _password = value,
      ),
    );
  }

  Widget _showSecondaryButton() {
    return new FlatButton(
      child: Align(
        alignment: Alignment.centerRight,
        child: _formMode == FormMode.LOGIN
            ? new Text('Create an account',
                style:
                    new TextStyle(fontSize: 18.0, fontWeight: FontWeight.w300))
            : new Text('Have an account? Sign in',
                style:
                    new TextStyle(fontSize: 18.0, fontWeight: FontWeight.w300)),
      ),
      onPressed: _formMode == FormMode.LOGIN
          ? _changeFormToSignUp
          : _changeFormToLogin,
    );
  }

  Widget _showPrimaryButton() {
    return new Padding(
        padding: EdgeInsets.only(top: 35),
        child: SizedBox(
          height: 40.0,
          child: new RaisedButton(
            elevation: 5.0,
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(15.0)),
            color: Color(0xffff9999),
            child: _formMode == FormMode.LOGIN
                ? new Text('Login',
                    style: new TextStyle(fontSize: 20.0, color: Colors.white))
                : new Text('Create account',
                    style: new TextStyle(fontSize: 20.0, color: Colors.white)),
            onPressed: _validateAndSubmit,
          ),
        ));
  }

  Widget __showFoatingAction() {
    return Row(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 85),
          child: FloatingActionButton(
            child: Icon(
              FontAwesomeIcons.google,
              color: Colors.red,
            ),
            backgroundColor: Colors.white,
            onPressed: () => _handleSignIn(),
            heroTag: 'googleBn',
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: FloatingActionButton(
            child: Icon(
              FontAwesomeIcons.facebookF,
              color: Colors.white,
            ),
            backgroundColor: Colors.blue,
            onPressed: () => _facebookLogin(),
            heroTag: 'facebookBn',
          ),
        ),
      ],
    );
  }
}
