import 'package:flutter/material.dart';
import 'package:peliculas/models/movie.dart';
import 'package:peliculas/widgets/widgets.dart';

class DetailScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    //Cambiar por la intancia de una pelicula
    final Movie movie = ModalRoute.of(context)!.settings.arguments as Movie;

    print(movie.title);
    return Scaffold(
       body: CustomScrollView(
         slivers: [
           _CustomAppBar(movie: movie),
           SliverList(
             delegate: SliverChildListDelegate([
               _PosterAndTitle(movie: movie),
               _Overview(movie: movie),
               CastinCards(id: movie.id,)
             ]),
           ),
         ],
       ),
    );
  }
}

class _CustomAppBar extends StatelessWidget {

  final Movie movie;

  const _CustomAppBar({Key? key, required this.movie}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Colors.red,
      expandedHeight: 200,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        titlePadding: EdgeInsets.all(0),
        title: Container(
          color: Colors.black12,
          width: double.infinity,
          alignment: Alignment.bottomCenter,
          padding: EdgeInsets.only(bottom: 5, left: 10, right: 10),
          child: Text(
            movie.title,
            style: TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          )
        ),
      background: FadeInImage(
        placeholder: AssetImage('assets/loading.gif'), 
        image: NetworkImage(movie.fullBAckdropPath),
        fit: BoxFit.cover,
      ),
      ),
    );
  }
}

class _PosterAndTitle extends StatelessWidget {
  
  final Movie movie;

  const _PosterAndTitle({Key? key, required this.movie}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final TextTheme textTheme = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;

    return Container(
      margin: EdgeInsets.only(top: 20),
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Hero(
            tag: movie.heroId!,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: FadeInImage(
                placeholder: AssetImage('assets/no-image.jpg'), 
                image: NetworkImage(movie.fullPosterImg),
                height: 150,
              ),
            ),
          ),
          SizedBox(width: 20,),
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: size.width-190),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  movie.title,
                  style: textTheme.headline5,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
                Text(
                  movie.originalTitle,
                  style: textTheme.subtitle1,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
                Row(
                  children: [
                    Icon(Icons.star_outline, size: 15, color: Colors.yellow),
                    SizedBox(width: 5,),
                    Text('${movie.voteAverage}', style: textTheme.caption,)
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _Overview extends StatelessWidget {

   final Movie movie;

  const _Overview({Key? key, required this.movie}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
       margin: EdgeInsets.only(top: 10),
       padding: EdgeInsets.symmetric(horizontal: 10),
      child: Text(
        movie.overview,
        textAlign: TextAlign.justify,
      ),
    );
  }
}