class UserSettings {
  final String address;
  final String emailAddress;
  final String patronNumber;
  final bool receiveNewsByEmail;

  const UserSettings({
    required this.address,
    required this.emailAddress,
    required this.patronNumber,
    required this.receiveNewsByEmail,
  });
}
