import 'package:flutter/material.dart';
import 'package:southsea_cinema/constants.dart';
import 'package:southsea_cinema/models/movie.dart';
import 'package:southsea_cinema/widgets/primary_button.dart';

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
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 12, 8, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              style: const TextStyle(
                color: cinemaBrand,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              children: [
                TextSpan(text: movie.title.toUpperCase()),
                TextSpan(
                  text: ' (${movie.ageRating})',
                  style: const TextStyle(
                    color: cinemaFontMuted,
                    fontSize: 11,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                movie.imagePath,
                width: 66,
                height: 100,
                fit: BoxFit.cover,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  movie.synopsis,
                  style: const TextStyle(color: cinemaFontWhite),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'BOOK TICKETS',
            style: TextStyle(color: cinemaFontWhite, fontSize: 12),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Text(
                  movie.screeningTime,
                  style: const TextStyle(color: cinemaFontWhite),
                ),
              ),
              PrimaryButton(
                label: 'BOOK NOW',
                onPressed: onBook,
                minimumSize: const Size(96, 36),
                padding: const EdgeInsets.symmetric(horizontal: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
