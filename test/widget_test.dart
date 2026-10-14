import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:southsea_cinema/constants.dart';
import 'package:southsea_cinema/main.dart';
import 'package:southsea_cinema/views/movie_listing.dart';

void main() {
  testWidgets('Home screen displays its title, movies, and booking buttons',
      (WidgetTester tester) async {
    await tester.pumpWidget(const SouthseaCinemaApp());
    await tester.pumpAndSettle();

    expect(find.text(appTitle), findsOneWidget);
    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is RichText &&
            widget.text.toPlainText().contains('HOW TO TRAIN YOUR DRAGON 2'),
      ),
      findsOneWidget,
    );
    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is RichText &&
            widget.text.toPlainText().contains('THE WILD ROBOT'),
      ),
      findsOneWidget,
    );
    expect(find.text('BOOK NOW'), findsNWidgets(2));
    expect(find.byType(ListView), findsWidgets);
  });

  testWidgets('Booking a movie opens its listing page',
      (WidgetTester tester) async {
    await tester.pumpWidget(const SouthseaCinemaApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('BOOK NOW').first);
    await tester.pumpAndSettle();

    expect(find.byType(MovieListing), findsOneWidget);
    expect(find.text('HOW TO TRAIN YOUR DRAGON 2 (PG)'), findsOneWidget);
    expect(find.text('Thursday 22 Oct 2026, 18:00'), findsOneWidget);
  });
}
