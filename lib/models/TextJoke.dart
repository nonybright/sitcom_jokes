import 'package:sitcom_joke_app/models/Joke.dart';
import 'package:sitcom_joke_app/utils/date_formatter.dart';

class TextJoke extends Joke{

  String text;

  TextJoke({this.text, id, title, likes, movie, dateAdded}) : super(id:id, title:title, likes:likes, movie:movie, dateAdded:dateAdded );


  TextJoke.fromMap(Map joke) {

     this.id = joke['id'];
     this.title = joke['title'];
     this.likes = joke['likes'];
     this.text =  joke['text'];
     this.dateAdded = DateTime.parse(joke['dateAdded']);
     this.movie = joke['movie'];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map =  {
      'id': this.id,
      'title': this.title,
      'likes': this.likes,
      'text': this.text,
      'movie': this.movie.id
    };
    if(this.dateAdded != null){
      map['dateAdded'] = DateFormatter.dateToString(this.dateAdded);
    }
    return map;
  }


}