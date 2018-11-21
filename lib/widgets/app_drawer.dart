import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:sitcom_joke_app/bloc/bloc_provider.dart';
import 'package:sitcom_joke_app/models/movie.dart';
import 'package:sitcom_joke_app/models/user.dart';
import 'package:sitcom_joke_app/pages/auth_page.dart';

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
    final userBloc = BlocProvider.of(context).userBloc;

    return Drawer(
      child: StreamBuilder(
        initialData: null,
        stream: userBloc.currentUser,
        builder: (context, snapShot) {
          return ListView(
            children: <Widget>[
              _drawerHeader(snapShot.data),
              _drawerTile(Icons.cloud, 'Latest Updates', () {
                _navigateToPage(null);
              }),
              _drawerTile(Icons.dashboard, 'All Sitcoms', () {
                _navigateToPage(null);
              }),
              _drawerTile(Icons.favorite, 'Favorites', () {
                _navigateToPage(null);
              }),
              Divider(),
              _drawerTile(Icons.share, 'Share', () {
                _navigateToPage(null);
              }),
              _drawerTile(Icons.help, 'About', () {
                _navigateToPage(null);
              }),
            ],
          );
        },
      ),
    );
  }

  Widget _drawerTile(IconData icon, String title, Function onTap) {
    return ListTile(
      leading: new Icon(icon),
      title: Text(title),
      onTap: onTap,
    );
  }

  _drawerHeader(User user) {
    return Stack(
      children: <Widget>[
        Container(
          height: 200.0,
          decoration: BoxDecoration(
            image: DecorationImage(
              colorFilter: ColorFilter.mode(Colors.black45, BlendMode.overlay),
              fit: BoxFit.cover,
              image: AssetImage('assets/images/header_bg.jpg'),
            ),
          ),
        ),
        Positioned(
            bottom: 0.0,
            left: 0.0,
            right: 0.0,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: (user != null)
                  ? _loggedInHeaderContent(user)
                  : _authHeaderContent(),
            ))
      ],
    );
  }

  _loggedInHeaderContent(User user) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        CircleAvatar(
          backgroundImage: (user.photoUrl != null)
              ? NetworkImage(user.photoUrl)
              : AssetImage('assets/images/default_avatar.png'),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: Text(user.username,
              style: TextStyle(
                color: Colors.white,
              )),
        ),
      ],
    );
  }

  _authHeaderContent() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        FlatButton(
          onPressed: () {
            print('sign in');
            _navigateToPage(AuthPage(AuthType.login));
          },
          child: Text('SIGN IN', style: TextStyle(color: Colors.white)),
        ),
        FlatButton(
          onPressed: () {
            print('sign up');
            _navigateToPage(AuthPage(AuthType.signup));
          },
          child: Text('SIGN UP', style: TextStyle(color: Colors.white)),
        )
      ],
    );
  }

  _navigateToPage(page) {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }
}
