import 'package:flutter/material.dart';
import 'package:sitcom_joke_app/bloc/bloc_provider.dart';
import 'package:sitcom_joke_app/bloc/movie_bloc.dart';
import 'package:sitcom_joke_app/models/ImageJoke.dart';
import 'package:sitcom_joke_app/models/joke_type.dart';
import 'package:sitcom_joke_app/models/user.dart';
import 'package:transparent_image/transparent_image.dart';

class ImageJokeCard extends StatelessWidget {

  final ImageJoke imageJoke;
  final Function onTap;
  final User currentUser;
  ImageJokeCard(this.imageJoke, this.currentUser, this.onTap);

  @override
  Widget build(BuildContext context) {

    MovieBloc movieBloc = BlocProvider.of(context).movieBloc;
    return _cardTypeOne(this.onTap, movieBloc, context);
  }

  _cardTypeOne(onTap, MovieBloc movieBloc, context){

    return GridTile(
      child: GestureDetector(
              child: FadeInImage.memoryNetwork(
          fit: BoxFit.fill,
          placeholder: kTransparentImage,
          image: imageJoke.url,
        ),
        onTap: onTap,
      ),
      footer: GridTileBar(
        backgroundColor: Colors.black38,
        title: Text(imageJoke.title),
        trailing: IconButton(icon: Icon(Icons.favorite, color: (imageJoke.isFaved)?Colors.orange: Colors.white,), onPressed:  (){

          if(currentUser != null){
            movieBloc.toggleFavorite(imageJoke.id, JokeType.image, currentUser);
          }else{
            Scaffold.of(context).showSnackBar(SnackBar(content: Text('Login to add Favorites'),));
          }     
        },),
      ),
      
    );
  }

  _cardTypeZero(){
     return InkWell(
      child: Card(
        elevation: 5.0,
        child: Stack(
          children: <Widget>[
            Container(
                decoration: BoxDecoration(
                  image:  DecorationImage(
                    image: NetworkImage(imageJoke.url),
                    fit: BoxFit.cover
                  )
                ),
            ),
            Positioned(
              bottom: 0.0,
              left: 0.0,
              right: 0.0,

              child: Container(
                color: Colors.grey,
                child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(imageJoke.title),
                  IconButton(icon: Icon(Icons.favorite, color: (imageJoke.isFaved)?Colors.orange: Colors.white,), onPressed:  (){
 //if(currentUser != null){

                    // movieBloc.toggleFavorite(imageJoke.id, JokeType.image, currentUser);
                    //}else{
                    //  Scaffold.of(context).showSnackBar(SnackBar(content: Text('Login to add Favorites'),));
                   // }

                  },),
                ],
              ),
              ),
            )
          ],
        ),
      ),
      onTap: (){
         print(this.imageJoke.title);
      },
    );
  }
}