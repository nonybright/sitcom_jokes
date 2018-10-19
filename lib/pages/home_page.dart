import 'package:flutter/material.dart';
import 'package:sitcom_joke_app/bloc/bloc_provider.dart';
import 'package:sitcom_joke_app/models/joke_type.dart';
import 'package:sitcom_joke_app/models/movie.dart';
import 'package:sitcom_joke_app/widgets/app_drawer.dart';
import 'package:sitcom_joke_app/widgets/image_list.dart';
import 'package:sitcom_joke_app/widgets/text_list.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {


TabController _tabController;

Movie _selectedMovie;

  @override
    void initState() {
      // TODO: implement initState
      super.initState();
      _tabController = TabController(vsync: this, length: 2);
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('ss'),),
      drawer:  AppDrawer(onMovieClicked: (movie){
        print('movie clicked');
        BlocProvider.of(context).movieBloc.getJokes(1, JokeType.text, movie);
        setState(() {   
              _selectedMovie = movie;
        });
      },),
     body:TextList(selectedMovie: _selectedMovie),

);
  }
}


class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new Container(
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}