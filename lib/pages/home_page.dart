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
      drawer:  AppDrawer(onMovieClicked: (movie){
        print('movie clicked');
        BlocProvider.of(context).movieBloc.changeSelectedMovie(movie);
        BlocProvider.of(context).movieBloc.getJokes(JokeType.text);
        setState(() {   
              _selectedMovie = movie;
        });
      },),
      body: DefaultTabController(
        length: 2,
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                expandedHeight: 200.0,
                floating: false,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                    centerTitle: true,
                    title: Text((_selectedMovie != null)? _selectedMovie.name: "Sitcom Jokes",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                        )),
                    background: Image.network(
                      "https://images.pexels.com/photos/396547/pexels-photo-396547.jpeg?auto=compress&cs=tinysrgb&h=350",
                      fit: BoxFit.cover,
                    )),
              ),
              SliverPersistentHeader(
                delegate: _SliverAppBarDelegate(
                  TabBar(
                    labelColor: Colors.black87,
                    unselectedLabelColor: Colors.grey,
                    controller: _tabController,
                    tabs: [
                      Tab(icon: Icon(Icons.info), text: "Images"),
                      Tab(icon: Icon(Icons.lightbulb_outline), text: "Texts"),
                    ],
                  ),
                ),
                pinned: true,
              ),
            ];
          },
          body: TabBarView(
            controller: _tabController,
            children: [
             ImageList(),
             TextList(),
            ],
          ),
        ),
      ),
);
  }

  //   Widget build(BuildContext context) {
  //   return Scaffold(appBar: AppBar(),
  //   drawer:  AppDrawer(onMovieClicked: (movie){
  //       print('movie clicked');
  //       BlocProvider.of(context).movieBloc.getJokes(1, JokeType.text, movie);
  //       setState(() {   
  //             _selectedMovie = movie;
  //       });
  //     },),
  //   body:TextList(selectedMovie: _selectedMovie,),
  //   );
  // }

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