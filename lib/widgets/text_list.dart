import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:sitcom_joke_app/bloc/bloc_provider.dart';
import 'package:sitcom_joke_app/models/TextJoke.dart';

class TextList extends StatefulWidget {
  TextList({Key key}) : super(key: key);

  @override
  _TextListState createState() => new _TextListState();
}

class _TextListState extends State<TextList> {


  @override
  Widget build(BuildContext context) {
    final movieBloc = BlocProvider.of(context).movieBloc;

    return StreamBuilder<UnmodifiableListView<TextJoke>>(
              initialData: UnmodifiableListView<TextJoke>([]),
              stream: movieBloc.textJokes,
              builder: (context, textJokesSnapshot) {

                final textJokes = textJokesSnapshot.data;
                return ListView.builder(
                    itemCount: textJokes.length,
                    itemBuilder: (context, index){
                        return Text(textJokes[index].title + '  '+textJokes[index].text);
                    },
                );
              }
    );
  }
}