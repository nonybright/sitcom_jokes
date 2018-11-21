import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sitcom_joke_app/models/error.dart';
import 'package:sitcom_joke_app/models/user.dart';

class UserService {
  FirebaseAuth _auth;
  GoogleSignIn _googleSignIn;

  UserService() {
    _auth = FirebaseAuth.instance;
    _googleSignIn = GoogleSignIn();
  }

  Future<User> authenticateWithFaceBook() async {
    var facebookLogin = new FacebookLogin();
    var result = await facebookLogin.logInWithReadPermissions(['email']);

    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        FirebaseUser user = await _auth.signInWithFacebook(
            accessToken: result.accessToken.token);
        return User(userId:  user.uid, email: user.email, username: user.displayName,photoUrl:user.photoUrl);
        break;
      case FacebookLoginStatus.cancelledByUser:
        throw(AppError('Login Cancelled')); 
        break;
      case FacebookLoginStatus.error:
        throw(AppError('Login Failed'));
        break;
    }

    return null;
  }

  Future<User> authenticateWithGoogle() async {
 
  
try{
 // final FirebaseUser currentUser = await _auth.currentUser();
  final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
  final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
  final FirebaseUser user = await _auth.signInWithGoogle(
    accessToken: googleAuth.accessToken,
    idToken: googleAuth.idToken,
  );

   return User(userId:  user.uid, email: user.email, username: user.displayName,photoUrl:user.photoUrl);
}catch(error){
  throw(AppError('Error occured during google authentication'));
}

}

Future<User> signUpWithEmailAndPassword(username, email, password) async {
  //TODO: remove all uncessary stuffs
  final FirebaseUser user = await _auth.createUserWithEmailAndPassword(
      email: email, password: password);

  final FirebaseUser currentUser = await _auth.currentUser();
  UserUpdateInfo updateInfo = new UserUpdateInfo();
  updateInfo.displayName = username;
  //TODO: Make image upload possible
  updateInfo.photoUrl = '';
  await currentUser.updateProfile(updateInfo);
  assert(user.uid == currentUser.uid);
  //return User(userId:  user.uid, email: user.email, username: user.displayName,photoUrl:user.photoUrl);
  return signInWithEmailAndPasword(email, password);
}

Future<User> signInWithEmailAndPasword(email, password) async {
  final FirebaseUser user =
      await _auth.signInWithEmailAndPassword(email: email, password: password);
  final FirebaseUser currentUser = await _auth.currentUser();
  assert(user.uid == currentUser.uid);
  return User(userId:  user.uid, email: user.email, username: user.displayName,photoUrl:user.photoUrl);
}
}
