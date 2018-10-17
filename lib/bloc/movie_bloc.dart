import 'dart:async';
import 'dart:collection';

import 'package:rxdart/rxdart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sitcom_joke_app/models/ImageJoke.dart';
import 'package:sitcom_joke_app/models/TextJoke.dart';
import 'package:sitcom_joke_app/models/joke_type.dart';
import 'package:sitcom_joke_app/models/movie.dart';

class MovieBloc{

List<Movie> _movies = [];

List<ImageJoke> _imageJokes = [];
List<TextJoke> _textJokes = [];

DocumentSnapshot _lastImageJoke;
DocumentSnapshot _lastTextJoke;



  
  final _moviesSubject = BehaviorSubject<UnmodifiableListView<Movie>>(
      seedValue: UnmodifiableListView([]));
  final _imageJokesSubject = BehaviorSubject<UnmodifiableListView<ImageJoke>>(
      seedValue: UnmodifiableListView([]));
  final _textJokesSubject = BehaviorSubject<UnmodifiableListView<TextJoke>>(
      seedValue: UnmodifiableListView([]));
  final _getJokesSubject = BehaviorSubject<Map>(
  seedValue: null);
  void Function(int, JokeType, Movie) get getJokes => (currentPage, jokeType, movie) => _getJokesSubject.sink.add({'currentPage':currentPage, 'jokeType':jokeType, 'movie': movie}); 

  Stream<UnmodifiableListView<Movie>> get movies => _moviesSubject.stream;
  Stream<UnmodifiableListView<ImageJoke>> get imageJokes => _imageJokesSubject.stream;
  Stream<UnmodifiableListView<TextJoke>> get textJokes => _textJokesSubject.stream;



  MovieBloc(){

    _loadAllMovies();


      _getJokesSubject.stream.listen((Map map){

              int currentPage = map['currentPage'];
              JokeType jokeType = map['jokeType'];
              Movie movie = map['movie'];
              String jokePath = (jokeType == JokeType.image) ? 'image_jokes' : 'text_jokes';
              Query jokesQuery  = Firestore.instance.collection('jokes').document(jokePath).collection('content').orderBy('title');

              if(currentPage > 1){
                    jokesQuery = jokesQuery.startAfter((jokeType == JokeType.image) ?_lastImageJoke['title'] : _lastTextJoke['title']);
              }

              jokesQuery.limit(5).snapshots().listen((jokes){

                  if(jokeType == JokeType.image){

                      final gottenImageJokes = jokes.documents.map((joke){
                        Map jokeData = joke.data;
                        jokeData['id'] = joke.documentID;
                        jokeData['movie'] = movie; //TODO:handle when movie is null
                        return ImageJoke.fromMap(jokeData);
                      }).toList();

                      _imageJokes = (currentPage == 1) ? gottenImageJokes : _imageJokes..addAll(gottenImageJokes); 
                      _imageJokesSubject.sink.add(UnmodifiableListView(_imageJokes));
                  }else if(jokeType == JokeType.text){

                      final gottenTextJokes = jokes.documents.map((joke){
                        Map jokeData = joke.data;
                        jokeData['id'] = joke.documentID;
                        jokeData['movie'] = movie;

                        return TextJoke.fromMap(jokeData);

                      }).toList();
                     // _textJokes = (currentPage == 1)? gottenTextJokes : _textJokes..addAll(gottenTextJokes);
                     if(currentPage == 1){
                        _textJokes = gottenTextJokes;
                     }else{
                        _textJokes.addAll(gottenTextJokes);
                     }
                      _textJokesSubject.sink.add(UnmodifiableListView(_textJokes));
                  }
              });
      });

  }

  _loadAllMovies(){

        // List<Movie> movies = [
        //    Movie(id: '1', name: 'friends', description: 'i\'ll be there for you', seasons: 10, maxEpisodes: 24, dateStarted: null, dateEnded: null),
        //    Movie(id: '2', name: 'himym', description: 'i\'ll be there for you', seasons: 10, maxEpisodes: 24, dateStarted: null, dateEnded: null),
        //    Movie(id: '3', name: 'evry hates chris', description: 'i\'ll be there for you', seasons: 10, maxEpisodes: 24, dateStarted: null, dateEnded: null),
        //    Movie(id: '4', name: 'bbt', description: 'i\'ll be there for you', seasons: 10, maxEpisodes: 24, dateStarted: null, dateEnded: null),
        //    Movie(id: '5', name: 'my wife n kids', description: 'i\'ll be there for you', seasons: 10, maxEpisodes: 24, dateStarted: null, dateEnded: null),
        //    Movie(id: '6', name: 'baby daddy', description: 'i\'ll be there for you', seasons: 10, maxEpisodes: 24, dateStarted: null, dateEnded: null)
        // ];

        Firestore.instance.collection('movies').snapshots().listen((data){
          List<Movie> movies = data.documents.map((doc) => Movie(name: doc['name'] , description: doc['description'])).toList();
          _movies.addAll(movies);
          _moviesSubject.sink.add(UnmodifiableListView(_movies));
        });

        // Firestore.instance.collection('jokes').document('image_jokes').collection('content').limit(3).snapshots().listen((imageJokes){

        //       print("This is the joke part");
        //       dynamic fil = imageJokes.documents[1];
        //       Firestore.instance.collection('jokes').document('image_jokes').collection('content').orderBy('title').startAfter([fil['title']]).snapshots().listen((nes){

        //          print("This is the joke part");

        //       });
        // });
        
  }


