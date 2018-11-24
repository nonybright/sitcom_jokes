import 'package:flutter/material.dart';
import 'package:sitcom_joke_app/bloc/bloc_provider.dart';
import 'package:sitcom_joke_app/bloc/movie_bloc.dart';
import 'package:sitcom_joke_app/models/joke_type.dart';
import 'package:sitcom_joke_app/models/movie.dart';
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

    return Scaffold(
      appBar: AppBar(title: Text('Sitcoms'), actions: <Widget>[
        IconButton(
          icon: Icon(Icons.search),
          onPressed: (){},
        )
      ],),

      body: ScrollList(
        noItemtext: 'No movies to view at the moment',
        listContentStream: movieBloc.movies,
        loadStatusStream: movieBloc.movieLoadStatus,
        scrollListType: ScrollListType.list,
        loadMoreAction: (){
            //
        },
        listItemWidget: (movie){
             return _movieCard(movie, movieBloc, context);
        },
      ),
    );
  }
}


_movieCard(Movie movie, MovieBloc movieBloc, context){
  return ListTile(
         leading: CircleAvatar(
           //backgroundImage: NetworkImage(movie.icon),
           child: Text(movie.name.substring(0,1)),
         ),
         title: Text(movie.name),
         subtitle: Text('seasons '+ movie.seasons.toString()),
         onTap: (){
           movieBloc.changeSelectedMovie(movie);
           movieBloc.getJokes(JokeType.image);
           movieBloc.getJokes(JokeType.text);
           Navigator.pop(context);
         },
  );
}