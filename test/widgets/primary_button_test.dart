import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:southsea_cinema/widgets/primary_button.dart';

void main() {
  group('PrimaryButton', () {
    testWidgets('renders its label', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PrimaryButton(label: 'Book tickets', onPressed: () {}),
          ),
        ),
      );

      expect(find.text('Book tickets'), findsOneWidget);
    });

    testWidgets('invokes onPressed when tapped', (WidgetTester tester) async {
      var wasPressed = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PrimaryButton(
              label: 'Book tickets',
              onPressed: () => wasPressed = true,
            ),
          ),
        ),
      );

      await tester.tap(find.text('Book tickets'));
      await tester.pump();

      expect(wasPressed, isTrue);
    });
  });
}
