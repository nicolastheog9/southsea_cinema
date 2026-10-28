class Movie {
  final String id;
  final String title;
  final String ageRating;
  final String synopsis;
  final String screeningTime;
  final String imagePath;
  final double price;

  const Movie({
    required this.id,
    required this.title,
    required this.ageRating,
    required this.synopsis,
    required this.screeningTime,
    required this.imagePath,
    required this.price,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'] as String,
      title: json['title'] as String,
      ageRating: json['ageRating'] as String,
      synopsis: json['synopsis'] as String,
      screeningTime: json['screeningTime'] as String,
      imagePath: json['imagePath'] as String,
      price: (json['price'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'ageRating': ageRating,
      'synopsis': synopsis,
      'screeningTime': screeningTime,
      'imagePath': imagePath,
      'price': price,
    };
  }

  String get formattedPrice => '£${price.toStringAsFixed(2)}';

  bool get isChildFriendly {
    final normalisedRating = ageRating.toUpperCase();
    return normalisedRating == 'U' || normalisedRating == 'PG';
  }

  bool get isAdultOnly {
    return ageRating.toUpperCase() == '18';
  }
}
