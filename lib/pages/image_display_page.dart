import 'package:flutter/material.dart';

class ImageDisplayPage extends StatefulWidget {
  ImageDisplayPage({Key key}) : super(key: key);

  @override
  _ImageDisplayPageState createState() => new _ImageDisplayPageState();
}

class _ImageDisplayPageState extends State<ImageDisplayPage> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body:  Text('Hello'),
    );
  }
}