import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shipping_app/constants.dart';

import 'package:shipping_app/models/driver.dart';
import 'package:shipping_app/widgets/create_app_bar.dart';
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

  var _pickedDate = '';
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
      _expireDateOfLicence = _pickedDate;

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
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: const CreateAppBar(
          header: 'Driver Credentials', isShowing: false, color: primaryColor),
      body: Container(
        height: size.height,
        width: double.infinity,
        child: Stack(
          alignment: Alignment.center,
          children: [
            SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    driverNameField(size),
                    driverSurnameField(size),
                    driverPhoneField(size),
                    const SizedBox(height: 20),
                    expireDateOfLicenceField(context, size),
                    UserImagePicker(
                      onPickImage: (pickedImage) {
                        _driverLicenceImage = pickedImage;
                      },
                    ),
                    const SizedBox(height: 40),
                    saveButton(size),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container saveButton(Size size) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: SizedBox(
        width: size.width * 0.8,
        height: size.height * 0.06,
        child: ElevatedButton(
          onPressed: _save,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 5,
            ),
            foregroundColor: Colors.white,
            backgroundColor: primaryColor,
          ),
          child: const Text('Save'),
        ),
      ),
    );
  }

  Container expireDateOfLicenceField(BuildContext context, Size size) {
    return Container(
      width: size.width * 0.99,
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 5,
      ),
      child: Column(
        children: [
          const Text(
            'Expire Date of Driver Licence',
            textAlign: TextAlign.left,
            style: TextStyle(
              color: Colors.black,
              fontSize: 14.5,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 90,
              vertical: 5,
            ),
            child: Row(
              children: [
                TextButton(
                  onPressed: () {
                    showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2023),
                      lastDate: DateTime(2101),
                    ).then((selectedDate) {
                      if (selectedDate != null) {
                        setState(() {
                          _pickedDate =
                              "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}";
                        });
                      }
                    });
                  },
                  child: const Text(
                    'Pick Date',
                    style: TextStyle(
                      color: primaryColor,
                      fontSize: 13,
                    ),
                  ),
                ),
                SizedBox(
                  width: 100,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(
                      _pickedDate,
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Container driverPhoneField(Size size) {
    return Container(
      width: size.width * 0.99,
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 5,
      ),
      child: TextFormField(
        decoration: const InputDecoration(
          hintText: 'Phone',
          focusColor: primaryColor,
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
    );
  }

  Container driverSurnameField(Size size) {
    return Container(
      width: size.width * 0.99,
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 5,
      ),
      child: TextFormField(
        decoration: const InputDecoration(
          hintText: 'Surname',
          focusColor: primaryColor,
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
    );
  }

  Container driverNameField(Size size) {
    return Container(
      width: size.width * 0.99,
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 5,
      ),
      child: TextFormField(
        decoration: const InputDecoration(
          hintText: 'Name',
          focusColor: primaryColor,
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
    );
  }
}
