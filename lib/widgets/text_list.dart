import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:sitcom_joke_app/bloc/bloc_provider.dart';
import 'package:sitcom_joke_app/models/joke_type.dart';
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
    return ScrollList(loadStatusStream: movieBloc.textLoadStatus,
      listContentStream: movieBloc.textJokes,
      noItemtext: 'No text To load at the moment',
      scrollListType:  ScrollListType.list,
      loadMoreAction: (){
        movieBloc.getJokes(JokeType.text);
      },
      listItemWidget: (textJoke){
            return TextJokeCard(textJoke);
      },
    );
  }
}
