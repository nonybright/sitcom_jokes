import 'package:flutter/material.dart';
import 'package:sitcom_joke_app/models/ImageJoke.dart';
import 'package:transparent_image/transparent_image.dart';

class ImageJokeCard extends StatelessWidget {

  final ImageJoke imageJoke;
  final Function onTap;
  ImageJokeCard(this.imageJoke, this.onTap);

  @override
  Widget build(BuildContext context) {
    return _cardTypeOne(this.onTap);
  }

  _cardTypeOne(onTap){

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
        trailing: IconButton(icon: Icon(Icons.favorite,), onPressed:  (){},),
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
                  IconButton(icon: Icon(Icons.favorite,), onPressed:  (){},),
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