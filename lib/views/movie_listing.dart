import 'package:flutter/material.dart';
import 'package:southsea_cinema/constants.dart';
import 'package:southsea_cinema/models/movie.dart';
import 'package:southsea_cinema/widgets/nav_drawer.dart';

class MovieListing extends StatefulWidget {
  final Movie movie;

  const MovieListing({super.key, required this.movie});

  @override
  State<MovieListing> createState() => _MovieListingState();
}

class _MovieListingState extends State<MovieListing> {
  int _selectedTickets = 0;
  bool _showBookingMessage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(appTitle, style: cinemaHeaderStyle),
        centerTitle: true,
        backgroundColor: cinemaSurface,
        iconTheme: const IconThemeData(color: cinemaBrand),
        elevation: 0,
      ),
      drawer: const NavDrawer(),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth > 600;
          final posterWidth = isWide ? 188.0 : 150.0;

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: isWide ? 24 : 16,
              vertical: 24,
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 720),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(isWide ? 30 : 20),
                  color: cinemaSurface,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${widget.movie.title.toUpperCase()} '
                        '(${widget.movie.ageRating})',
                        style: TextStyle(
                          color: cinemaFontWhite,
                          fontSize: isWide ? 30 : 25,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Image.asset(
                        widget.movie.imagePath,
                        width: posterWidth,
                        height: posterWidth * 1.5,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(height: 22),
                      const Text(
                        'Southsea Cinema Room',
                        style: TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        widget.movie.screeningTime,
                        style: const TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        widget.movie.synopsis,
                        style: const TextStyle(fontSize: 18, height: 1.4),
                      ),
                      const SizedBox(height: 28),
                      Row(
                        children: [
                          const Expanded(
                            child: Text(
                              'Tickets (£6.00 each)',
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                          DropdownMenu<int>(
                            width: isWide ? 220 : 120,
                            initialSelection: _selectedTickets,
                            textStyle: const TextStyle(
                              color: cinemaFontWhite,
                              fontSize: 18,
                            ),
                            inputDecorationTheme: const InputDecorationTheme(
                              border: OutlineInputBorder(),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: cinemaFontMuted),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: cinemaBrand),
                              ),
                            ),
                            onSelected: (int? value) {
                              if (value != null) {
                                setState(() {
                                  _selectedTickets = value;
                                  _showBookingMessage = false;
                                });
                              }
                            },
                            dropdownMenuEntries: List.generate(
                              6,
                              (quantity) => DropdownMenuEntry(
                                value: quantity,
                                label: '$quantity',
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 28),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _showBookingMessage = true;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: cinemaBrand,
                          foregroundColor: cinemaFontWhite,
                          minimumSize: const Size(236, 60),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,
                          ),
                        ),
                        child: const Text(
                          'Add to order',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      if (_showBookingMessage)
                        Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: Text(
                            '$_selectedTickets tickets have been added to your order',
                            style: const TextStyle(
                              color: cinemaBrandLight,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
