import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:sitcom_joke_app/bloc/bloc_provider.dart';
import 'package:sitcom_joke_app/models/ImageJoke.dart';

class ImageList extends StatefulWidget {
  ImageList({Key key}) : super(key: key);

  @override
  _ImageListState createState() => new _ImageListState();
}

class _ImageListState extends State<ImageList> {


  @override
  Widget build(BuildContext context) {
  final movieBloc = BlocProvider.of(context).movieBloc;

    return StreamBuilder<UnmodifiableListView<ImageJoke>>(
              initialData: UnmodifiableListView<ImageJoke>([]),
              stream: movieBloc.imageJokes,
              builder: (context, imageJokesSnapshot) {

                final imageJokes = imageJokesSnapshot.data;
                return GridView.builder(
                    itemCount: imageJokes.length,
                    gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                    itemBuilder: (context, index){
                        return Text(imageJokes[index].title);
                    },
                );
              }
    );
  }
}