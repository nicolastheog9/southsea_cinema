import 'package:flutter/material.dart';
import 'package:southsea_cinema/constants.dart';
import 'package:southsea_cinema/views/home_view.dart';

void main() {
  runApp(const SouthseaCinemaApp());
}

class SouthseaCinemaApp extends StatelessWidget {
  const SouthseaCinemaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appTitle,
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor: cinemaBrand,
          brightness: Brightness.dark,
          primary: cinemaBrand,
          surface: cinemaSurface,
        ),
        scaffoldBackgroundColor: cinemaBackground,
        appBarTheme: const AppBarTheme(
          backgroundColor: cinemaSurface,
          foregroundColor: cinemaFontWhite,
          elevation: 0,
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (BuildContext context) {
          return const HomeView();
        },
      },
    );
  }
}
