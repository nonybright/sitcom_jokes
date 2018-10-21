import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:sitcom_joke_app/bloc/bloc_provider.dart';
import 'package:sitcom_joke_app/models/TextJoke.dart';
import 'package:sitcom_joke_app/models/joke_type.dart';
import 'package:sitcom_joke_app/models/load_status.dart';

class TextList extends StatefulWidget {
  TextList({
    Key key,
  }) : super(key: key);

  @override
  _TextListState createState() => new _TextListState();
}

class _TextListState extends State<TextList> {
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
          if (loadSnapshot.data == LoadStatus.loadedMore || loadSnapshot.data == LoadStatus.loadEnd) {
            inLoadMore = false;
          } else if (loadSnapshot.data == LoadStatus.loading) {
            return Center(child: CircularProgressIndicator());
          }

          return StreamBuilder<UnmodifiableListView<TextJoke>>(
              initialData: UnmodifiableListView<TextJoke>([]),
              stream: movieBloc.textJokes,
              builder: (context, textJokesSnapshot) {
                final textJokes = textJokesSnapshot.data;
                if (loadSnapshot.data != LoadStatus.loadEnd &&
                    loadSnapshot.data != LoadStatus.loading &&
                    loadSnapshot.data != LoadStatus.loadingMore &&
                    textJokes.isEmpty) {
                  return Center(
                    child: Text('No items found at the moment'),
                  );
                }

                return ListView.builder(
                  itemCount: textJokes.length,
                  itemBuilder: (context, index) {
                    if (index >= textJokes.length - 3 && !inLoadMore && loadSnapshot.data != LoadStatus.loadEnd) {
                      inLoadMore = true;
                      movieBloc.getJokes(JokeType.text);
                    }
                    return Container(
                        height: 180.0,
                        child: Text(textJokes[index].title +
                            '  ' +
                            textJokes[index].text, style: TextStyle(background: Paint()..color = Colors.pink),));
                  },
                );
              });
        });
  }
}
