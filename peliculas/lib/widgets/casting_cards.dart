import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:peliculas/models/credit_responses.dart';
import 'package:peliculas/providers/movies_provider.dart';
import 'package:provider/provider.dart';

class CastinCards extends StatelessWidget {
  
 final int id;

  const CastinCards({required this.id});
  
  @override
  Widget build(BuildContext context) {
    final moviesProvider = Provider.of<MoviesProvider>(context, listen: false);

    return FutureBuilder(
      future: moviesProvider.getMovieCast(id),
      builder: (_, AsyncSnapshot<List<Cast>> snapshot){
       if(!snapshot.hasData){
          return Container(
          height: 180,
          child: CupertinoActivityIndicator(),
        );
       }

        final List<Cast> cast = snapshot.data!;
        
         return Container(
          margin: EdgeInsets.only(bottom: 30),
          width: double.infinity,
          height: 180,
          child: ListView.builder(
          itemCount: 10,
          scrollDirection: Axis.horizontal,
          itemBuilder: (_, int index)=>_CastCard(actor: cast[index],),
        ),
      );         
      },
    );
  }
}

class _CastCard extends StatelessWidget {

  final Cast actor;

  const _CastCard({required this.actor});

  @override
  Widget build(BuildContext context) {

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      width:  110,
      height: 100,
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: FadeInImage(
              placeholder: AssetImage('assets/no-image.jpg'), 
              image: NetworkImage(actor.fullProfilePath),
              height: 130,
              width: 100,
              fit: BoxFit.cover
            )
          ),
          SizedBox(height: 5),
          Text(
            actor.name,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}
