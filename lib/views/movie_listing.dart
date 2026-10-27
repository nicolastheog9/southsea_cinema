import 'package:flutter/material.dart';
import 'package:southsea_cinema/constants.dart';
import 'package:southsea_cinema/models/basket_item.dart';
import 'package:southsea_cinema/models/movie.dart';
import 'package:southsea_cinema/repositories/basket_repository.dart';
import 'package:southsea_cinema/widgets/nav_drawer.dart';
import 'package:southsea_cinema/widgets/primary_button.dart';

class MovieListing extends StatefulWidget {
  final Movie movie;

  const MovieListing({super.key, required this.movie});

  @override
  State<MovieListing> createState() => _MovieListingState();
}

class _MovieListingState extends State<MovieListing> {
  int _selectedTickets = 0;
  String? _bookingMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: 'Back',
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(appTitle),
        centerTitle: true,
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
                      const SizedBox(height: 8),
                      Text(
                        'Ticket price: ${widget.movie.formattedPrice}',
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
                          Expanded(
                            child: Text(
                              'Tickets (${widget.movie.formattedPrice} each)',
                              style: const TextStyle(fontSize: 18),
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
                                  _bookingMessage = null;
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
                      PrimaryButton(
                        label: 'Add to order',
                        onPressed: () {
                          setState(() {
                            if (_selectedTickets == 0) {
                              _bookingMessage =
                                  'Select at least one ticket to add.';
                            } else {
                              BasketRepository.instance.addItem(
                                BasketItem(
                                  movie: widget.movie,
                                  quantity: _selectedTickets,
                                ),
                              );
                              _bookingMessage =
                                  '$_selectedTickets tickets have been added to your order';
                            }
                          });
                        },
                        minimumSize: const Size(236, 60),
                        textStyle: const TextStyle(fontSize: 20),
                      ),
                      if (_bookingMessage != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: Text(
                            _bookingMessage!,
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
