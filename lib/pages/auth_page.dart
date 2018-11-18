import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sitcom_joke_app/utils/validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

enum AuthType { login, signup }

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn _googleSignIn = GoogleSignIn();

class AuthPage extends StatefulWidget {
  final AuthType authType;
  AuthPage(this.authType, {Key key}) : super(key: key);

  @override
  _AuthPageState createState() => new _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {

Validator validator;
final _formKey = GlobalKey<FormState>();

  @override
    void initState() {
      // TODO: implement initState
      super.initState();
      validator = Validator();
    }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0Xffe6e6e6),
        appBar: AppBar(
          title: Text((widget.authType == AuthType.signup)?'Sign up': 'Login'),
        ),
        body: Form(
          key:  _formKey,
                  child: ListView(
            children: <Widget>[
              Container(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                      child: Image.asset(
                        'assets/images/app_logo.jpg',
                        fit: BoxFit.fitHeight,
                        height: 80.0,
                      ),
                    ),
                    Center(
                      child: Text('Sitcom Jokes'),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: <Widget>[
                          (widget.authType == AuthType.signup)
                              ? TextFormField(
                                  decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.white,
                                      border: InputBorder.none,
                                      hintText: 'Username'),
                                      validator: validator.usernameValidator,
                                )
                              : Container(),
                          (widget.authType == AuthType.signup)
                              ? SizedBox(
                                  height: 10.0,
                                )
                              : Container(),
                          TextFormField(
                            decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                border: InputBorder.none,
                                hintText: 'Email'),
                                validator: validator.emailValidator,
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          TextFormField(
                            obscureText: true,
                            decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                border: InputBorder.none,
                                hintText: 'Password'),
                                validator: validator.passwordValidator,
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: RaisedButton(
                              color: const Color(0Xfffe0e4f),
                              child: Text(
                                'LOGIN',
                                style: TextStyle(color: Colors.white),
                              ),
                              onPressed: () {

                                if(_formKey.currentState.validate()){
                                 
                                }
                              },
                            ),
                          ),
                          SizedBox(height: 10.0),
                          Stack(
                            children: <Widget>[
                              Positioned(
                                right: 0.0,
                                left: 0.0,
                                bottom: 0.0,
                                top: 0.0,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Divider(
                                      color: Colors.red,
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.all(8.0),
                                    color: const Color(0Xffe6e6e6),
                                    child: Text('OR'),
                                  )
                                ],
                              )
                            ],
                          ),
                          //Social Buttons
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              InkWell(
                                child: CircleAvatar(
                                  child: Icon(FontAwesomeIcons.facebookF),
                                ),
                                onTap: () {},
                              ),
                              SizedBox(
                                width: 20.0,
                              ),
                              InkWell(
                                child: CircleAvatar(
                                  backgroundColor: Colors.red,
                                  child: Icon(FontAwesomeIcons.googlePlusG),
                                ),
                                onTap: () {

                                  //google sign in 
                                  _testSignInWithGoogle();

                                },
                              )
                            ],
                          ),
                          //Terms
                          Padding(
                            padding: EdgeInsets.only(top: 15.0),
                            child: (widget.authType == AuthType.signup)
                                ? Column(
                                    children: <Widget>[
                                      Text('By Signing up, you agree to our'),
                                      FlatButton(
                                        child: Text(
                                          'Terms and Conditions',
                                          style: TextStyle(
                                              color: const Color(0Xfffe0e4f)),
                                        ),
                                        onPressed: () {},
                                      )
                                    ],
                                  )
                                : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text("Don't have an account?"),
                                      FlatButton(
                                        child: Text(
                                          'Sign up',
                                          style: TextStyle(
                                              color: const Color(0Xfffe0e4f)),
                                        ),
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      AuthPage(AuthType.signup)));
                                        },
                                      )
                                    ],
                                  ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ));
  }
}

_signUpWithEmailAndPassword(email, password) async{

  final FirebaseUser user = await _auth.createUserWithEmailAndPassword(email: email, password: password);
   final FirebaseUser currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid);
}

_signInWithEmailAndPasword(email, password) async {

  final FirebaseUser user = await _auth.signInWithEmailAndPassword(email: email, password: password);
  final FirebaseUser currentUser = await _auth.currentUser();
  assert(user.uid == currentUser.uid);
}

Future<String> _testSignInWithGoogle() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final FirebaseUser user = await _auth.signInWithGoogle(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    assert(user.email != null);
    assert(user.displayName != null);
    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final FirebaseUser currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid);

    print(user);
    return 'signInWithGoogle succeeded: $user';
}