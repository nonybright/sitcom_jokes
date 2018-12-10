import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:sitcom_joke_app/bloc/bloc_provider.dart';
import 'package:sitcom_joke_app/bloc/movie_bloc.dart';
import 'package:sitcom_joke_app/bloc/user_bloc.dart';
import 'package:sitcom_joke_app/models/ImageJoke.dart';
import 'package:sitcom_joke_app/models/Joke.dart';
import 'package:sitcom_joke_app/models/TextJoke.dart';
import 'package:sitcom_joke_app/models/joke_type.dart';
import 'package:sitcom_joke_app/models/load_status.dart';
import 'package:sitcom_joke_app/models/user.dart';
import 'package:zoomable_image/zoomable_image.dart';

class JokeSlidePage extends StatefulWidget {
  final int initialPage;
  final Joke selectedJoke;
  final JokeType jokeType;
  JokeSlidePage({Key key, this.selectedJoke, this.initialPage, this.jokeType})
      : super(key: key);

  @override
  _JokeSlidePageState createState() => new _JokeSlidePageState();
}

class _JokeSlidePageState extends State<JokeSlidePage> {
  Joke _currentJoke;
  PageController _pageController;

  bool inLoadMore = false;
  MovieBloc _movieBloc;
  UserBloc _userBloc;

  int _currentPageIndex;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _currentJoke = widget.selectedJoke;

    _pageController = PageController(initialPage: widget.initialPage);
    _currentPageIndex = widget.initialPage;
  }

  @override
  Widget build(BuildContext context) {
    _movieBloc = BlocProvider.of(context).movieBloc;
    _userBloc = BlocProvider.of(context).userBloc;

    return StreamBuilder(
        initialData: null,
        stream: _userBloc.currentUser,
        builder: (context, currentUserSnapShot) {

          return StreamBuilder<LoadStatus>(
        initialData: LoadStatus.loading,
        stream: (widget.jokeType == JokeType.image)?_movieBloc.imageLoadStatus: _movieBloc.textLoadStatus,
        builder: (context, loadSnapshot) {
          if (loadSnapshot.data == LoadStatus.loadedMore ||
              loadSnapshot.data == LoadStatus.loadEnd) {
            inLoadMore = false;
          }

          return StreamBuilder<UnmodifiableListView<Joke>>(
            initialData: null,
            stream: (widget.jokeType == JokeType.image)?_movieBloc.imageJokes: _movieBloc.textJokes,
            builder: (context, jokeSnapshot) {
              return Scaffold(
                backgroundColor: (widget.jokeType == JokeType.image)? Colors.black:null,
                appBar: AppBar(
                        title: Text(_currentJoke.title),
                      ),
                    
                body:  StreamBuilder(
                  initialData: null,
                  stream: _userBloc.currentUser,
                  builder: (context, currentUserSnapShot) {

                    return Stack(
                  children: <Widget>[
                    (jokeSnapshot.data != null)
                        ? Padding(
                            padding: const EdgeInsets.only(bottom: 0.0),
                            child: PageView.builder(
                                onPageChanged: (index) {
                                  setState(() {
                                    _currentPageIndex = index;
                                    _currentJoke = jokeSnapshot.data[index];
                                  });
                                },
                                controller: _pageController,
                                itemCount: jokeSnapshot.data.length,
                                itemBuilder: (context, index) {

                                  if (index >= jokeSnapshot.data.length - 3 &&
                          !inLoadMore &&
                          loadSnapshot.data != LoadStatus.loadEnd) {
                        inLoadMore = true;
                            _movieBloc.getJokes(JokeType.image, currentUserSnapShot.data);
                       
                      }

                                  if(widget.jokeType == JokeType.image){
                                      
                                      //use jokesSnapshot.data instead of _currentJoke and for TextJoke too
                                     return ZoomableImage(
                                     NetworkImage((jokeSnapshot.data[index]  as ImageJoke).url),
                                      placeholder: const Center(
                                          child:
                                              const CircularProgressIndicator()),
                                      backgroundColor: Colors.black);
                                

                                  }else{

                                     return ListView(
                                       children: <Widget>[
                                         Padding(
                                           padding: const EdgeInsets.only(top:8.0, left: 8.0, right: 8.0, bottom: 40.0),
                                           child: Text((jokeSnapshot.data[index] as TextJoke).text, textAlign: TextAlign.justify, style: TextStyle(
                                             fontSize: 22.0,
                                           ),),
                                         )
                                       ],
                                     );

                                  }

                                  }))
                                 
                        : CircularProgressIndicator(),
                    (1 == 1)
                        ? Positioned(
                            bottom: 0.0,
                            left: 0.0,
                            right: 0.0,
                            child: _jokeOptionsRow((jokeSnapshot.data != null)?jokeSnapshot.data[_currentPageIndex]: null, currentUserSnapShot.data),
                          )
                        : Container()
                  ],
                );

                  }),
                
                
                
                
              );
            },
          );
        });

        });
    
  }



_jokeOptionsRow(Joke joke, User currentUser) {
  JokeType jokeType = (joke is TextJoke)? JokeType.text : JokeType.image;
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: <Widget>[
      _jokeActionBox('Likes', Icons.thumb_up, false, (){}),
      _jokeActionBox('Save', Icons.arrow_downward, false, (){}),
      _jokeActionBox('Favorite', Icons.favorite, (joke != null)?joke.isFaved:false, (){
         _movieBloc.toggleFavorite(joke.id, jokeType, currentUser);
      }),
      _jokeActionBox('Share', Icons.share, false, (){}),
    ],
  );
}

_jokeActionBox(String title, IconData icon, bool selected, onTap) {
  
  Color iconColor = (widget.jokeType == JokeType.image)? Colors.white : Colors.black;
  Color textColor = (widget.jokeType == JokeType.image)? Colors.grey : Colors.grey;

  return InkWell(
    borderRadius: BorderRadius.all(Radius.circular(60.0)),
    splashColor: Colors.orange,
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          Icon(
            icon,
            color: (selected)?Colors.orange: iconColor,
          ),
          SizedBox(
            height: 5.0,
          ),
          Text(
            title,
            style: TextStyle(color: textColor),
          )
        ],
      ),
    ),
    onTap: onTap,
  );
}


}

