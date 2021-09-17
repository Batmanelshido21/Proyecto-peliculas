import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:peliculas/helpers/debouncer.dart';
import 'package:peliculas/models/credit_responses.dart';
import 'package:peliculas/models/movie.dart';
import 'package:peliculas/models/now_playing_response.dart';
import 'package:peliculas/models/pupular_response.dart';
import 'package:peliculas/models/search_movies_response.dart';


class MoviesProvider extends ChangeNotifier{

  String _apiKey='d69241e1b424935e1e7e4cf7c4332abf';
  String _baseUrl='api.themoviedb.org';
  String _language='es-ES'; 
  
  List<Movie> onDisplayMovies =[];
  List<Movie> popularMovies=[];
  Map<int, List<Cast>> moviesCast={};

  int popularPage=0;
  final debouncer = Debouncer(
    duration:Duration(milliseconds: 500),
  );
  final StreamController<List<Movie>> _steamController= new StreamController.broadcast(); 
  Stream<List<Movie>> get suggestionStream=>this._steamController.stream;

  MoviesProvider(){
    print('Movies provider inicializado');
    getOnDisplayMovies();
    getPopularMovies();
  }

  Future <String> _getJsonData(String endPoin, [int page =1]) async{
    var url = Uri.https(_baseUrl, endPoin,{
      'api_key': _apiKey,
      'language': _language,
      'page': '$page'
    });
    final response = await http.get(url);
    return response.body;
  }

  getOnDisplayMovies() async{
    final jsonData = await this._getJsonData('3/movie/now_playing');
    final nowPlayingResponse = NowPlayingResponse.fromJson(jsonData);
    onDisplayMovies = nowPlayingResponse.results;
    notifyListeners();
  }

  getPopularMovies() async{
    popularPage++;
    final jsonData = await this._getJsonData('3/movie/popular',popularPage);
    final popularResponse = PopularResponse.fromJson(jsonData);
    popularMovies = [ ...popularMovies, ...popularResponse.results];
    notifyListeners();
  }

  Future <List<Cast>>getMovieCast(int movieId) async{
    if(moviesCast.containsKey(movieId)) return moviesCast[movieId]!;
    print('pidiendo infor al servidor');
    final jsonData = await this._getJsonData('3/movie/$movieId/credits');
    final creditResponse = CreditsResponse.fromJson(jsonData);
    moviesCast[movieId] = creditResponse.cast;
    return creditResponse.cast;
  }

  Future<List<Movie>>searchMovie(String query) async{
    
    final url = Uri.https(_baseUrl,'3/search/movie',{
      'api_key': _apiKey,
      'language': _language,
      'query': query
    });
    final response = await http.get(url);
    final searchResponse = SearchResponse.fromJson(response.body);
    print(searchResponse.results);
    return searchResponse.results;
  }

  void getSuggestionsByQuery(String query){
    debouncer.value='';
    debouncer.onValue=(value) async{
      final results = await this.searchMovie(value);
      this._steamController.add(results);
    };
    final timer = Timer.periodic(Duration(milliseconds: 300),(_){
      debouncer.value = query;
     });
     Future.delayed(Duration(milliseconds: 301)).then((_) => timer.cancel());
  }
}