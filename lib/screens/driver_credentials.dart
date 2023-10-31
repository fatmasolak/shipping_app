import 'dart:io';
import 'package:flutter/material.dart';

import 'package:shipping_app/models/driver.dart';
import 'package:shipping_app/widgets/user_image_picker.dart';

class DriverCredentials extends StatefulWidget {
  const DriverCredentials({super.key});

  @override
  State<DriverCredentials> createState() {
    return _DriverCredentialsState();
  }
}

class _DriverCredentialsState extends State<DriverCredentials> {
  final _formKey = GlobalKey<FormState>();

  var _enteredName = '';
  var _enteredSurname = '';
  var _enteredPhone = '';
  var _expireDateOfLicence = '';
  File _driverLicenceImage = File('');
  Driver driver = Driver(
    name: '',
    surname: '',
    phone: '',
    expireDateOfLicence: '',
    driverLicence: File(''),
  );

  void _save() async {
    final isValid = _formKey.currentState!.validate();

    if (!isValid) {
      return;
    }

    _formKey.currentState!.save();

    setState(() {
      driver = Driver(
        name: _enteredName,
        surname: _enteredSurname,
        phone: _enteredPhone,
        expireDateOfLicence: _expireDateOfLicence,
        driverLicence: _driverLicenceImage,
      );
    });

    Navigator.pop(context, driver);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 31, 40, 51),
      appBar: AppBar(
        title: const Text('Driver Credentials'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFormField(
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            labelStyle: TextStyle(
                                color: Color.fromARGB(255, 225, 226, 228)),
                            labelText: 'Name',
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter your name';
                            }

                            return null;
                          },
                          onSaved: (value) {
                            _enteredName = value!;
                            //we know that value is not null because we validate it
                          },
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            labelStyle: TextStyle(
                                color: Color.fromARGB(255, 225, 226, 228)),
                            labelText: 'Surname',
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter your surname';
                            }

                            return null;
                          },
                          onSaved: (value) {
                            _enteredSurname = value!;
                          },
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            labelStyle: TextStyle(
                                color: Color.fromARGB(255, 225, 226, 228)),
                            labelText: 'Phone',
                          ),
                          keyboardType: TextInputType.phone,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter your phone number';
                            }

                            return null;
                          },
                          onSaved: (value) {
                            _enteredPhone = value!;
                          },
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            labelStyle: TextStyle(
                                color: Color.fromARGB(255, 225, 226, 228)),
                            labelText: 'Expire Date Of Driver Licence',
                          ),
                          keyboardType: TextInputType.datetime,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter your expire date of driver licence';
                            }

                            return null;
                          },
                          onSaved: (value) {
                            _expireDateOfLicence = value!;
                          },
                        ),
                        const SizedBox(height: 20),
                        UserImagePicker(
                          onPickImage: (pickedImage) {
                            _driverLicenceImage = pickedImage;
                          },
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: _save,
                          style: ElevatedButton.styleFrom(
                            foregroundColor:
                                const Color.fromARGB(255, 31, 40, 51),
                            backgroundColor:
                                const Color.fromARGB(255, 102, 252, 241),
                          ),
                          child: const Text('Save'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
