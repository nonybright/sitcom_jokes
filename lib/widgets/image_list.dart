import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:sitcom_joke_app/bloc/bloc_provider.dart';
import 'package:sitcom_joke_app/models/ImageJoke.dart';
import 'package:sitcom_joke_app/models/joke_type.dart';
import 'package:sitcom_joke_app/models/load_status.dart';
import 'package:sitcom_joke_app/pages/joke_slide_page.dart';
import 'package:sitcom_joke_app/widgets/image_joke_card.dart';
import 'package:sitcom_joke_app/widgets/scroll_list.dart';

class ImageList extends StatefulWidget {

  ImageList({Key key,}) : super(key: key);

  @override
  _ImageListState createState() => new _ImageListState();
}

class _ImageListState extends State<ImageList> {

  @override
   Widget build(BuildContext context) {
    final movieBloc = BlocProvider.of(context).movieBloc;
    final userBloc = BlocProvider.of(context).userBloc;

    return StreamBuilder(
        initialData: null,
        stream: userBloc.currentUser,
        builder: (context, currentUserSnapShot) {

          return ScrollList(loadStatusStream: movieBloc.imageLoadStatus,
      listContentStream: movieBloc.imageJokes,
      noItemtext: 'No images To load at the moment',
      scrollListType: ScrollListType.grid,
      loadMoreAction: (){
        movieBloc.getJokes(JokeType.image, currentUserSnapShot.data);
      },
      listItemWidget: (imageJoke, index){
            return ImageJokeCard(imageJoke, (){
              Navigator.push(context, MaterialPageRoute(builder:(context) => JokeSlidePage(initialPage: index, selectedJoke: imageJoke, jokeType: JokeType.image,)));
            });
      },
    );
  });
 
}
}