  _addJokes(){

      String friends = '9KfSaN86fI4plZHqURmX';
      String himym = 'IHDbyYe2a8D9xhmZ1nkY';

    final textJokes = [

        TextJoke(title: 'chan', text: 'knock knock', likes: 1, movie: Movie(id: friends), dateAdded: DateTime.now()),
        TextJoke(title: 'ross', text: 'ros knock knock', likes: 1, movie: Movie(id: friends), dateAdded: DateTime.now()),
        TextJoke(title: 'rach', text: 'knock knock', likes: 1, movie: Movie(id: friends), dateAdded: DateTime.now()),
        TextJoke(title: 'joe', text: 'knock knock', likes: 1, movie: Movie(id: friends), dateAdded: DateTime.now()),
        TextJoke(title: 'phoebe', text: 'dd knock knock', likes: 1, movie: Movie(id: friends), dateAdded: DateTime.now()),
        TextJoke(title: 'jennis', text: 'jen hahaha knock knock', likes: 1, movie: Movie(id: friends), dateAdded: DateTime.now()),
        TextJoke(title: '2chan', text: 'knock knock', likes: 1, movie: Movie(id: friends), dateAdded: DateTime.now()),
        TextJoke(title: '2ross', text: 'ros knock knock', likes: 1, movie: Movie(id: friends), dateAdded: DateTime.now()),
        TextJoke(title: '2rach', text: 'knock knock', likes: 1, movie: Movie(id: friends), dateAdded: DateTime.now()),
        TextJoke(title: '2joe', text: 'knock knock', likes: 1, movie: Movie(id: friends), dateAdded: DateTime.now()),
        TextJoke(title: '2phoebe', text: 'dd knock knock', likes: 1, movie: Movie(id: friends), dateAdded: DateTime.now()),
        TextJoke(title: '2jennis', text: 'jen hahaha knock knock', likes: 1, movie: Movie(id: friends), dateAdded: DateTime.now()),
        TextJoke(title: 'barney', text: 'legendary', likes: 1, movie: Movie(id: himym), dateAdded: DateTime.now()),
        TextJoke(title: 'robin', text: 'ff legendary', likes: 1, movie: Movie(id: himym), dateAdded: DateTime.now()),
        TextJoke(title: 'ted', text: ' rr legendary', likes: 1, movie: Movie(id: himym), dateAdded: DateTime.now()),
        TextJoke(title: 'marshal', text: 'rrw legendary', likes: 1, movie: Movie(id: himym), dateAdded: DateTime.now()),
        TextJoke(title: 'lily', text: ' rr legendary', likes: 1, movie: Movie(id: himym), dateAdded: DateTime.now()),
        TextJoke(title: 'mother', text: 'legendary', likes: 1, movie: Movie(id: himym), dateAdded: DateTime.now()),
        TextJoke(title: '2barney', text: 'legendary', likes: 1, movie: Movie(id: himym), dateAdded: DateTime.now()),
        TextJoke(title: '2robin', text: 'ff legendary', likes: 1, movie: Movie(id: himym), dateAdded: DateTime.now()),
        TextJoke(title: '2ted', text: ' rr legendary', likes: 1, movie: Movie(id: himym), dateAdded: DateTime.now()),
        TextJoke(title: '2marshal', text: 'rrw legendary', likes: 1, movie: Movie(id: himym), dateAdded: DateTime.now()),
        TextJoke(title: '2lily', text: ' rr legendary', likes: 1, movie: Movie(id: himym), dateAdded: DateTime.now()),
        TextJoke(title: '2mother', text: 'legendary', likes: 1, movie: Movie(id: himym), dateAdded: DateTime.now()),
    ];
    

    textJokes.forEach((joke) async{
          Map jokeMap = joke.toMap();
          jokeMap.remove('id');
          await Firestore.instance.collection('jokes').document('text_jokes').collection('content').add(jokeMap);
    });
    // Firestore.instance.collection('jokes').document('text_jokes').collection('content').add(data);
  }

  // _loadJokes(){

  //     final imageJokes =[
  //         ImageJoke(id:'1', title: 'imgjoke', url: 'aa',movie: Movie(id:'6') ),
  //         ImageJoke(id:'2', title: 'imgjoke', url: 'bb',movie: Movie(id:'6') ),
  //         ImageJoke(id:'3', title: 'imgjoke', url: 'cc',movie: Movie(id:'6') ),
  //         ImageJoke(id:'4', title: 'imgjoke', url: 'dd',movie: Movie(id:'6') ),
  //     ];

  //     final textJokes = [
  //           TextJoke(id: '5', text: 'hello'),
  //           TextJoke(id: '5', text: 'hi'),
  //           TextJoke(id: '5', text: 'how'),
  //           TextJoke(id: '5', text: 'are'),
  //           TextJoke(id: '5', text: 'you'),
  //     ];

  //     _imageJokes.addAll(imageJokes);
  //     _textJokes.addAll(textJokes);

  //     _imageJokesSubject.sink.add(UnmodifiableListView(_imageJokes));
  //     _textJokesSubject.sink.add(UnmodifiableListView(_textJokes));


  // }


  close(){
    _moviesSubject.close();
    _imageJokesSubject.close();
    _textJokesSubject.close();
    _getJokesSubject.close();
  }
}