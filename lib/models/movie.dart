class Movie {
  final String id;
  final String title;
  final String ageRating;
  final String synopsis;
  final String imagePath;

  const Movie ({
    required this.id,
    required this.title,
    required this.ageRating,
    required this.synopsis,
    required this.imagePath,
  });
}

const movie = Movie(
  id: 'how_to_train_your_dragon_2',
  title: 'How to Train Your Dragon 2',
  ageRating: 'PG',
  synopsis:'When Hiccup and Toothless discover an ice cave that is home to hundreds of new wild dragons and the mysterious Dragon Rider, the two friends find themselves at the center of a battle to protect the peace.',
  imagePath: 'assets/images/how_to_train_your_dragon_2.jpg',
);

const movie2 = Movie(
  id: "the_wild_robot",
  title: "The Wild Robot",
  ageRating: "PG",
  synopsis: "A robot named Roz finds herself stranded on a remote island after a shipwreck. As she learns to survive in the wilderness, Roz befriends the local animals and discovers the true meaning of life and community.",
  imagePath: "assets/images/the_wild_robot.jpg",
);