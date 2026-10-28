import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:southsea_cinema/models/user_settings.dart';
import 'package:southsea_cinema/repositories/settings_repository.dart';
import 'package:southsea_cinema/views/settings_view.dart';

const _defaultSettings = UserSettings(
  address: 'Buckingham Building,\nLion Terrace,\nPortsmouth\nPO1 3HE',
  emailAddress: 'alex@example.com',
  patronNumber: '1234',
  receiveNewsByEmail: true,
);

void main() {
  final repository = SettingsRepository.instance;

  setUp(() {
    repository.update(_defaultSettings);
  });

  testWidgets('shows editable profile fields with saved defaults',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: SettingsView()),
    );

    expect(find.text('My Settings'), findsOneWidget);
    expect(find.text('Address'), findsOneWidget);
    expect(find.text('Email Address'), findsOneWidget);
    expect(find.text('Patron Number'), findsOneWidget);
    expect(find.text('Preferences'), findsOneWidget);
    expect(find.text('Receive news by email'), findsOneWidget);
    expect(
      tester
          .widget<TextFormField>(find.byKey(const Key('settings-address')))
          .controller!
          .text,
      _defaultSettings.address,
    );
    expect(
      tester
          .widget<TextFormField>(find.byKey(const Key('settings-email')))
          .controller!
          .text,
      _defaultSettings.emailAddress,
    );
    await tester.drag(find.byType(ListView), const Offset(0, -600));
    await tester.pumpAndSettle();
    expect(find.text('SAVE SETTINGS'), findsOneWidget);
    expect(find.text('CANCEL'), findsOneWidget);
  });

  testWidgets('validates input, saves settings, and cancels unsaved edits',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: SettingsView()),
    );

    await tester.enterText(
      find.byKey(const Key('settings-email')),
      'invalid-email',
    );
    await tester.drag(find.byType(ListView), const Offset(0, -600));
    await tester.pumpAndSettle();
    await tester.tap(find.text('SAVE SETTINGS'));
    await tester.pumpAndSettle();

    expect(find.text('Enter a valid email address.'), findsOneWidget);
    expect(repository.settings.emailAddress, _defaultSettings.emailAddress);

    await tester.enterText(
      find.byKey(const Key('settings-address')),
      '42 Cinema Street',
    );
    await tester.enterText(
      find.byKey(const Key('settings-email')),
      'patron@example.com',
    );
    await tester.enterText(
      find.byKey(const Key('settings-patron-number')),
      '5678',
    );
    await tester.tap(find.byType(SwitchListTile));
    await tester.drag(find.byType(ListView), const Offset(0, -600));
    await tester.pumpAndSettle();
    await tester.tap(find.text('SAVE SETTINGS'));
    await tester.pumpAndSettle();

    expect(find.text('Settings saved.'), findsOneWidget);
    expect(repository.settings.address, '42 Cinema Street');
    expect(repository.settings.emailAddress, 'patron@example.com');
    expect(repository.settings.patronNumber, '5678');
    expect(repository.settings.receiveNewsByEmail, isFalse);

    await tester.pump(const Duration(seconds: 5));
    await tester.enterText(
      find.byKey(const Key('settings-address')),
      'Unsaved address',
    );
    tester.testTextInput.hide();
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('CANCEL'));
    await tester.tap(find.text('CANCEL'));
    await tester.pumpAndSettle();

    expect(
      tester
          .widget<TextFormField>(find.byKey(const Key('settings-address')))
          .controller!
          .text,
      '42 Cinema Street',
    );
  });
}
