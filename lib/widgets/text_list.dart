import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:sitcom_joke_app/bloc/bloc_provider.dart';
import 'package:sitcom_joke_app/models/joke_type.dart';
import 'package:sitcom_joke_app/pages/joke_slide_page.dart';
import 'package:sitcom_joke_app/widgets/scroll_list.dart';
import 'package:sitcom_joke_app/widgets/text_joke_card.dart';

class TextList extends StatefulWidget {
  TextList({
    Key key,
  }) : super(key: key);

  @override
  _TextListState createState() => new _TextListState();
}

class _TextListState extends State<TextList> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('init');
  }

  @override
  Widget build(BuildContext context) {
    final movieBloc = BlocProvider.of(context).movieBloc;
     final userBloc = BlocProvider.of(context).userBloc;

    return StreamBuilder(
        initialData: null,
        stream: userBloc.currentUser,
        builder: (context, currentUserSnapShot) {

          return ScrollList(loadStatusStream: movieBloc.textLoadStatus,
      listContentStream: movieBloc.textJokes,
      noItemtext: 'No text To load at the moment',
      scrollListType:  ScrollListType.list,
      loadMoreAction: (){
        movieBloc.getJokes(JokeType.text, currentUserSnapShot.data);
      },
      listItemWidget: (textJoke, index){
            return TextJokeCard(textJoke, (){

               Navigator.push(context, MaterialPageRoute(builder:(context) => JokeSlidePage(initialPage: index, selectedJoke: textJoke, jokeType: JokeType.text,)));

            });
      },
    );

        });


    
  }
}
