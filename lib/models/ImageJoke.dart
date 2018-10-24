import 'package:sitcom_joke_app/models/Joke.dart';
import 'package:sitcom_joke_app/models/movie.dart';
import 'package:sitcom_joke_app/utils/date_formatter.dart';

class ImageJoke extends Joke{

  String url;
  ImageJoke({this.url, String id, String title, int likes, Movie movie, DateTime dateAdded}) : super(id:id, title:title, likes:likes, movie:movie, dateAdded:dateAdded );

  ImageJoke.fromMap(Map joke) {

     this.id = joke['id'];
     this.title = joke['title'];
     this.likes = joke['likes'];
     this.url =  joke['url'];
     this.dateAdded = DateTime.parse(joke['dateAdded']);
     this.movie = joke['movie'];
  }

  Map<String, dynamic> toMap() {  
    Map<String, dynamic> map =  {
      'id': this.id,
      'title': this.title,
      'likes': this.likes,
      'url': this.url,
      'movie': this.movie.id
    };
    if(this.dateAdded != null){
      map['dateAdded'] = DateFormatter.dateToString(this.dateAdded);
    }
    return map;
  }
}