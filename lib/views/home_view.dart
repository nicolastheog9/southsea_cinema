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
  List<Movie> _movies = [];
  bool _loading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadMovies();
  }

  Future<void> _loadMovies() async {
    setState(() {
      _loading = true;
      _errorMessage = '';
    });

    try {
      final movies = await _movieRepository.loadMoviesFromAsset();
      if (!mounted) {
        return;
      }
      setState(() {
        _movies = movies;
        _loading = false;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        _errorMessage = 'Unable to load movies: $error';
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(appTitle),
      ),
      drawer: const NavDrawer(),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _errorMessage,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: cinemaFontWhite),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _loadMovies,
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                )
              : _movies.isEmpty
                  ? const Center(
                      child: Text(
                        'No movies are currently available.',
                        style: TextStyle(color: cinemaFontWhite),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _movies.length,
                      itemBuilder: (context, index) {
                        final movie = _movies[index];
                        return MovieCard(
                          movie: movie,
                          onBook: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute<void>(
                                builder: (context) =>
                                    MovieListing(movie: movie),
                              ),
                            );
                          },
                        );
                      },
                    ),
    );
  }
}
