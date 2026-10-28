import 'package:southsea_cinema/models/user_settings.dart';

class SettingsRepository {
  SettingsRepository._internal();

  static final SettingsRepository instance = SettingsRepository._internal();

  UserSettings _settings = const UserSettings(
    address: 'Buckingham Building,\nLion Terrace,\nPortsmouth\nPO1 3HE',
    emailAddress: 'alex@example.com',
    patronNumber: '1234',
    receiveNewsByEmail: true,
  );

  UserSettings get settings => _settings;

  void update(UserSettings settings) {
    _settings = settings;
  }
}
