import 'package:flutter/material.dart';
import 'package:southsea_cinema/constants.dart';
import 'package:southsea_cinema/models/movie.dart';

class MovieCard extends StatelessWidget {
  final Movie movie;
  final VoidCallback onBook;

  const MovieCard({
    super.key,
    required this.movie,
    required this.onBook,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: cinemaSurface,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              movie.imagePath,
              width: 100,
              height: 150,
              fit: BoxFit.cover,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(movie.title, style: cinemaHeaderStyle),
                  const SizedBox(height: 8),

                  Text(
                    'Age Rating: ${movie.ageRating}',
                    style: const TextStyle(color: cinemaBrandLight),
                  ),
                  const SizedBox(height: 8),

                  Text(
                    movie.synopsis,
                    style: const TextStyle(color: cinemaFontMuted),
                  ),
                  const SizedBox(height: 8),
                  
                  Text(
                    'Screening Time: ${movie.screeningTime}',
                    style: const TextStyle(color: cinemaFontWhite),
                  ),
                  const SizedBox(height: 8),

                  ElevatedButton(
                    onPressed: onBook,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: cinemaBrand,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Book Now'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
