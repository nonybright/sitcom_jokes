import 'dart:async';
import 'dart:collection';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sitcom_joke_app/bloc/bloc_provider.dart';
import 'package:sitcom_joke_app/models/ImageJoke.dart';
import 'package:sitcom_joke_app/models/TextJoke.dart';
import 'package:sitcom_joke_app/models/bloc_completer.dart';
import 'package:sitcom_joke_app/models/joke_type.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sitcom_joke_app/models/load_status.dart';
import 'package:sitcom_joke_app/models/movie.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:sitcom_joke_app/pages/home_page.dart';

class AddJokePage extends StatefulWidget {
  final JokeType jokeType;
  final Movie selectedMovie;
  AddJokePage({Key key, this.jokeType, this.selectedMovie}) : super(key: key);

  @override
  _AddJokePageState createState() => new _AddJokePageState();
}

class _AddJokePageState extends State<AddJokePage> implements BlocCompleter {
  final _formKey = GlobalKey<FormState>();

  TextEditingController _titleController = new TextEditingController();
  TextEditingController _textController = new TextEditingController();
  int _selectedSeason;
  int _selectedEpisode;

  File _imageToUpload;
  BuildContext _context;

  GlobalKey<AutoCompleteTextFieldState<String>> key = new GlobalKey();
  final TextEditingController _movieController = TextEditingController();



  Movie _selectedMovie;

