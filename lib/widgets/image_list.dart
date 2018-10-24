import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:sitcom_joke_app/bloc/bloc_provider.dart';
import 'package:sitcom_joke_app/models/ImageJoke.dart';
import 'package:sitcom_joke_app/models/joke_type.dart';
import 'package:sitcom_joke_app/models/load_status.dart';
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

    // return StreamBuilder<LoadStatus>(
    //    initialData: LoadStatus.loading,
    //   stream: movieBloc.imageLoadStatus,
    //   builder: (context, loadSnapshot) {

    //     if(loadSnapshot.data == LoadStatus.loadedMore || loadSnapshot.data == LoadStatus.loadEnd){
    //       inLoadMore = false;
    //     }else if(loadSnapshot.data == LoadStatus.loading){
    //      return Center(child: CircularProgressIndicator());
    //     }

    //     return StreamBuilder<UnmodifiableListView<ImageJoke>>(
    //           initialData: UnmodifiableListView<ImageJoke>([]),
    //           stream: movieBloc.imageJokes,
    //           builder: (context, imageJokesSnapshot) {

    //             final imageJokes = imageJokesSnapshot.data;
    //             // if(loadSnapshot.data == LoadStatus.loaded  && imageJokes.isEmpty){
    //             //   return Center(child: Text('No items found at the moment'),);
    //             // }

    //             return ListView.builder(
    //                 itemCount: imageJokes.length,
    //                 itemBuilder: (context, index){
    //                     if (index >= imageJokes.length - 3 && !inLoadMore && loadSnapshot.data != LoadStatus.loadEnd) {
    //                           inLoadMore = true;
    //                           movieBloc.getJokes(JokeType.image);
    //                     } 
    //                     return Container(
    //                       height: 180.0,
    //                       child: Text(imageJokes[index].title + '  '+imageJokes[index].url));
    //                 },
    //             );
    //           }
    // );
    //   });


    return ScrollList(loadStatusStream: movieBloc.imageLoadStatus,
      listContentStream: movieBloc.imageJokes,
      noItemtext: 'No images To load at the moment',
      loadMoreAction: (){
        movieBloc.getJokes(JokeType.image);
      },
      listItemWidget: (imageJoke){
            return Container(
               height: 180.0,
               child: Text(imageJoke.title + '  '+imageJoke.url),
            );
      },
    );
  }
 
}