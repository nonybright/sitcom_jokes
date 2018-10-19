import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:sitcom_joke_app/bloc/bloc_provider.dart';
import 'package:sitcom_joke_app/models/TextJoke.dart';
import 'package:sitcom_joke_app/models/joke_type.dart';
import 'package:sitcom_joke_app/models/load_status.dart';
import 'package:sitcom_joke_app/models/movie.dart';

class TextList extends StatefulWidget {
  final Movie selectedMovie;
  TextList({Key key, this.selectedMovie}) : super(key: key);

  @override
  _TextListState createState() => new _TextListState();
}

class _TextListState extends State<TextList> {

  int currentPage = 1;
  bool inLoadMore = false;

  @override
    void initState() {
      // TODO: implement initState
      super.initState();
      print('init');
    }

  @override
  Widget build(BuildContext context) {
    final movieBloc = BlocProvider.of(context).movieBloc;

    return StreamBuilder<LoadStatus>(
       initialData: LoadStatus.loading,
      stream: movieBloc.textLoadStatus,
      builder: (context, loadSnapshot) {

        if(loadSnapshot.data == LoadStatus.loadedMore){
          inLoadMore = false;
        }else if(loadSnapshot.data == LoadStatus.loading){
          return CircularProgressIndicator();
        }

        return StreamBuilder<UnmodifiableListView<TextJoke>>(
              initialData: UnmodifiableListView<TextJoke>([]),
              stream: movieBloc.textJokes,
              builder: (context, textJokesSnapshot) {

                final textJokes = textJokesSnapshot.data;
                if(loadSnapshot.data == LoadStatus.loaded && currentPage == 1 && textJokes.isEmpty){
                  return Center(child: Text('No items found at the moment'),);
                }

                return ListView.builder(
                    itemCount: textJokes.length,
                    itemBuilder: (context, index){
                        if (index >= textJokes.length - 3 && !inLoadMore) {
                              currentPage++;
                              inLoadMore = true;
                              movieBloc.getJokes(currentPage, JokeType.text, widget.selectedMovie);
                        } 
                        return Container(
                          height: 180.0,
                          child: Text(textJokes[index].title + '  '+textJokes[index].text));
                    },
                );
              }
    );
      });
  }
}