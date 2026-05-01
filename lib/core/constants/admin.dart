class AdminConstants {
  static const String email = 'adminHall@gmail.com';
  static const String password = '12345678';

  static bool isAdmin(String? email) {
    return email == AdminConstants.email;
  }

  const AdminConstants._();
}
