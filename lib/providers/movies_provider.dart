import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:peliculas/models/models.dart';
import 'package:peliculas/models/search_response.dart';

class MoviesProvider extends ChangeNotifier {
  // Lo copiamos del postman
  String _apiKey = '9e951121ae27baa26a60dc5e0ac25c1c';
  // Esto tambien
  String _baseUrl = 'api.themoviedb.org';
  String _language = 'es-ES';

  // Tengo que estar pendiente de esto, asique lo manejamos en el Home Screen
  List<Movie> onDisplayMovies = [];
  List<Movie> popularMovies = [];

  Map<int, List<Cast>> moviesCast = {};
  int _popularPage = 0;
  MoviesProvider() {
    print('Movies Provider Inicializado');

    // Este metodo va a mandar el http
    this.getOnDisplayMovies();
    this.getPopularMovies();
  }

  // La pagina es opcional, y si no tiene ningun valor es igual a 1
  Future<String> _getJsonData(String endpoint, [int page = 1]) async {
    // Esto se copio del ejemplo de la pagina pub.dev en http
    final url = Uri.https(_baseUrl, endpoint, {
      'api_key': _apiKey,
      'language': _language,
      'page': '$page',
    });

    // Await the http get response, then decode the json-formatted response.
    final response = await http.get(url);
    return response.body;
  }

  getOnDisplayMovies() async {
    final jsonData = await _getJsonData('3/movie/now_playing');
    final nowPlayingResponse = NowPlayingResponse.fromJson(jsonData);

    onDisplayMovies = nowPlayingResponse.results;
    // Esto le dice a todos los widgets relacionados a la info que cambio
    // que sucedio un cambio en la data y que se redibujen
    notifyListeners();
  }

  getPopularMovies() async {
    _popularPage++;
    // Aca la pagina la hacemos diferente
    final jsonData = await _getJsonData('3/movie/popular', _popularPage);
    final popularResponse = PopularResponse.fromJson(jsonData);

    //Con esos ... se desestructura
    popularMovies = [...popularMovies, ...popularResponse.results];
    // Esto le dice a todos los widgets relacionados a la info que cambio
    // que sucedio un cambio en la data y que se redibujen
    notifyListeners();
  }

  Future<List<Cast>> getMovieCast(int movieId) async {
    if (moviesCast.containsKey(movieId)) return moviesCast[movieId]!;
    final jsonData = await _getJsonData('3/movie/$movieId/credits');
    final creditsResponse = CreditsResponse.fromJson(jsonData);

    moviesCast[movieId] = creditsResponse.cast;
    return creditsResponse.cast;
  }

  Future<List<Movie>> searchMovies(String query) async {
    final url = Uri.https(_baseUrl, '3/search/movie', {
      'api_key': _apiKey,
      'language': _language,
      'query': query,
    });
    final response = await http.get(url);
    final searchResponse = SearchResponse.fromJson(response.body);

    return searchResponse.results;
  }
}
