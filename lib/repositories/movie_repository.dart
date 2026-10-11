import 'package:southsea_cinema/models/movie.dart';

class MovieRepository {
  List<Movie> getMovies() {
    return [
      const Movie(
        id: 'how_to_train_your_dragon_2',
        title: 'How to Train Your Dragon 2',
        ageRating: 'PG',
        synopsis:
            'When Hiccup and Toothless discover an ice cave that is home to hundredsof new wild dragons and the mysterious Dragon Rider, the two friends find themselves at the center of a battle to protect the peace.',
        screeningTime: 'Thursday 22 Oct 2026, 18:00',
        imagePath: 'assets/images/httyd2.jpg',
        price: 6.0,
      ),
      const Movie(
        id: 'the_wild_robot',
        title: 'The Wild Robot',
        ageRating: 'PG',
        synopsis:
            'A robot named Roz finds herself stranded on a remote island after a shipwreck. As she learns to survive in the wilderness, Roz befriends the local animals and discovers the true meaning of life and community.',
        screeningTime: 'Thursday 22 Oct 2026, 20:30',
        imagePath: 'assets/images/wild_robot.jpg',
        price: 6.0,
      ),
    ];
  }

  Movie? getMovieById(String id) {
    for (final movie in getMovies()) {
      if (movie.id == id) {
        return movie;
      }
    }
    return null;
  }

  List<Movie> getMoviesByAgeRating(String rating) {
    return getMovies()
        .where((movie) => movie.ageRating == rating)
        .toList();
  }

  List<Movie> getMoviesUnderPrice(double maxPrice) {
    return getMovies()
        .where((movie) => movie.price < maxPrice)
        .toList();
  }
}
