import 'package:flutter/material.dart';
import 'package:southsea_cinema/constants.dart';
import 'package:southsea_cinema/widgets/nav_drawer.dart';

class MovieListing extends StatelessWidget {
  const MovieListing({super.key});

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
  padding: const EdgeInsets.all(16),
  decoration: BoxDecoration(
    border: Border.all(
      color: const Color.fromARGB(255, 65, 216, 236),
      width: 2,
    ),
    borderRadius: BorderRadius.circular(10),
  ),
  child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(
        'The Godfather',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      Text(
        'The aging patriarch of an organized crime dynasty transfers control of his empire to his reluctant son.',
      ),
    ],
  ),
),
    );
  } 
}

