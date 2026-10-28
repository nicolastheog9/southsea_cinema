import 'package:flutter_test/flutter_test.dart';
import 'package:southsea_cinema/repositories/movie_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('MovieRepository tests', () {
    late MovieRepository repository;

    setUp(() {
      repository = MovieRepository();
    });

    test('loads every film from the registered JSON asset', () async {
      final movies = await repository.loadMoviesFromAsset();

      expect(movies, hasLength(2));
      expect(
        movies.map((movie) => movie.id),
        containsAll(['how_to_train_your_dragon_2', 'the_wild_robot']),
      );
      for (final movie in movies) {
        expect(movie.id, isNotEmpty);
        expect(movie.title, isNotEmpty);
        expect(movie.ageRating, isNotEmpty);
        expect(movie.synopsis, isNotEmpty);
        expect(movie.screeningTime, isNotEmpty);
        expect(movie.imagePath, isNotEmpty);
        expect(movie.price, greaterThan(0));
      }
    });

    test('caches the asset list for getMovies', () async {
      final loadedMovies = await repository.loadMoviesFromAsset();

      expect(await repository.getMovies(), loadedMovies);
    });

    test('returns the movie matching an existing ID', () async {
      final movies = await repository.getMovies();

      expect(
        await repository.getMovieById(movies.first.id),
        movies.first,
      );
    });

    test('returns null when no movie matches an ID', () async {
      expect(await repository.getMovieById('missing_movie'), isNull);
    });

    test('returns only movies matching the age rating', () async {
      final movies = await repository.getMoviesByAgeRating('PG');

      expect(movies, isNotEmpty);
      expect(movies.every((movie) => movie.ageRating == 'PG'), isTrue);
      expect(await repository.getMoviesByAgeRating('U'), isEmpty);
    });

    test('returns only movies priced below the specified price', () async {
      final movies = await repository.getMoviesUnderPrice(7.0);

      expect(movies, isNotEmpty);
      expect(movies.every((movie) => movie.price < 7.0), isTrue);
      expect(await repository.getMoviesUnderPrice(6.0), isEmpty);
    });
  });
}
