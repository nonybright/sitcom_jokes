import 'package:flutter/material.dart';
import 'package:sitcom_joke_app/models/joke_type.dart';
import 'package:sitcom_joke_app/pages/add_joke_page.dart';

class JokeAddDialog extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return AlertDialog(title: Text('Choose the option'),
                       content: ListView(
                         shrinkWrap: true,
                         children: <Widget>[
                           ListTile(leading: Icon(Icons.photo), title:  Text('Image'), onTap: (){
                             Navigator.pop(context);
                             //_navigateToPage();
                             Navigator.push(context, MaterialPageRoute(builder: (context) => AddJokePage(jokeType: JokeType.image,)));
                           },),
                           ListTile(leading: Icon(Icons.note),  title:  Text('Text'), onTap: (){
                             Navigator.pop(context);
                             Navigator.push(context, MaterialPageRoute(builder: (context) => AddJokePage(jokeType: JokeType.text,)));
                           },),
                         ],
                       ),
                       );
  }
}