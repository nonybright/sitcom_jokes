import 'package:flutter/material.dart';
import 'package:sitcom_joke_app/bloc/movie_bloc.dart';

class BlocProvider extends InheritedWidget {

  final blocState = new BlocState(
        movieBloc: MovieBloc()
      );

  BlocProvider({Key key, Widget child}) : super(key: key, child: child);

  bool updateShouldNotify(_) => true;

  static BlocState of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(BlocProvider) as BlocProvider)
        .blocState;
  }
}

class BlocState {

  final MovieBloc movieBloc;
  BlocState({this.movieBloc});
}