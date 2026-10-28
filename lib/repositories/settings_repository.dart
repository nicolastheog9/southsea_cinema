import 'package:southsea_cinema/models/user_settings.dart';

class SettingsRepository {
  SettingsRepository._internal();

  static final SettingsRepository instance = SettingsRepository._internal();

  static const UserSettings defaultSettings = UserSettings(
    address: '42 Example Street,\nPortsmouth\nPO1 1AA',
    emailAddress: 'alex@example.com',
    patronNumber: '1234',
    receiveNewsByEmail: true,
  );

  UserSettings _settings = defaultSettings;

  UserSettings get settings => _settings;

  void update(UserSettings settings) {
    _settings = settings;
  }
}
