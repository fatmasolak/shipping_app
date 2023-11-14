import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:shipping_app/constants.dart';
import 'package:shipping_app/enums/info_value.dart';

import 'package:shipping_app/widgets/create_app_bar.dart';
import 'package:shipping_app/widgets/user_image_picker.dart';

class UpdateInfoValue extends StatefulWidget {
  const UpdateInfoValue(
      {super.key,
      required this.userId,
      required this.value,
      required this.userType});

  final InfoValue value;
  final String userId;
  final String userType;

  @override
  State<UpdateInfoValue> createState() {
    return _UpdateInfoValueState();
  }
}

class _UpdateInfoValueState extends State<UpdateInfoValue> {
  final TextEditingController _controller = TextEditingController();

  var _isUpdated = false;
  var _pickedDate = '';
  var _pickedImagePath = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CreateAppBar(
        header: 'Update Ad',
        isShowing: false,
        color: primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Center(
          child: Form(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  if (widget.value == InfoValue.name) updateNameField(),
                  if (widget.value == InfoValue.surname) updateSurnameField(),
                  if (widget.value == InfoValue.phone) updatePhoneField(),
                  if (widget.value == InfoValue.companyName)
                    updateCompanyNameField(),
                  if (widget.value == InfoValue.companyEmail)
                    updateCompanyEmailField(),
                  if (widget.value == InfoValue.expireDateOfDriverLicence)
                    updateExpireDateOfLicence(context),
                  if (widget.value == InfoValue.driverLicence)
                    updateDriverLicence(),
                  const SizedBox(height: 20),
                  buttons(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Row buttons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        cancelButton(context),
        saveValueButton(context),
      ],
    );
  }

  ElevatedButton saveValueButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        String enteredValue = _controller.text;

        setState(() {
          _isUpdated = true;
        });

        if (widget.value == InfoValue.name) {
          if (widget.userType == 'payloader') {
            FirebaseFirestore.instance
                .collection('payloader')
                .doc(widget.userId)
                .update({'name': enteredValue});
          }

          if (widget.userType == 'driver') {
            FirebaseFirestore.instance
                .collection('driver')
                .doc(widget.userId)
                .update({'name': enteredValue});
          }
        }

        if (widget.value == InfoValue.surname) {
          if (widget.userType == 'payloader') {
            FirebaseFirestore.instance
                .collection('payloader')
                .doc(widget.userId)
                .update({'surname': enteredValue});
          }

          if (widget.userType == 'driver') {
            FirebaseFirestore.instance
                .collection('driver')
                .doc(widget.userId)
                .update({'surname': enteredValue});
          }
        }

        if (widget.value == InfoValue.phone) {
          if (int.tryParse(enteredValue) == null ||
              int.tryParse(enteredValue)! <= 0) {
            ScaffoldMessenger.of(context).clearSnackBars();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Please enter valid number'),
              ),
            );
            return;
          }

          if (widget.userType == 'payloader') {
            FirebaseFirestore.instance
                .collection('payloader')
                .doc(widget.userId)
                .update({'phone': enteredValue});
          }

