import 'dart:io';

class Driver {
  const Driver({
    required this.name,
    required this.surname,
    required this.phone,
    required this.expireDateOfLicence,
    required this.driverLicence,
  });

  final String name;
  final String surname;
  final String phone;
  final String expireDateOfLicence;
  final File driverLicence;
}
