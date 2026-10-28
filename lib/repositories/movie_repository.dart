import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:southsea_cinema/models/movie.dart';

class MovieRepository {
  static List<Movie>? _cachedMovies;

  Future<List<Movie>> loadMoviesFromAsset({
    String assetPath = 'assets/data/movies.json',
  }) async {
    if (assetPath == 'assets/data/movies.json' && _cachedMovies != null) {
      return List<Movie>.unmodifiable(_cachedMovies!);
    }

    final jsonString = await rootBundle.loadString(assetPath);
    final decodedData = jsonDecode(jsonString);
    if (decodedData is! List<dynamic>) {
      throw const FormatException('Movie asset must contain a JSON array.');
    }

    final movies = decodedData.map((item) {
      if (item is! Map<String, dynamic>) {
        throw const FormatException(
          'Each movie in the asset must be a JSON object.',
        );
      }
      return Movie.fromJson(item);
    }).toList();

    if (assetPath == 'assets/data/movies.json') {
      _cachedMovies = movies;
    }
    return List<Movie>.unmodifiable(movies);
  }

  Future<List<Movie>> getMovies() async {
    final cachedMovies = _cachedMovies;
    if (cachedMovies != null) {
      return List<Movie>.unmodifiable(cachedMovies);
    }
    return loadMoviesFromAsset();
  }

  Future<Movie?> getMovieById(String id) async {
    for (final movie in await getMovies()) {
      if (movie.id == id) {
        return movie;
      }
    }
    return null;
  }

  Future<List<Movie>> getMoviesByAgeRating(String rating) async {
    return (await getMovies())
        .where((movie) => movie.ageRating == rating)
        .toList();
  }

  Future<List<Movie>> getMoviesUnderPrice(double maxPrice) async {
    return (await getMovies())
        .where((movie) => movie.price < maxPrice)
        .toList();
  }
}
