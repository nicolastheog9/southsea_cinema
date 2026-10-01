import 'package:flutter/material.dart';
import 'package:southsea_cinema/constants.dart';
import 'package:southsea_cinema/widgets/nav_drawer.dart';

class MovieListing extends StatefulWidget {
  //changed it to stateufl to change the price based on dropdown selection
  const MovieListing({super.key});

  @override
  State<MovieListing> createState() => _MovieListingState();
}

class _MovieListingState extends State<MovieListing> {
  int _totalPrice = 7;
  int _selectedTickets = 0;
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




      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth > 600;

          return Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isWide ? 24 : 16,
              vertical: 16,
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 720),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'HOW TO TRAIN YOUR DRAGON 2',
                      style: TextStyle(fontSize: isWide ? 30 : 25),
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      'Southsea Cinema Room',
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 15),
                    const Text('Thursday 22 Oct 2026, 18:00 - Ends at 19:30'),
                    const SizedBox(height: 30),
                    const Text(
                        'Please Note that Discounts/ Membership Benefits will be applied once you have selected your tickets'),
                    const SizedBox(height: 15),
                    const Text('Select Quantities (Up to 5 in total)'),
                    const SizedBox(height: 30),
                    const Text(
                      'Tickets',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DropdownMenu<int>(
                          width: 100,
                          initialSelection: _totalPrice,
                          menuStyle: MenuStyle(
                            backgroundColor: WidgetStateProperty.all(Colors.white),
                          ),
                          textStyle: const TextStyle(color: Colors.black),
                          inputDecorationTheme: const InputDecorationTheme(
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(),
                            enabledBorder: OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(),
                          ),
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
                            DropdownMenuEntry(value: 0, label: '0'),
                            DropdownMenuEntry(value: 7, label: '1 '),
                            DropdownMenuEntry(value: 14, label: '2 '),
                            DropdownMenuEntry(value: 21, label: '3 '),
                            DropdownMenuEntry(value: 28, label: '4 '),
                            DropdownMenuEntry(value: 35, label: '5 '),
                          ],
                        ),
                        const SizedBox(height: 10),
                        const Text('Adult (£7.50)'),
                      ],
                    ),
                    const SizedBox(height: 15),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _showBookingMessage = true;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(100, 30),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                      ),
                      child: const Text('ADD TO ORDER'),
                    ),
                    if (_showBookingMessage)
                      Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: Text(
                          '$_selectedTickets tickets have been added to your order',
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
            ),
          );
        },
      ),
    );
  }
}
