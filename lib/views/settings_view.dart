import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:southsea_cinema/constants.dart';
import 'package:southsea_cinema/models/user_settings.dart';
import 'package:southsea_cinema/repositories/settings_repository.dart';
import 'package:southsea_cinema/widgets/nav_drawer.dart';
import 'package:southsea_cinema/widgets/primary_button.dart';

const String prefAddress = 'cinema_profile_address';
const String prefEmail = 'cinema_profile_email';
const String prefPatronNumber = 'cinema_profile_patron_number';
const String prefEmailNews = 'cinema_profile_email_news';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  final _formKey = GlobalKey<FormState>();
  final _settingsRepository = SettingsRepository.instance;
  late final TextEditingController _addressController;
  late final TextEditingController _emailController;
  late final TextEditingController _patronNumberController;
  bool _receiveNewsByEmail = false;
  bool _isLoading = true;
  bool _isSaving = false;
  String? _loadError;

  @override
  void initState() {
    super.initState();
    _addressController = TextEditingController();
    _emailController = TextEditingController();
    _patronNumberController = TextEditingController();
    _loadSettings();
  }

  @override
  void dispose() {
    _addressController.dispose();
    _emailController.dispose();
    _patronNumberController.dispose();
    super.dispose();
  }

  Future<void> _loadSettings() async {
    try {
      final SharedPreferencesAsync prefs = SharedPreferencesAsync();
      final String? savedAddress = await prefs.getString(prefAddress);
      final String? savedEmail = await prefs.getString(prefEmail);
      final String? savedPatronNumber = await prefs.getString(prefPatronNumber);
      final bool? savedEmailNews = await prefs.getBool(prefEmailNews);
      final defaults = _settingsRepository.settings;
      final settings = UserSettings(
        address: savedAddress ?? defaults.address,
        emailAddress: savedEmail ?? defaults.emailAddress,
        patronNumber: savedPatronNumber ?? defaults.patronNumber,
        receiveNewsByEmail: savedEmailNews ?? defaults.receiveNewsByEmail,
      );
      _settingsRepository.update(settings);
      if (!mounted) {
        return;
      }
      setState(() {
        _addressController.text = settings.address;
        _emailController.text = settings.emailAddress;
        _patronNumberController.text = settings.patronNumber;
        _receiveNewsByEmail = settings.receiveNewsByEmail;
        _isLoading = false;
        _loadError = null;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        _loadError = 'Unable to load saved profile: $error';
        _isLoading = false;
      });
    }
  }

  void _retryLoadingSettings() {
    setState(() {
      _isLoading = true;
      _loadError = null;
    });
    _loadSettings();
  }

  void _cancelChanges() {
    final settings = _settingsRepository.settings;
    _formKey.currentState?.reset();
    _addressController.text = settings.address;
    _emailController.text = settings.emailAddress;
    _patronNumberController.text = settings.patronNumber;
    setState(() {
      _receiveNewsByEmail = settings.receiveNewsByEmail;
    });
    FocusScope.of(context).unfocus();
  }

  Future<void> _saveSettings() async {
    if (_isSaving || !_formKey.currentState!.validate()) return;

    final settings = UserSettings(
      address: _addressController.text.trim(),
      emailAddress: _emailController.text.trim(),
      patronNumber: _patronNumberController.text.trim(),
      receiveNewsByEmail: _receiveNewsByEmail,
    );
    setState(() {
      _isSaving = true;
    });

    try {
      final SharedPreferencesAsync prefs = SharedPreferencesAsync();
      await prefs.setString(prefAddress, settings.address);
      await prefs.setString(prefEmail, settings.emailAddress);
      await prefs.setString(prefPatronNumber, settings.patronNumber);
      await prefs.setBool(prefEmailNews, settings.receiveNewsByEmail);
      _settingsRepository.update(settings);
    } catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        _isSaving = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Unable to save settings: $error')),
      );
      return;
    }

    if (!mounted) {
      return;
    }
    setState(() {
      _isSaving = false;
    });
    FocusScope.of(context).unfocus();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Settings saved.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(appTitle)),
      drawer: const NavDrawer(),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _loadError != null
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _loadError!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: cinemaFontWhite),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: _retryLoadingSettings,
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    ),
                  )
                : Form(
                    key: _formKey,
                    child: ListView(
                      padding: const EdgeInsets.all(20),
                      children: [
                        const Text(
                          'My Settings',
                          style: TextStyle(
                            color: cinemaFontWhite,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 28),
                        _buildFieldLabel('Address'),
                        TextFormField(
                          key: const Key('settings-address'),
                          controller: _addressController,
                          minLines: 3,
                          maxLines: 4,
                          textCapitalization: TextCapitalization.sentences,
                          decoration: _fieldDecoration().copyWith(
                            suffixIcon: IconButton(
                              tooltip: 'Clear address',
                              onPressed: () => _addressController.clear(),
                              icon: const Icon(Icons.close,
                                  color: cinemaFontMuted),
                            ),
                          ),
                          validator: (value) =>
                              _requiredValidator(value, 'Address'),
                        ),
                        const SizedBox(height: 22),
                        _buildFieldLabel('Email Address'),
                        TextFormField(
                          key: const Key('settings-email'),
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: _fieldDecoration(),
                          validator: (value) {
                            final requiredError =
                                _requiredValidator(value, 'Email');
                            if (requiredError != null) return requiredError;
                            final email = value!.trim();
                            if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$')
                                .hasMatch(email)) {
                              return 'Enter a valid email address.';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 22),
                        _buildFieldLabel('Patron Number'),
                        TextFormField(
                          key: const Key('settings-patron-number'),
                          controller: _patronNumberController,
                          keyboardType: TextInputType.number,
                          decoration: _fieldDecoration(),
                          validator: (value) =>
                              _requiredValidator(value, 'Patron number'),
                        ),
                        const SizedBox(height: 26),
                        _buildFieldLabel('Preferences'),
                        SwitchListTile(
                          key: const Key('settings-email-preference'),
                          contentPadding: EdgeInsets.zero,
                          title: const Text(
                            'Receive news by email',
                            style: TextStyle(color: cinemaFontWhite),
                          ),
                          value: _receiveNewsByEmail,
                          activeThumbColor: cinemaBrand,
                          onChanged: (value) {
                            setState(() {
                              _receiveNewsByEmail = value;
                            });
                          },
                        ),
                        const SizedBox(height: 24),
                        Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: [
                            TextButton(
                              onPressed: _cancelChanges,
                              style: TextButton.styleFrom(
                                foregroundColor: cinemaFontWhite,
                                backgroundColor: cinemaSurface,
                                minimumSize: const Size(104, 44),
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.zero,
                                ),
                              ),
                              child: const Text('CANCEL'),
                            ),
                            PrimaryButton(
                              label: _isSaving ? 'SAVING...' : 'SAVE SETTINGS',
                              onPressed: _saveSettings,
                              minimumSize: const Size(170, 44),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 14),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
      ),
    );
  }

  Widget _buildFieldLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        label,
        style: const TextStyle(
          color: cinemaFontMuted,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  InputDecoration _fieldDecoration() {
    return const InputDecoration(
      filled: true,
      fillColor: cinemaSurface,
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.zero,
        borderSide: BorderSide(color: cinemaFontMuted),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.zero,
        borderSide: BorderSide(color: cinemaFontMuted),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.zero,
        borderSide: BorderSide(color: cinemaBrand),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.zero,
        borderSide: BorderSide(color: Colors.redAccent),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.zero,
        borderSide: BorderSide(color: Colors.redAccent),
      ),
    );
  }

  String? _requiredValidator(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required.';
    }
    return null;
  }
}
