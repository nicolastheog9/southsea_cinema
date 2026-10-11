import 'package:flutter_test/flutter_test.dart';
import 'package:southsea_cinema/models/movie.dart';

void main(){
  group('Movie model tests',() {
    test('Stores the values passed to its constructor',(){
      const testMovie = Movie(
        id: 'test_movie',
        title: 'Test Movie',
        ageRating: 'PG',
        synopsis: 'This is a test movie synopsis.',
        screeningTime: 'Friday at 7:00 PM',
        imagePath: 'assets/images/test_movie.jpg',
        price: 6.0,
      );

      expect(testMovie.id, 'test_movie');
      expect(testMovie.title, 'Test Movie');
      expect(testMovie.ageRating, 'PG');
      expect(testMovie.synopsis, 'This is a test movie synopsis.');
      expect(testMovie.screeningTime, 'Friday at 7:00 PM');
      expect(testMovie.imagePath, 'assets/images/test_movie.jpg');
      expect(testMovie.price, 6.0);
    });

    test('formats the price to two decimal places', (){
      const testMovie = Movie(
        id: 'test_movie',
        title: 'Test Movie',
        ageRating: 'PG',
        synopsis: 'This is a test movie synopsis.',
        screeningTime: 'Friday at 7:00 PM',
        imagePath: 'assets/images/test_movie.jpg',
        price: 6.0,
      );

      expect(testMovie.formattedPrice, '£6.00');
    });

    test('identifies child friendly age ratings for movies',(){
      const uRatedMovie = Movie(
        id: 'u_rated_movie',
        title: 'U Rated Movie',
        ageRating: 'U',
        synopsis: 'This is a U rated movie synopsis.',
        screeningTime: 'Saturday at 3:00 PM',
        imagePath: 'assets/images/u_rated_movie.jpg',
        price: 6,
      );
      const pgRatedMovie = Movie(
        id: 'pg_rated_movie',
        title: 'PG Rated Movie',
        ageRating: 'PG',
        synopsis: 'This is a PG rated movie synopsis.',
        screeningTime: 'Saturday at 5:00 PM',
        imagePath: 'assets/images/pg_rated_movie.jpg',
        price: 6,
      );
      const adultRatedMovie = Movie(
        id: 'adult_rated_movie',
        title: 'Adult Rated Movie',
        ageRating: '18',
        synopsis: 'This is an adult rated movie synopsis.',
        screeningTime: 'Saturday at 9:00 PM',
        imagePath: 'assets/images/adult_rated_movie.jpg',
        price: 6,
      );

      expect(uRatedMovie.isChildFriendly, true);
      expect(pgRatedMovie.isChildFriendly, true);
      expect(adultRatedMovie.isChildFriendly, false);
    });

    test('identifies adult only age ratings for movies',(){
      const uRatedMovie = Movie(
        id: 'u_rated_movie',
        title: 'U Rated Movie',
        ageRating: 'U',
        synopsis: 'This is a U rated movie synopsis.',
        screeningTime: 'Saturday at 3:00 PM',
        imagePath: 'assets/images/u_rated_movie.jpg',
        price: 6,
      );
      const pgRatedMovie = Movie(
        id: 'pg_rated_movie',
        title: 'PG Rated Movie',
        ageRating: 'PG',
        synopsis: 'This is a PG rated movie synopsis.',
        screeningTime: 'Saturday at 5:00 PM',
        imagePath: 'assets/images/pg_rated_movie.jpg',
        price: 6,
      );
      const adultRatedMovie = Movie(
        id: 'adult_rated_movie',
        title: 'Adult Rated Movie',
        ageRating: '18',
        synopsis: 'This is an adult rated movie synopsis.',
        screeningTime: 'Saturday at 9:00 PM',
        imagePath: 'assets/images/adult_rated_movie.jpg',
        price: 6,
      );

      expect(uRatedMovie.isAdultOnly, false);
      expect(pgRatedMovie.isAdultOnly, false);
      expect(adultRatedMovie.isAdultOnly, true);
    });

  });
}