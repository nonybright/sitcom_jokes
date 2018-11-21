import 'package:flutter/material.dart';
import 'package:sitcom_joke_app/bloc/movie_bloc.dart';
import 'package:sitcom_joke_app/bloc/user_bloc.dart';

class BlocProvider extends InheritedWidget {

  final MovieBloc movieBloc;
  final UserBloc userBloc;

  BlocProvider({Key key, this.movieBloc, this.userBloc, Widget child}) : super(key: key, child: child);

  bool updateShouldNotify(_) => true;

  static BlocProvider of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(BlocProvider) as BlocProvider);
  }
}