import 'package:southsea_cinema/models/movie.dart';

class MovieRepository {
  List<Movie> getMovies(){
    return [
      const Movie(
        id: 'how_to_train_your_dragon_2',
        title: 'How to Train Your Dragon 2',
        ageRating: 'PG',
        synopsis:'When Hiccup and Toothless discover an ice cave that is home to hundredsof new wild dragons and the mysterious Dragon Rider, the two friends find themselves at the center of a battle to protect the peace.',
        imagePath: 'assets/images/how_to_train_your_dragon_2.jpg',
      ),
      const Movie(
        id: "the_wild_robot",
        title: "The Wild Robot",
        ageRating: "PG",
        synopsis: "A robot named Roz finds herself stranded on a remote island after a shipwreck. As she learns to survive in the wilderness, Roz befriends the local animals and discovers the true meaning of life and community.",
        imagePath: "assets/images/the_wild_robot.jpg",
      ),
    ];
  }

}
