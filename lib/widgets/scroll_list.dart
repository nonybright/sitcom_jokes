import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:sitcom_joke_app/models/load_status.dart';

enum ScrollListType{
  grid,
  list
}

class ScrollList extends StatefulWidget {
  final Stream<LoadStatus> loadStatusStream;
  final Stream<UnmodifiableListView<dynamic>> listContentStream;
  final String noItemtext;
  final Function loadMoreAction;
  final Function(dynamic, int) listItemWidget;
  final ScrollListType scrollListType;
  ScrollList(
      {Key key,
      this.loadStatusStream,
      this.listContentStream,
      this.noItemtext,
      this.loadMoreAction,
      this.listItemWidget,
      this.scrollListType})
      : super(key: key);

  @override
  _ScrollListState createState() => new _ScrollListState();
}

class _ScrollListState extends State<ScrollList> {
  bool inLoadMore = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return StreamBuilder<LoadStatus>(
        initialData: LoadStatus.loading,
        stream: widget.loadStatusStream,
        builder: (context, loadSnapshot) {
          if (loadSnapshot.data == LoadStatus.loadedMore ||
              loadSnapshot.data == LoadStatus.loadEnd) {
            inLoadMore = false;
          } else if (loadSnapshot.data == LoadStatus.loading) {
            return Center(child: CircularProgressIndicator());
          }

          return StreamBuilder<UnmodifiableListView<dynamic>>(
              initialData: UnmodifiableListView<dynamic>([]),
              stream: widget.listContentStream,
              builder: (context, listItemsSnapshot) {
                final listItems = listItemsSnapshot.data;
                if (loadSnapshot.data == LoadStatus.loadEnd &&
                    listItems.isEmpty) {
                  return Center(
                    child: Text(widget.noItemtext),
                  );
                }

                if(widget.scrollListType == ScrollListType.grid){

                    return GridView.builder(
                    padding: EdgeInsets.all(10.0),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10.0,
                        mainAxisSpacing: 10.0),
                    itemCount: listItems.length,
                    itemBuilder: (context, index) {
                      if (index >= listItems.length - 3 &&
                          !inLoadMore &&
                          loadSnapshot.data != LoadStatus.loadEnd) {
                        inLoadMore = true;
                        widget.loadMoreAction();
                      }
                      return widget.listItemWidget(listItems[index], index);
                    },
                  );
                }else{

                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: listItems.length,
                  itemBuilder: (context, index) {
                    if (index >= listItems.length - 3 && !inLoadMore && loadSnapshot.data != LoadStatus.loadEnd) {
                      inLoadMore = true;
                      widget.loadMoreAction();
                    }
                    return widget.listItemWidget(listItems[index], index);
                  },
                );
                }
                
              });
        });
  }
}