          if (widget.userType == 'driver') {
            FirebaseFirestore.instance
                .collection('driver')
                .doc(widget.userId)
                .update({'phone': enteredValue});
          }
        }

        if (widget.value == InfoValue.companyName) {
          FirebaseFirestore.instance
              .collection('payloader')
              .doc(widget.userId)
              .update({'companyName': enteredValue});
        }

        if (widget.value == InfoValue.companyEmail) {
          if (enteredValue.trim().isEmpty || !enteredValue.contains('@')) {
            ScaffoldMessenger.of(context).clearSnackBars();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Please enter positive number'),
              ),
            );
            return;
          }

          FirebaseFirestore.instance
              .collection('payloader')
              .doc(widget.userId)
              .update({'companyEmail': enteredValue});
        }

        if (widget.value == InfoValue.expireDateOfDriverLicence) {
          FirebaseFirestore.instance
              .collection('driver')
              .doc(widget.userId)
              .update({'expireDateOfLicence': _pickedDate});
        }

        if (widget.value == InfoValue.driverLicence) {
          FirebaseFirestore.instance
              .collection('driver')
              .doc(widget.userId)
              .update({'driverLicence': _pickedImagePath});
        }

        Navigator.pop(context, _isUpdated);

        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Value is updated.'),
          ),
        );
      },
      child: const Text('Save Value'),
    );
  }

  TextButton cancelButton(BuildContext context) {
    return TextButton(
      onPressed: () {
        _isUpdated = false;
        Navigator.pop(context, _isUpdated);
      },
      child: const Text('Cancel'),
    );
  }

  TextFormField updateNameField() {
    return TextFormField(
      controller: _controller,
      style: const TextStyle(color: Color.fromARGB(255, 31, 40, 51)),
      decoration: const InputDecoration(
        labelStyle: TextStyle(
          color: Color.fromARGB(255, 31, 40, 51),
        ),
        labelText: 'Name',
      ),
    );
  }

  TextFormField updateSurnameField() {
    return TextFormField(
      controller: _controller,
      style: const TextStyle(color: Color.fromARGB(255, 31, 40, 51)),
      decoration: const InputDecoration(
        labelStyle: TextStyle(
          color: Color.fromARGB(255, 31, 40, 51),
        ),
        labelText: 'Surname',
      ),
    );
  }

  TextFormField updatePhoneField() {
    return TextFormField(
      controller: _controller,
      keyboardType: TextInputType.number,
      style: const TextStyle(color: Color.fromARGB(255, 31, 40, 51)),
      decoration: const InputDecoration(
        labelStyle: TextStyle(
          color: Color.fromARGB(255, 31, 40, 51),
        ),
        labelText: 'Phone',
      ),
    );
  }

  TextFormField updateCompanyNameField() {
    return TextFormField(
      controller: _controller,
      style: const TextStyle(color: Color.fromARGB(255, 31, 40, 51)),
      decoration: const InputDecoration(
        labelStyle: TextStyle(
          color: Color.fromARGB(255, 31, 40, 51),
        ),
        labelText: 'Company Name',
      ),
    );
  }

  TextFormField updateCompanyEmailField() {
    return TextFormField(
      controller: _controller,
      keyboardType: TextInputType.emailAddress,
      style: const TextStyle(color: Color.fromARGB(255, 31, 40, 51)),
      decoration: const InputDecoration(
        labelStyle: TextStyle(
          color: Color.fromARGB(255, 31, 40, 51),
        ),
        labelText: 'Company Email',
      ),
    );
  }

  Column updateExpireDateOfLicence(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.only(right: 20),
          child: Text(
            'Expire Date Of Licence',
            style: TextStyle(
              color: Color.fromARGB(255, 31, 40, 51),
              fontSize: 13.5,
            ),
          ),
        ),
        const SizedBox(height: 5),
        Row(
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
              child: Text(
                _pickedDate == '' ? 'Pick Date' : 'Picked Date:',
                style: TextStyle(
                  color: _pickedDate == ''
                      ? const Color.fromARGB(255, 102, 252, 241)
                      : const Color.fromARGB(255, 31, 40, 51),
                  fontSize: 13,
                ),
              ),
            ),
            SizedBox(
              width: 80,
              child: Text(
                _pickedDate,
                style: const TextStyle(
                  fontSize: 13,
                  color: Color.fromARGB(255, 31, 40, 51),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  UserImagePicker updateDriverLicence() {
    return UserImagePicker(
      onPickImage: (pickedImage) async {
        await FirebaseStorage.instance
            .ref()
            .child('driver_licence_images')
            .child('${widget.userId}.jpg')
            .putFile(File(pickedImage.path));

        _pickedImagePath = await FirebaseStorage.instance
            .ref()
            .child('driver_licence_images')
            .child('${widget.userId}.jpg')
            .getDownloadURL();
      },
    );
  }
}
