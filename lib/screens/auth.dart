import 'dart:io';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:shipping_app/constants.dart';

import 'package:shipping_app/models/driver.dart';
import 'package:shipping_app/models/payloader.dart';

import 'package:shipping_app/screens/driver_credentials.dart';
import 'package:shipping_app/screens/payloader_credentials.dart';

final _firebase = FirebaseAuth.instance;
final _firestore = FirebaseFirestore.instance;

Future<String> getUserType() async {
  //determine the userType of logged in user
  final userData = await _firestore
      .collection('payloader')
      .doc(_firebase.currentUser!.uid)
      .get();

  if (userData.exists) {
    return 'Payloader';
  }

  return 'Driver';
}

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() {
    return _AuthScreenState();
  }
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();

  Payloader payloader = const Payloader(
    name: '',
    surname: '',
    phone: '',
    companyName: '',
    companyEmail: '',
  );

  Driver driver = Driver(
    name: '',
    surname: '',
    phone: '',
    expireDateOfLicence: '',
    driverLicence: File(''),
  );

  var _enteredEmail = '';
  var _enteredPassword = '';
  var _selectedUserType = '';
  var _isSelected = false;
  var _isLogin = true;
  var _isRegister = false;
  var _isAuthenticating = false;

  void _submit() async {
    final isValid = _formKey.currentState!.validate();

    if (!isValid) {
      //to prevent sending and executing invalid data
      return;
    }

    _formKey.currentState!.save();
    //thanks to save(), special function can be assigned to all TextFormFields. write function to onSaved parameter

    if (_selectedUserType == 'Payloader') {
      if (payloader.name == '' ||
          payloader.surname == '' ||
          payloader.phone == '' ||
          payloader.companyName == '' ||
          payloader.companyEmail == '') {
        //if the user tries to register without giving extra information
        setState(() {
          _isLogin = true;
          _isSelected = false;
        });
        return;
      }
    }

    if (_selectedUserType == 'Driver') {
      if (driver.name == '' ||
          driver.surname == '' ||
          driver.phone == '' ||
          driver.expireDateOfLicence == '' ||
          driver.driverLicence == File('')) {
        //if the user tries to register without giving extra information
        setState(() {
          _isLogin = true;
          _isSelected = false;
        });
        return;
      }
    }

    try {
      setState(() {
        _isAuthenticating = true;
        _isRegister = false;
      });
      if (_isLogin) {
        final userCredentials = await _firebase.signInWithEmailAndPassword(
            email: _enteredEmail, password: _enteredPassword);
      } else {
        final userCredentials = await _firebase.createUserWithEmailAndPassword(
            email: _enteredEmail, password: _enteredPassword);

        if (_selectedUserType == 'Payloader') {
          await FirebaseFirestore.instance
              .collection('payloader')
              .doc(_firebase.currentUser!.uid)
              .set({
            'userType': _selectedUserType,
            'userId': _firebase.currentUser!.uid,
            'email': _firebase.currentUser!.email!,
            'name': payloader.name,
            'surname': payloader.surname,
            'phone': payloader.phone,
            'companyName': payloader.companyName,
            'companyEmail': payloader.companyEmail,
          });
        }

        if (_selectedUserType == 'Driver') {
          final storageRef = FirebaseStorage.instance
              .ref()
              .child('driver_licence_images')
              .child('${userCredentials.user!.uid}.jpg');

          await storageRef.putFile(driver.driverLicence);

          final driverLicenceUrl = await storageRef.getDownloadURL();

          await FirebaseFirestore.instance
              .collection('driver')
              .doc(_firebase.currentUser!.uid)
              .set({
            'userType': _selectedUserType,
            'userId': _firebase.currentUser!.uid,
            'email': _firebase.currentUser!.email!,
            'name': driver.name,
            'surname': driver.surname,
            'phone': driver.phone,
            'expireDateOfLicence': driver.expireDateOfLicence,
            'driverLicence': driverLicenceUrl,
          });
        }
      }
    } on FirebaseAuthException catch (error) {
      //if (error.code == 'email-already-in-use') {}
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.message ?? 'Authentication failed.'),
        ),
        //snackbar appears at the bottom of the screen then disappears automatically
      );
      setState(() {
        _isAuthenticating = false;
        _isRegister = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    //this size provide us total height and width of our screen
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: size.height,
          width: double.infinity,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                top: 0,
                left: 0,
                child: Image.asset(
                  "assets/images/main_top.png",
                  width: size.width * 0.7,
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Image.asset(
                  "assets/images/main_bottom.png",
                  width: size.width * 0.6,
                ),
              ),
              SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (_isLogin || _isRegister)
                      Text(
                        _isLogin ? 'LOGIN' : 'SIGNUP',
                        style: const TextStyle(
                          color: secondaryColor,
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    if (_isLogin || _isRegister)
                      _isLogin
                          ? Image.asset(
                              "assets/images/shipApp_login.png",
                              height: size.height * 0.45,
                              width: size.width,
                            )
                          : Container(
                              margin: const EdgeInsets.symmetric(vertical: 60),
                              child: Image.asset(
                                "assets/images/shipApp_signup.png",
                                height: size.height * 0.2,
                                width: size.width,
                              ),
                            ),
                    if (_isLogin || _isRegister)
                      Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            emailAddressField(size),
                            passwordField(size),
                            if (_isAuthenticating)
                              const CircularProgressIndicator(),
                            if (!_isAuthenticating) loginSignupButton(size),
                            if (!_isAuthenticating) createAccountField(),
                          ],
                        ),
                      ),
                    if (!_isLogin && !_isSelected)
                      driverOrPayloaderSelection(context, size),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Column driverOrPayloaderSelection(BuildContext context, Size size) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          "assets/images/shipApp_selection.png",
          height: size.height * 0.5,
          width: size.width,
        ),
        driverUserButton(context, size),
        payloaderUserButton(context, size),
      ],
    );
  }

  Container payloaderUserButton(BuildContext context, Size size) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: SizedBox(
        width: size.width * 0.8,
        height: size.height * 0.06,
        child: ElevatedButton(
          onPressed: () {
            setState(() {
              _isSelected = true;
              _isRegister = true;
              _selectedUserType = 'Payloader';
            });

            _awaitReturnPayloaderValue(context);
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 5,
            ),
            shape: RoundedRectangleBorder(
              //to set border radius to button
              borderRadius: BorderRadius.circular(29),
            ),
            foregroundColor: Colors.black,
            backgroundColor: thirdColor,
          ),
          child: const Text(
            'Payloader',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }

  Container driverUserButton(BuildContext context, Size size) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: SizedBox(
        width: size.width * 0.8,
        height: size.height * 0.06,
        child: ElevatedButton(
          onPressed: () {
            setState(() {
              _isSelected = true;
              _isRegister = true;
              _selectedUserType = 'Driver';
            });

            _awaitReturnDriverValue(context);
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 5,
            ),
            shape: RoundedRectangleBorder(
              //to set border radius to button
              borderRadius: BorderRadius.circular(29),
            ),
            foregroundColor: Colors.black,
            backgroundColor: secondaryColor,
          ),
          child: const Text(
            'Driver',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }

  TextButton createAccountField() {
    return TextButton(
      onPressed: () {
        setState(() {
          _isLogin = !_isLogin;
          _isRegister = false;
          _isSelected = false;
        });
      },
      child: Text(
        _isLogin ? 'Create an account' : 'I already have an acoount',
        style: const TextStyle(
          color: primaryColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Container loginSignupButton(Size size) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: SizedBox(
        width: size.width * 0.8,
        height: size.height * 0.06,
        child: ElevatedButton(
          onPressed: _submit,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 5,
            ),
            shape: RoundedRectangleBorder(
              //to set border radius to button
              borderRadius: BorderRadius.circular(29),
            ),
            foregroundColor: Colors.black,
            backgroundColor: thirdColor,
          ),
          child: Text(
            _isLogin ? 'LOGIN' : 'SIGNUP',
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }

  Container passwordField(Size size) {
    return Container(
      width: size.width * 0.8,
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: primaryLightColor,
        borderRadius: BorderRadius.circular(29),
      ),
      child: TextFormField(
        decoration: const InputDecoration(
          icon: Icon(
            Icons.lock,
            color: primaryColor,
          ),
          suffixIcon: Icon(
            Icons.visibility,
            color: primaryColor,
          ),
          hintText: 'Password',
          border: InputBorder.none,
        ),
        enableSuggestions: false,
        obscureText: true,
        validator: (value) {
          if (value == null ||
              value.trim().isEmpty ||
              value.trim().length < 6) {
            return 'Password must be at least 6 characters long.';
          }

          return null;
        },
        onSaved: (value) {
          _enteredPassword = value!;
        },
      ),
    );
  }

  Container emailAddressField(Size size) {
    return Container(
      width: size.width * 0.8,
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: primaryLightColor,
        borderRadius: BorderRadius.circular(29),
      ),
      child: TextFormField(
        decoration: const InputDecoration(
          icon: Icon(
            Icons.person,
            color: primaryColor,
          ),
          hintText: 'Email Address',
          border: InputBorder.none,
        ),
        keyboardType: TextInputType.emailAddress,
        autocorrect: false,
        textCapitalization: TextCapitalization.none,
        validator: (value) {
          if (value == null || value.trim().isEmpty || !value.contains('@')) {
            return 'Please enter a valid email address';
          }

          return null;
        },
        onSaved: (value) {
          _enteredEmail = value!;
          //we know that value is not null because we validate it
        },
      ),
    );
  }

  void _awaitReturnPayloaderValue(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const PayloaderCredentials(),
      ),
    );

    setState(() {
      payloader = result;
    });
  }

  void _awaitReturnDriverValue(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const DriverCredentials(),
      ),
    );

    setState(() {
      driver = result;
    });
  }
}
