import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sitcom_joke_app/bloc/auth_bloc.dart';
import 'package:sitcom_joke_app/bloc/bloc_provider.dart';
import 'package:sitcom_joke_app/main.dart';
import 'package:sitcom_joke_app/models/auth.dart';
import 'package:sitcom_joke_app/models/bloc_completer.dart';
import 'package:sitcom_joke_app/models/error.dart';
import 'package:sitcom_joke_app/models/load_status.dart';
import 'package:sitcom_joke_app/models/user.dart';
import 'package:sitcom_joke_app/pages/home_page.dart';
import 'package:sitcom_joke_app/services/user_service.dart';
import 'package:sitcom_joke_app/utils/validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';

enum AuthType { login, signup }

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn _googleSignIn = GoogleSignIn();

class AuthPage extends StatefulWidget {
  final AuthType authType;
  AuthPage(this.authType, {Key key}) : super(key: key);

  @override
  _AuthPageState createState() => new _AuthPageState();
}

class _AuthPageState extends State<AuthPage> implements BlocCompleter<User> {
  Validator validator;
  BuildContext _context;
  final _formKey = GlobalKey<FormState>();


  TextEditingController _usernameController = TextEditingController(text:'nonybrighto');
  TextEditingController _emailController = TextEditingController(text: 'hiddennony@gmail.com');
  TextEditingController _passwordController = TextEditingController(text: 'tested69#');

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    validator = Validator();
  }

  @override
  Widget build(BuildContext context) {
    AuthBloc authBloc = AuthBloc(new UserService(), this);
    return Scaffold(
      backgroundColor: const Color(0Xffe6e6e6),
      appBar: AppBar(
        title: Text((widget.authType == AuthType.signup) ? 'Sign up' : 'Login'),
      ),
      body: Builder(builder: (context){
      _context = context;
      return StreamBuilder(
          initialData:  LoadStatus.loaded,
          stream: authBloc.loadStatus,
          builder: (context, loasStatusSnapShot){
            return Form(
        key: _formKey,
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
                              controller: _usernameController,
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
                          controller: _emailController,
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
                          controller: _passwordController,
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
                            child: (_canClickAuthButton(loasStatusSnapShot.data))?Text(
                              (widget.authType == AuthType.signup)
                                  ? 'SIGN UP'
                                  : 'LOGIN',
                              style: TextStyle(color: Colors.white),
                            ): CircularProgressIndicator(backgroundColor: const Color(0Xfffe0e4f),),
                            onPressed: (_canClickAuthButton(loasStatusSnapShot.data))?() {
                              if (_formKey.currentState.validate()) {
                                if(widget.authType == AuthType.signup){
                                    authBloc.signUp(_usernameController.text, _emailController.text, _passwordController.text);
                                }else{
                                    authBloc.login(_emailController.text, _passwordController.text);
                                }
                              }
                            }:null,
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
                              onTap: (_canClickAuthButton(loasStatusSnapShot.data))?() {
                                //_testSignInWithFacebook();
                                authBloc
                                    .loginWithSocial(SocialLoginType.facebook);
                              }:null,
                            ),
                            SizedBox(
                              width: 20.0,
                            ),
                            InkWell(
                              child: CircleAvatar(
                                backgroundColor: Colors.red,
                                child: Icon(FontAwesomeIcons.googlePlusG),
                              ),
                              onTap: (_canClickAuthButton(loasStatusSnapShot.data))?() {
                                //google sign in
                               authBloc.loginWithSocial(SocialLoginType.google);
                              }:null,
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
      );
          },
      );
      },)
    );
  }

  @override
  completed(user) {
    BlocProvider.of(_context).userBloc.changeCurrentUser(user);
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
  }

  @override
  error(error) {
    // TODO: implement error
    Scaffold.of(_context).showSnackBar(SnackBar(content: Text('Error: '+error.message),));
  }
}

_canClickAuthButton(LoadStatus loadStatus){

    return loadStatus == LoadStatus.loaded;
}

// _signUpWithEmailAndPassword(email, password) async {
//   final FirebaseUser user = await _auth.createUserWithEmailAndPassword(
//       email: email, password: password);
//   final FirebaseUser currentUser = await _auth.currentUser();
//   assert(user.uid == currentUser.uid);
// }

// _signInWithEmailAndPasword(email, password) async {
//   final FirebaseUser user =
//       await _auth.signInWithEmailAndPassword(email: email, password: password);
//   final FirebaseUser currentUser = await _auth.currentUser();
//   assert(user.uid == currentUser.uid);
// }

// Future<String> _testSignInWithGoogle() async {
//   final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
//   final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
//   final FirebaseUser user = await _auth.signInWithGoogle(
//     accessToken: googleAuth.accessToken,
//     idToken: googleAuth.idToken,
//   );
//   assert(user.email != null);
//   assert(user.displayName != null);
//   assert(!user.isAnonymous);
//   assert(await user.getIdToken() != null);

//   final FirebaseUser currentUser = await _auth.currentUser();
//   assert(user.uid == currentUser.uid);

//   print(user);
//   return 'signInWithGoogle succeeded: $user';
// }

// _testSignInWithFacebook() async {
//   var facebookLogin = new FacebookLogin();
//   var result = await facebookLogin.logInWithReadPermissions(['email']);

//   switch (result.status) {
//     case FacebookLoginStatus.loggedIn:
//       //_sendTokenToServer(result.accessToken.token);
//       //_showLoggedInUI();
//       print('loggedIn');
//       FirebaseUser user =
//           await _auth.signInWithFacebook(accessToken: result.accessToken.token);
//       assert(user.email != null);
//       assert(user.displayName != null);
//       assert(!user.isAnonymous);
//       break;
//     case FacebookLoginStatus.cancelledByUser:
//       //_showCancelledMessage();
//       break;
//     case FacebookLoginStatus.error:
//       //_showErrorOnUI(result.errorMessage);
//       break;
//   }
// }
