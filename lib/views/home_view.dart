import 'package:flutter/material.dart';
import 'package:southsea_cinema/constants.dart';
import 'package:southsea_cinema/models/movie.dart';
import 'package:southsea_cinema/repositories/movie_repository.dart';
import 'package:southsea_cinema/widgets/nav_drawer.dart';
import 'package:southsea_cinema/widgets/movie_card.dart';
import 'package:southsea_cinema/views/movie_listing.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final MovieRepository _movieRepository = MovieRepository();
  late Future<List<Movie>> _moviesFuture;

  @override
  void initState() {
    super.initState();
    _moviesFuture = _movieRepository.getMovies();
  }

  void _retryLoadingMovies() {
    setState(() {
      _moviesFuture = _movieRepository.loadMoviesFromAsset();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(appTitle),
      ),
      drawer: const NavDrawer(),
      body: FutureBuilder<List<Movie>>(
        future: _moviesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Unable to load movies: ${snapshot.error}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: cinemaFontWhite),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _retryLoadingMovies,
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }

          final movies = snapshot.data!;
          if (movies.isEmpty) {
            return const Center(
              child: Text(
                'No movies are currently available.',
                style: TextStyle(color: cinemaFontWhite),
              ),
            );
          }

          return ListView.builder(
            itemCount: movies.length,
            itemBuilder: (context, index) {
              final movie = movies[index];
              return MovieCard(
                movie: movie,
                onBook: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (context) => MovieListing(movie: movie),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
