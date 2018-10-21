import 'dart:async';
import 'dart:collection';

import 'package:rxdart/rxdart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sitcom_joke_app/models/ImageJoke.dart';
import 'package:sitcom_joke_app/models/TextJoke.dart';
import 'package:sitcom_joke_app/models/joke_type.dart';
import 'package:sitcom_joke_app/models/load_status.dart';
import 'package:sitcom_joke_app/models/movie.dart';

class MovieBloc{

List<Movie> _movies = [];

List<ImageJoke> _imageJokes = [];
List<TextJoke> _textJokes = [];

DocumentSnapshot _lastImageJoke;
DocumentSnapshot _lastTextJoke;


int _currentImagePage  = 1;
int _currentTextPage = 1;



  
  final _moviesSubject = BehaviorSubject<UnmodifiableListView<Movie>>(
      seedValue: UnmodifiableListView([]));
  final _imageJokesSubject = BehaviorSubject<UnmodifiableListView<ImageJoke>>(
      seedValue: UnmodifiableListView([]));
  final _textJokesSubject = BehaviorSubject<UnmodifiableListView<TextJoke>>(
      seedValue: UnmodifiableListView([]));
  final _getJokesSubject = BehaviorSubject<Map>(
  seedValue: null);
  final _imageLoadStatusSubject = BehaviorSubject<LoadStatus>(seedValue: LoadStatus.loading);
  final _textLoadStatusSubject = BehaviorSubject<LoadStatus>(seedValue: LoadStatus.loading);
  final _selectedMovieSubject = BehaviorSubject<Movie>(seedValue: null);


  void Function(JokeType) get getJokes => (jokeType) => _getJokesSubject.sink.add({'jokeType':jokeType}); 

  Stream<UnmodifiableListView<Movie>> get movies => _moviesSubject.stream;
  Stream<UnmodifiableListView<ImageJoke>> get imageJokes => _imageJokesSubject.stream;
  Stream<UnmodifiableListView<TextJoke>> get textJokes => _textJokesSubject.stream;
  Stream<LoadStatus> get imageLoadStatus => _imageLoadStatusSubject.stream;
  Stream<LoadStatus> get textLoadStatus => _textLoadStatusSubject.stream;
  Stream<Movie> get selectedMovie => _selectedMovieSubject.stream;


  //sink
  Function(Movie) get changeSelectedMovie => (movie){  
                                            _currentImagePage = 1;
                                            _currentTextPage = 1;
                                            _lastImageJoke = null;
                                            _lastTextJoke = null;
                                            return _selectedMovieSubject.sink.add(movie);};

  
  MovieBloc(){

    _loadAllMovies();

      _getJokesSubject.stream.withLatestFrom(_selectedMovieSubject.stream, (Map map, Movie selectedMovie){
            map['movie'] = selectedMovie;
            return map;
      }).listen((Map map){
              JokeType jokeType = map['jokeType'];
              int currentPage = (jokeType == JokeType.image)? _currentImagePage : _currentTextPage;
              Movie movie = map['movie'];
              String jokePath = (jokeType == JokeType.image) ? 'image_jokes' : 'text_jokes';
              Query jokesQuery  = Firestore.instance.collection('jokes').document(jokePath).collection('content').orderBy('title');

              if(currentPage > 1){
                    jokesQuery = jokesQuery.startAfter((jokeType == JokeType.image) ?[_lastImageJoke['title']] : [_lastTextJoke['title']]);
                    if(jokeType == JokeType.image){
                        _imageLoadStatusSubject.sink.add(LoadStatus.loadingMore);
                    }else if(jokeType == JokeType.text){
                        _textLoadStatusSubject.sink.add(LoadStatus.loadingMore);

                    }
              }else{
                if(jokeType == JokeType.image){
                        _imageLoadStatusSubject.sink.add(LoadStatus.loading);
                }else if(jokeType == JokeType.text){
                        _textLoadStatusSubject.sink.add(LoadStatus.loading);
                }
              }

              if(movie != null){
                jokesQuery = jokesQuery.where('movie', isEqualTo: movie.id);
              }

              jokesQuery.limit(4).snapshots().listen((jokes) async {

                //await Future.delayed(Duration(seconds: 3));

                 if(jokes.documents.isNotEmpty){
                     if(jokeType == JokeType.image){

                      _lastImageJoke = jokes.documents[jokes.documents.length-1];

                      final gottenImageJokes = jokes.documents.map((joke){
                        Map jokeData = joke.data;
                        jokeData['id'] = joke.documentID;
                        jokeData['movie'] = movie; //TODO:handle when movie is null
                        return ImageJoke.fromMap(jokeData);
                      }).toList();

                      _imageJokes = (currentPage == 1) ? gottenImageJokes : _imageJokes..addAll(gottenImageJokes); 
                      _imageJokesSubject.sink.add(UnmodifiableListView(_imageJokes));
                  }else if(jokeType == JokeType.text){

                      _lastTextJoke = jokes.documents[jokes.documents.length-1];

                      final gottenTextJokes = jokes.documents.map((joke){
                        Map jokeData = joke.data;
                        jokeData['id'] = joke.documentID;
                        jokeData['movie'] = movie;

                        return TextJoke.fromMap(jokeData);

                      }).toList();
                     // _textJokes = (currentPage == 1)? gottenTextJokes : _textJokes..addAll(gottenTextJokes);
                     if(currentPage == 1){
                        _textJokes = gottenTextJokes;
                         if(jokeType == JokeType.image){
                                  _imageLoadStatusSubject.sink.add(LoadStatus.loaded);
                                  _currentImagePage++;
                          }else if(jokeType == JokeType.text){
                                  _textLoadStatusSubject.sink.add(LoadStatus.loaded);
                                  _currentTextPage++;
                          }
                     }else{
                        _textJokes.addAll(gottenTextJokes);
                        //TODO: put this in a function setLoadStatus(type, status)
                         if(jokeType == JokeType.image){
                             _imageLoadStatusSubject.sink.add(LoadStatus.loadedMore);
                         }else if(jokeType == JokeType.text){
                                  _textLoadStatusSubject.sink.add(LoadStatus.loadedMore); 
                         }
                     }
                      _textJokesSubject.sink.add(UnmodifiableListView(_textJokes));
                  }
                 }else{
                  //  if(currentPage == 1){
                  //     if(jokeType == JokeType.image){
                  //                   _imageLoadStatusSubject.sink.add(LoadStatus.loadedEmpty); //can be done by checking currentPage and loaded in the list side
                  //     }else if(jokeType == JokeType.text){
                  //                   _textLoadStatusSubject.sink.add(LoadStatus.loadedEmpty);
                  //     }
                  //  }else{
                    if(jokeType == JokeType.image){
                                    _imageLoadStatusSubject.sink.add(LoadStatus.loadEnd);
                      }else if(jokeType == JokeType.text){
                                    _textLoadStatusSubject.sink.add(LoadStatus.loadEnd);
                      }
                  // }
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
          List<Movie> movies = data.documents.map((doc) => Movie(id: doc.documentID, name: doc['name'] , description: doc['description'])).toList();
          _movies.addAll(movies);
          _moviesSubject.sink.add(UnmodifiableListView(_movies));
        });
        
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
    _imageLoadStatusSubject.close();
    _textLoadStatusSubject.close();
    _selectedMovieSubject.close();
  }
}