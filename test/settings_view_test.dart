import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:southsea_cinema/models/user_settings.dart';
import 'package:southsea_cinema/repositories/settings_repository.dart';
import 'package:southsea_cinema/views/settings_view.dart';

const _defaultSettings = UserSettings(
  address: '42 Example Street,\nPortsmouth\nPO1 1AA',
  emailAddress: 'alex@example.com',
  patronNumber: '1234',
  receiveNewsByEmail: true,
);

void main() {
  late SettingsRepository repository;

  setUp(() {
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.empty();
    repository = SettingsRepository.instance;
    repository.update(_defaultSettings);
  });

  testWidgets('shows editable profile fields with saved defaults',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: SettingsView()),
    );
    await tester.pumpAndSettle();

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
    expect(
      tester
          .widget<TextFormField>(
              find.byKey(const Key('settings-patron-number')))
          .controller!
          .text,
      _defaultSettings.patronNumber,
    );
    expect(
      tester
          .widget<SwitchListTile>(
            find.byKey(const Key('settings-email-preference')),
          )
          .value,
      _defaultSettings.receiveNewsByEmail,
    );
    await tester.drag(find.byType(ListView), const Offset(0, -600));
    await tester.pumpAndSettle();
    expect(find.text('SAVE SETTINGS'), findsOneWidget);
    expect(find.text('CANCEL'), findsOneWidget);
  });

  testWidgets('loads saved profile values when settings opens',
      (WidgetTester tester) async {
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.withData(<String, Object>{
      prefAddress: '12 Example Lane, Portsmouth',
      prefEmail: 'patron@example.com',
      prefPatronNumber: '2468',
      prefEmailNews: true,
    });

    await tester.pumpWidget(
      const MaterialApp(home: SettingsView()),
    );
    await tester.pumpAndSettle();

    expect(
      tester
          .widget<TextFormField>(find.byKey(const Key('settings-address')))
          .controller!
          .text,
      '12 Example Lane, Portsmouth',
    );
    expect(
      tester
          .widget<TextFormField>(find.byKey(const Key('settings-email')))
          .controller!
          .text,
      'patron@example.com',
    );
    expect(
      tester
          .widget<TextFormField>(
              find.byKey(const Key('settings-patron-number')))
          .controller!
          .text,
      '2468',
    );
    expect(
      tester
          .widget<SwitchListTile>(
            find.byKey(const Key('settings-email-preference')),
          )
          .value,
      isTrue,
    );
  });

  testWidgets('validates input, saves settings, and cancels unsaved edits',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: SettingsView()),
    );
    await tester.pumpAndSettle();

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
    final SharedPreferencesAsync preferences = SharedPreferencesAsync();
    expect(await preferences.getString(prefAddress), '42 Cinema Street');
    expect(await preferences.getString(prefEmail), 'patron@example.com');
    expect(await preferences.getString(prefPatronNumber), '5678');
    expect(await preferences.getBool(prefEmailNews), isFalse);

    await tester.pump(const Duration(seconds: 5));
    await tester.pumpWidget(const MaterialApp(home: SizedBox()));
    await tester.pumpAndSettle();
    await tester.pumpWidget(
      const MaterialApp(home: SettingsView()),
    );
    await tester.pumpAndSettle();

    expect(
      tester
          .widget<TextFormField>(find.byKey(const Key('settings-address')))
          .controller!
          .text,
      '42 Cinema Street',
    );
    expect(
      tester
          .widget<TextFormField>(find.byKey(const Key('settings-email')))
          .controller!
          .text,
      'patron@example.com',
    );
    expect(
      tester
          .widget<TextFormField>(
              find.byKey(const Key('settings-patron-number')))
          .controller!
          .text,
      '5678',
    );
    expect(
      tester
          .widget<SwitchListTile>(
            find.byKey(const Key('settings-email-preference')),
          )
          .value,
      isFalse,
    );

    await tester.enterText(
      find.byKey(const Key('settings-address')),
      'Unsaved address',
    );
    tester.testTextInput.hide();
    await tester.pumpAndSettle();
    await tester.drag(find.byType(ListView), const Offset(0, -600));
    await tester.pumpAndSettle();
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
