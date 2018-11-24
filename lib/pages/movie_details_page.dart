import 'package:flutter/material.dart';
import 'package:sitcom_joke_app/bloc/bloc_provider.dart';
import 'package:sitcom_joke_app/bloc/movie_bloc.dart';
import 'package:sitcom_joke_app/models/movie.dart';
import 'package:sliver_fab/sliver_fab.dart';

class MovieDetailsPage extends StatefulWidget {
  MovieDetailsPage({Key key}) : super(key: key);

  @override
  _MovieDetailsPageState createState() => new _MovieDetailsPageState();
}

class _MovieDetailsPageState extends State<MovieDetailsPage> {


  Movie selectedMovieSnapshot = new Movie(
         id: 'ww',
         name: 'Friends',
         seasons: 10,
         dateStarted: DateTime(1993,10, 21),
         dateEnded: DateTime(2003, 10, 21),
         description: 'This is full description of the movie that we are talking about'


  );


  @override
  Widget build(BuildContext context) {

    MovieBloc movieBloc = BlocProvider.of(context).movieBloc;

    return StreamBuilder(
       initialData: null,
       stream: movieBloc.selectedMovie,
       builder: (context, selectedMovieSnapshot){
         Movie selectedMovie = selectedMovieSnapshot.data;

         return Scaffold(
      body: SliverFab(
          floatingActionButton: _movieFollowButton(),
          expandedHeight: 256.0,
          slivers: <Widget>[
            new SliverAppBar(
              expandedHeight: 256.0,
              pinned: true,
              flexibleSpace: new FlexibleSpaceBar(
                title: new Text("Friends"),
                centerTitle: true,
                background: new Image.asset(
                  "assets/images/header_bg.jpg",
                  fit: BoxFit.cover,
                ),
              ),
            ),
            new SliverList(
              delegate: new SliverChildListDelegate(
                <Widget>[
                    Container(
                      color: Colors.black,
                      //padding: EdgeInsets.only(top: 25.0,bottom: 10.0, left: 10.0, right: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                            Container(
                              padding: EdgeInsets.only(top:20.0, left: 10.0, right: 10.0, bottom: 20.0),
                              color: Colors.white,
                              width: 100.0,
                              child: Column(
                                children: <Widget>[
                                  
                                  _countDetailBox('IMAGES', 1000),
                                  Divider(color: Colors.grey[300],height: 30.0,),
                                  _countDetailBox('TEXTS', 9000),
                                   Divider(color: Colors.grey[300],height: 30.0,),
                                  _countDetailBox('FOLLOWERS', 20000),

                                ],
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Container(
                                padding: EdgeInsets.only(top:20.0, left: 10.0, bottom: 20.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Text('Bio', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                    Text('Bio of the stuff that i am about to write about right now', style: TextStyle(color: Colors.grey,)),
                                   Text('The Expanded stuff')
                                  ],
                                ),
                              ),
                            )
                      ],),
                    ),
                    
                    _samplePics(),
                    _mainDetails(),
                ]
              ),
            ),
          ],
        ),
    ); 

       },
    );
    
  }
}

_samplePics(){
  return GridView(
    shrinkWrap: true,
    padding: EdgeInsets.all(0.0),
         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,),
                        children: <Widget>[
                          _gridImageContainer('assets/images/header_bg.jpg'),
                          _gridImageContainer('assets/images/header_bg.jpg'),
                          _gridImageContainer('assets/images/header_bg.jpg'),
                        ],
  );
}

_gridImageContainer(String url){
   return Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(image: AssetImage(url), fit: BoxFit.cover),
                                
                              ),
                            );
}

_mainDetails(){

  return Container(
      padding: EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('The title Stuff', style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),),
          SizedBox(height: 10.0,),
          Text('This is the complete description of the movie that will be displayed \n\n\n. This will'+
          'This is the complete description of the movie that will be displayed ')
        ],
      ),

  );

}

_countDetailBox(String detail , int count){

  return Column(

      children: <Widget>[
        Text(count.toString(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0),),
        SizedBox(height: 5.0,),
        Text(detail, style: TextStyle(fontSize: 12.0, color: Colors.grey),),
        
      ],
  );
}

_movieFollowButton(){
  
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(10.0)),
      gradient: LinearGradient(
        colors: [
          Colors.orange,
          const Color(0Xfffe0e4f)
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        stops: [
          0.3,
          0.9
        ]
      )
    ),
        child: FlatButton(
          child: (1 == 2)? Text('FOLLOW', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),):Row(
            children: <Widget>[
              Icon(Icons.favorite, color: Colors.white,),
              SizedBox(width: 10.0,),
              Text('FOLLOWING',style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))
            ],
          ),
          onPressed: (){

          },
        ),
  );
}