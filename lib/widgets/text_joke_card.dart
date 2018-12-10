import 'package:flutter/material.dart';
import 'package:sitcom_joke_app/bloc/bloc_provider.dart';
import 'package:sitcom_joke_app/bloc/movie_bloc.dart';
import 'package:sitcom_joke_app/models/TextJoke.dart';
import 'package:sitcom_joke_app/models/joke_type.dart';
import 'package:sitcom_joke_app/models/user.dart';
import 'package:sitcom_joke_app/utils/date_formatter.dart';


class TextJokeCard extends StatelessWidget {

  TextJoke textJoke;
  Function onTap;
  User currentUser;
  TextJokeCard(this.textJoke, this.currentUser, this.onTap);

  @override
  Widget build(BuildContext context) {
     MovieBloc movieBloc = BlocProvider.of(context).movieBloc;
    textJoke.text = 
    'Hello this is the First Joke for me and i am a very long text anf i dont know if i have a break and i can still continue going as long as i can. \n'+
    'This is another line \n and another line \n ad the last';
    
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: onTap,
              child: Card(
          child: Column(
          children: <Widget>[
            ListTile(
              leading: CircleAvatar(
                child: Text('F'),
                backgroundColor: Colors.pink,
                foregroundColor: Colors.white,
              ),
              subtitle: Text(DateFormatter.dateToString(textJoke.dateAdded, DateFormatPattern.timeAgo)),
              title:  Text(textJoke.title),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(textJoke.text),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Expanded(child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Row(
                  children: <Widget>[
                    Text('2k', style:  TextStyle(
                      color: Colors.black45
                    ),),
                    IconButton(
                  icon: Icon(Icons.thumb_up, color:  Colors.black54,),
                  onPressed: (){},
                ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Text('2k', style:  TextStyle(
                      color: Colors.black45
                    ),),
                    IconButton(
                  icon: Icon(Icons.thumb_down, color:  Colors.black54,),
                  onPressed: (){},
                ),
                  ],
                )
                  ],
                ),),

                 IconButton(
                  icon: Icon(Icons.favorite, color: (textJoke.isFaved)? Colors.orange : Colors.black54,),
                  onPressed: (){
                    if(currentUser != null){

                     movieBloc.toggleFavorite(textJoke.id, JokeType.text, currentUser);
                    }else{
                      Scaffold.of(context).showSnackBar(SnackBar(content: Text('Login to add Favorites'),));
                    }
                  },
                ),
                 IconButton(
                  icon: Icon(Icons.share, color:  Colors.black54,),
                  onPressed: (){},
                ),
            ],)
          ],
        )),
      ),
    );
  }
}