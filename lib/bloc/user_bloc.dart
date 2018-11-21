import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:sitcom_joke_app/models/user.dart';
import 'package:sitcom_joke_app/services/user_service.dart';

class UserBloc{


  final _currentUserSubject = BehaviorSubject<User>(seedValue: null);

  Function(User) get changeCurrentUser => (user) => _currentUserSubject.sink.add(user);
  
  Stream<User> get currentUser => _currentUserSubject.stream;

  UserBloc(UserService userService);


  close(){
    _currentUserSubject.close();
  }
}