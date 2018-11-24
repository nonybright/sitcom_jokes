import 'package:flutter/material.dart';

class AddJokePage extends StatefulWidget {
  AddJokePage({Key key}) : super(key: key);

  @override
  _AddJokePageState createState() => new _AddJokePageState();
}

class _AddJokePageState extends State<AddJokePage> {


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(title: Text('Add Joke'),),
    );
  }
}