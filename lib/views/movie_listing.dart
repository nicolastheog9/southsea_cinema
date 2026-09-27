import 'package:flutter/material.dart';
import 'package:southsea_cinema/constants.dart';
import 'package:southsea_cinema/widgets/nav_drawer.dart';

class MovieListing extends StatefulWidget { //changed it to stateufl to change the price based on dropdown selection
  const MovieListing({super.key});

  @override
  State<MovieListing> createState() => _MovieListingState();
}

class _MovieListingState extends State<MovieListing> {
  int _totalPrice = 7;
  int _selectedTickets = 1;
  bool _showBookingMessage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(appTitle, style: cinemaHeaderStyle),
        backgroundColor: cinemaSurface,
        iconTheme: const IconThemeData(color: cinemaBrand),
        elevation: 0,
      ),
      drawer: const NavDrawer(),
      body: Container(
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(
            color: const Color.fromARGB(255, 65, 216, 236),
            width: 2,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'The Godfather',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            const Text(
              'The aging patriarch of an organized crime dynasty transfers control of his empire to his reluctant son.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                DropdownMenu<int>(
                  initialSelection: _totalPrice,
                  onSelected: (int? value) {
                    if (value != null) {
                      setState(() {
                        _totalPrice = value;
                        _selectedTickets = value ~/ 7;
                        _showBookingMessage = false;
                      });
                    }
                  },
                  dropdownMenuEntries: const [
                    DropdownMenuEntry(value: 7, label: '1 Ticket'),
                    DropdownMenuEntry(value: 14, label: '2 Tickets'),
                    DropdownMenuEntry(value: 21, label: '3 Tickets'),
                    DropdownMenuEntry(value: 28, label: '4 Tickets'),
                    DropdownMenuEntry(value: 35, label: '5 Tickets'),
                  ],
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _showBookingMessage = true;
                    });
                  },
                  child: const Text('Book Now'),
                ),
              ],
            ),
            if (_showBookingMessage)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(
                  '$_selectedTickets tickets have been added to your booking ',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