  @override
  completed(t) {
    Scaffold.of(_context).showSnackBar(new SnackBar(
      content: Text('Joke successfully uploaded'),
    ));
    Future.delayed(Duration(seconds: 2));
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => HomePage()));
  }

  @override
  error(error) {
    Scaffold.of(_context).showSnackBar(new SnackBar(
      content: Text('Error during upload'),
    ));
  }

  @override
  void initState() {
      // TODO: implement initState
      super.initState();
       _selectedMovie = widget.selectedMovie;
       if(_selectedMovie != null && _selectedMovie.id != null){
         _movieController.text = _selectedMovie.name;
       }
    }

  @override
  Widget build(BuildContext context) {
    final movieBloc = BlocProvider.of(context).movieBloc;

    return new Scaffold(
        appBar: AppBar(
          title: Text('Add Joke'),
        ),
        body: StreamBuilder<UnmodifiableListView<Movie>>(
            initialData: UnmodifiableListView<Movie>([]),
            stream: movieBloc.searchedMovieResult,
            builder: (context, searchedMovieSnapshot) {
              _context = context;
              return Form(
                key: _formKey,
                child: ListView(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            controller: _titleController,
                            decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.black12,
                                labelText: 'Title',
                                hintText: 'Title'),
                          ),

                          SizedBox(
                            height: 10.0,
                          ),
                          //start

                          _movieSelectionBox(movieBloc, searchedMovieSnapshot.data),
                          //end
                          SizedBox(
                            height: 10.0,
                          ),

                          (widget.jokeType == JokeType.image)
                              ? _imageJokeSpecificLayout()
                              : _textJokeSpecificLayout(),

                          SizedBox(
                            height: 10.0,
                          ),

                          _seasonAndEpisodeBox(),

                          StreamBuilder(
                            initialData: null,
                            stream: movieBloc.uploadLoadStatus,
                            builder: (context, uploadStatusSnapShot) {
                              LoadStatus uploadLoadStatus =
                                  uploadStatusSnapShot.data;

                              return SizedBox(
                                width: double.infinity,
                                child: RaisedButton(
                                  color: const Color(0Xfffe0e4f),
                                  child: (uploadLoadStatus ==
                                          LoadStatus.loading)
                                      ? CircularProgressIndicator()
                                      : Text(
                                          'ADD JOKE',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                  onPressed:
                                      (uploadLoadStatus == LoadStatus.loading)
                                          ? null
                                          : () {
                                              _submitJoke(movieBloc);
                                            },
                                ),
                              );
                            },
                          )
                        ],
                      ),
                    )
                  ],
                ),
              );
            }));
  }

  _submitJoke(movieBloc) {
    if (_formKey.currentState.validate()) {
      DateTime dateAdded = DateTime.now();
      if (_selectedMovie != null) {
        if (widget.jokeType == JokeType.text) {
          movieBloc.upLoadJoke(
              TextJoke(
                  id: null,
                  movie: _selectedMovie,
                  dateAdded: dateAdded,
                  likes: 0,
                  title: _titleController.text,
                  text: _textController.text),
              null,
              this);
        } else {
          if (_imageToUpload != null) {
            movieBloc.upLoadJoke(
                ImageJoke(
                  id: null,
                  movie: _selectedMovie,
                  dateAdded: dateAdded,
                  likes: 0,
                  title: _titleController.text,
                  url: null,
                ),
                _imageToUpload,
                this);
          } else {
            Scaffold.of(context).showSnackBar(SnackBar(
              content: Text('Please select an image to upload'),
            ));
          }
        }
      } else {
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text('Please select a movie'),
        ));
      }
    }
  }

  _movieSelectionBox(movieBloc, searchedMovies){

    return  TypeAheadFormField(
                            textFieldConfiguration: TextFieldConfiguration(
                              onChanged: (value) {
                                print(value);
                              },
                              decoration: InputDecoration(
                                hintText: 'Movie',
                                labelText: 'Movie',
                                filled: true,
                                fillColor: Colors.black12,
                              ),
                              controller: this._movieController,
                            ),
                            suggestionsCallback: (pattern) {
                              print(pattern);
                              movieBloc.getMoviesLike(pattern);
                              return _getMovieNamesListS(
                                  searchedMovies);
                            },
                            itemBuilder: (context, suggestion) {
                              return ListTile(
                                title: Text(suggestion),
                              );
                            },
                            transitionBuilder:
                                (context, suggestionsBox, controller) {
                              return suggestionsBox;
                            },
                            onSuggestionSelected: (suggestion) {
                              this._movieController.text = suggestion;
                              setState(() {
                                // this._selectedMovie = suggestion;
                              });
                            },
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please select a Movie';
                              }
                            },
                          );
  }

  _seasonAndEpisodeBox() {
    return (_selectedMovie != null && _selectedMovie.seasons != null)
        ? Row(
            children: <Widget>[
              _dropDownBox(
                  items: List.generate(
                      _selectedMovie.seasons, (index) => index + 1),
                  value: _selectedSeason,
                  hint: 'Season',
                  onChanged: (season) {
                    setState(() {
                      _selectedSeason = season;
                    });
                  }),
              SizedBox(
                width: 10.0,
              ),
              _dropDownBox(
                  items: List.generate(
                      _selectedMovie.maxEpisodes, (index) => index + 1),
                  value: _selectedEpisode,
                  hint: 'Episode',
                  onChanged: (episode) {
                    setState(() {
                      _selectedEpisode = episode;
                    });
                  }),
            ],
          )
        : Container();
  }

  List<Movie> _getMovieNamesList(UnmodifiableListView<Movie> movies) {
    if (movies.isNotEmpty) {
      return movies;
    } else {
      return [
        Movie(id: 'sss', name: 'dddzz'),
        Movie(id: 'asss', name: 'aaadddzz'),
        Movie(id: 'bsss', name: 'bbbdddzz'),
      ];
    }
  }

  List<String> _getMovieNamesListS(UnmodifiableListView<Movie> movies) {
    List<String> movieList = movies.map((moive) => moive.name).toList();
    List<String> ss =
        (movieList.isNotEmpty) ? movieList : ['friends', 'himym', 'bbt'];
    return ss;
  }

  _dropDownBox({List<dynamic> items, Function onChanged, value, String hint}) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.black12,
          border: Border(bottom: BorderSide(color: Colors.grey))),
      child: Padding(
        padding: const EdgeInsets.only(left: 12.0),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<dynamic>(
            hint: Text(hint),
            value: value,
            items: items.map((dynamic value) {
              return new DropdownMenuItem<dynamic>(
                value: value,
                child: new Text(value.toString()),
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ),
      ),
    );
  }

  _imageJokeSpecificLayout() {
    return Column(
      children: <Widget>[
        Container(
          height: 180.0,
          width: 180.0,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: (_imageToUpload != null)
                      ? FileImage(_imageToUpload)
                      : AssetImage('assets/images/app_logo.jpg'))),
        ),
        RaisedButton(
          child: Text(
            'SELECT IMAGE',
            style: TextStyle(color: Colors.white),
          ),
          color: const Color(0Xfffe0e4f),
          onPressed: () {
            _getImageFromGallery();
          },
        )
      ],
    );
  }

  _getImageFromGallery() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _imageToUpload = image;
    });
  }

  _textJokeSpecificLayout() {
    return TextFormField(
      maxLines: null,
      controller: _textController,
      keyboardType: TextInputType.multiline,
      decoration: InputDecoration(
          filled: true, fillColor: Colors.black12, hintText: 'Text Joke\n\n\n', labelText: 'Text Joke'),
    );
  }
}
