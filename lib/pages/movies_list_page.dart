import 'package:flutter/material.dart';
import 'package:sitcom_joke_app/bloc/bloc_provider.dart';
import 'package:sitcom_joke_app/bloc/movie_bloc.dart';
import 'package:sitcom_joke_app/models/joke_type.dart';
import 'package:sitcom_joke_app/models/movie.dart';
import 'package:sitcom_joke_app/models/user.dart';
import 'package:sitcom_joke_app/pages/home_page.dart';
import 'package:sitcom_joke_app/widgets/scroll_list.dart';

class MoviesListPage extends StatefulWidget {
  MoviesListPage({Key key}) : super(key: key);

  @override
  _MoviesListPageState createState() => new _MoviesListPageState();
}

class _MoviesListPageState extends State<MoviesListPage> {

  @override
  Widget build(BuildContext context) {
    final movieBloc = BlocProvider.of(context).movieBloc;
    final userBloc = BlocProvider.of(context).userBloc;

    return Scaffold(
      appBar: AppBar(title: Text('Sitcoms'), actions: <Widget>[
        IconButton(
          icon: Icon(Icons.search),
          onPressed: (){},
        )
      ],),

      body: StreamBuilder(
        initialData: null,
        stream: userBloc.currentUser,
        builder: (context, currentUserSnapShot) {


          return ScrollList(
        noItemtext: 'No movies to view at the moment',
        listContentStream: movieBloc.movies,
        loadStatusStream: movieBloc.movieLoadStatus,
        scrollListType: ScrollListType.list,
        loadMoreAction: (){
            //
        },
        listItemWidget: (movie, index){
             return _movieCard(movie, movieBloc, currentUserSnapShot.data, context);
        },
      );

        }),
      
      
      
    );
  }
}


_movieCard(Movie movie, MovieBloc movieBloc, User currentUser,  context){
  return ListTile(
         leading: CircleAvatar(
           //backgroundImage: NetworkImage(movie.icon),
           child: Text(movie.name.substring(0,1)),
         ),
         title: Text(movie.name),
         subtitle: Text('seasons '+ movie.seasons.toString()),
         onTap: (){
           movieBloc.changeSelectedMovie(movie);
           movieBloc.getJokes(JokeType.image, currentUser);
           movieBloc.getJokes(JokeType.text, currentUser);
           Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
         },
  );
}