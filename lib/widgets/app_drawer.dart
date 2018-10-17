import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:sitcom_joke_app/bloc/bloc_provider.dart';
import 'package:sitcom_joke_app/models/movie.dart';

class AppDrawer extends StatefulWidget {
  final Function(Movie) onMovieClicked;
  AppDrawer({Key key, this.onMovieClicked}) : super(key: key);

  @override
  _DrawerState createState() => new _DrawerState();
}

class _DrawerState extends State<AppDrawer> {

  int selected = 0;

  @override
  Widget build(BuildContext context) {

    final movieBloc = BlocProvider.of(context).movieBloc;

    return StreamBuilder<UnmodifiableListView<Movie>>(
              initialData: UnmodifiableListView<Movie>([]),
              stream: movieBloc.movies,
              builder: (context, moviesSnapshot) {
                final movies = moviesSnapshot.data;
                  return Drawer(
                    
                       child: ListView.builder(
                          itemCount: movies.length,
                          itemBuilder: (context, index){
                              return _drawerTile(movies[index], (){
                                  widget.onMovieClicked(movies[index]);
                                  Navigator.pop(context);
                              });
                          },
                        )
                );
              });
  }

 Widget _drawerTile(Movie movie, onTap) {
    return ListTile(
      leading: new Icon(Icons.description),
      title: Text(movie.name),
      onTap: onTap,
    );
  }

  _drawerHeader(){
    return Text('header');
  }
}