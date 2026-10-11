import 'package:flutter_test/flutter_test.dart';
import 'package:southsea_cinema/repositories/movie_repository.dart';

void main() {
  group('MovieRepository tests', () {
    final repository = MovieRepository();

    test('returns at least two movies with valid details and unique IDs', () {
      final movies = repository.getMovies();
      final ids = movies.map((movie) => movie.id).toSet();

      expect(movies.length, greaterThanOrEqualTo(2));
      expect(ids.length, movies.length);

      for (final movie in movies) {
        expect(movie.id, isNotEmpty);
        expect(movie.title, isNotEmpty);
        expect(movie.ageRating, isNotEmpty);
        expect(movie.price, greaterThan(0));
      }
    });

    test('returns the movie matching an existing ID', () {
      final expectedMovie = repository.getMovies().first;

      expect(repository.getMovieById(expectedMovie.id), expectedMovie);
    });

    test('returns null when no movie matches the ID', () {
      expect(repository.getMovieById('missing_movie'), isNull);
    });

    test('returns only movies matching the age rating', () {
      final movies = repository.getMoviesByAgeRating('PG');

      expect(movies, isNotEmpty);
      expect(movies.every((movie) => movie.ageRating == 'PG'), isTrue);
      expect(repository.getMoviesByAgeRating('U'), isEmpty);
    });

    test('returns only movies priced below 7 pounds', () {
      final movies = repository.getMoviesUnderPrice(7.0);

      expect(movies, isNotEmpty);
      expect(movies.every((movie) => movie.price < 7.0), isTrue);
      expect(repository.getMoviesUnderPrice(6.0), isEmpty);
    });
  });
}
