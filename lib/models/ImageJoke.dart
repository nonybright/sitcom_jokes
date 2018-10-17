import 'package:sitcom_joke_app/models/Joke.dart';

class ImageJoke extends Joke{

  String url;
  ImageJoke({this.url, id, title, likes, movie, dateAdded}) : super(id:id, title:title, likes:likes, movie:movie, dateAdded:dateAdded );

  ImageJoke.fromMap(Map joke) {

     this.id = joke['id'];
     this.title = joke['title'];
     this.likes = joke['likes'];
     this.url =  joke['url'];
     this.dateAdded = DateTime(joke['dateAdded']);
     this.movie = joke['movie'];
  }

}