import 'package:flutter/material.dart';
import 'package:sitcom_joke_app/bloc/bloc_provider.dart';
import 'package:sitcom_joke_app/bloc/movie_bloc.dart';
import 'package:sitcom_joke_app/models/joke_type.dart';
import 'package:sitcom_joke_app/models/movie.dart';
import 'package:sitcom_joke_app/pages/add_joke_page.dart';
import 'package:sitcom_joke_app/pages/movie_details_page.dart';
import 'package:sitcom_joke_app/widgets/app_drawer.dart';
import 'package:sitcom_joke_app/widgets/image_list.dart';
import 'package:sitcom_joke_app/widgets/text_list.dart';

class HomePage extends StatefulWidget {
  final Movie selectedMovie;
  HomePage({Key key, this.selectedMovie}) : super(key: key);

  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(vsync: this, length: 2);
  }

  @override
  Widget build(BuildContext context) {
    MovieBloc movieBloc = BlocProvider.of(context).movieBloc;

    return StreamBuilder(
      initialData: null,
      stream: movieBloc.selectedMovie,
      builder: (context, selectedMovieSnapshot){

        Movie selectedMovie = selectedMovieSnapshot.data;
        return Scaffold(
      
      drawer:  AppDrawer(),
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
                    title: GestureDetector(
                                          child: Text((selectedMovie != null)? selectedMovie.name: "Sitcom Jokes",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                          )),
                          onTap: (){
                           Navigator.push(context, MaterialPageRoute(builder:(context) => MovieDetailsPage()));
                          },
                    ),
                    background: Image.network(
                      "https://images.pexels.com/photos/396547/pexels-photo-396547.jpeg?auto=compress&cs=tinysrgb&h=350",
                      fit: BoxFit.cover,
                    )),
                    actions: <Widget>[
                      IconButton(
                        icon:  Icon(Icons.info),
                        onPressed: (){
                            Navigator.push(context, MaterialPageRoute(builder:(context) => MovieDetailsPage()));
                        },
                      )
                    ],
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
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: (){
                  JokeType jokeType = (_tabController.index == 0)? JokeType.image : JokeType.text;
                  Navigator.push(context, MaterialPageRoute(builder: (context) => AddJokePage(jokeType: jokeType, selectedMovie: selectedMovie,)));
            
        },
      ),
);
      },
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
      color: Colors.white,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
