import 'package:flutter/material.dart';
import 'package:southsea_cinema/widgets/nav_drawer.dart';

class BasketView extends StatelessWidget {
  const BasketView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Basket')),
      drawer: const NavDrawer(),
      body: const Center(
        child: Text('Basket'),
      ),
    );
  }
}
