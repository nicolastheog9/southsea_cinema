import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:southsea_cinema/main.dart';

void main() {
  testWidgets('Home displays repository movies with booking buttons',
      (WidgetTester tester) async {
    await tester.pumpWidget(const SouthseaCinemaApp());

    expect(find.text('How to Train Your Dragon 2'), findsOneWidget);
    expect(find.text('The Wild Robot'), findsOneWidget);
    expect(find.text('BOOK NOW'), findsNWidgets(2));
    expect(find.byType(ListView), findsWidgets);
  });
}
