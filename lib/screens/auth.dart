import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shipping_app/models/payloader.dart';
import 'package:shipping_app/screens/payloader_credentials.dart';

final _firebase = FirebaseAuth.instance;

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

        await FirebaseFirestore.instance
            .collection('payloader')
            .doc(_firebase.currentUser!.uid)
            .set({
          'userId': _firebase.currentUser!.uid,
          'email': _firebase.currentUser!.email!,
          'name': payloader.name,
          'surname': payloader.surname,
          'phone': payloader.phone,
          'companyName': payloader.companyName,
          'companyEmail': payloader.companyEmail,
        });
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
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isSelected && _selectedUserType == 'Payloader' && !_isRegister) {}
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 31, 40, 51),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_isLogin || _isRegister)
                Card(
                  margin: const EdgeInsets.all(20),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'Email Address',
                              ),
                              keyboardType: TextInputType.emailAddress,
                              autocorrect: false,
                              textCapitalization: TextCapitalization.none,
                              validator: (value) {
                                if (value == null ||
                                    value.trim().isEmpty ||
                                    !value.contains('@')) {
                                  return 'Please enter a valid email address';
                                }

                                return null;
                              },
                              onSaved: (value) {
                                _enteredEmail = value!;
                                //we know that value is not null because we validate it
                              },
                            ),
                            const SizedBox(height: 12),
                            TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'Password',
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
                            const SizedBox(height: 20),
                            if (_isAuthenticating)
                              const CircularProgressIndicator(),
                            if (!_isAuthenticating)
                              ElevatedButton(
                                onPressed: _submit,
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.black,
                                  backgroundColor:
                                      const Color.fromARGB(255, 102, 252, 241),
                                ),
                                child: Text(_isLogin ? 'Login' : 'Signup'),
                              ),
                            const SizedBox(height: 12),
                            if (!_isAuthenticating)
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    _isLogin = !_isLogin;
                                    _isRegister = false;
                                    _isSelected = false;
                                  });
                                },
                                child: Text(_isLogin
                                    ? 'Create an account'
                                    : 'I already have an acoount'),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              if (!_isLogin && !_isSelected)
                Container(
                  width: 300,
                  height: 200,
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(150, 11, 12, 16),
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 30,
                      bottom: 30,
                      left: 10,
                      right: 10,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _isSelected = true;
                              _isRegister = true;
                              _selectedUserType = 'Driver';
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.transparent,
                            side: const BorderSide(
                                color: Color.fromARGB(255, 102, 252, 241),
                                width: 2),
                          ),
                          child: const Text('Driver'),
                        ),
                        const SizedBox(height: 40),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _isSelected = true;
                              _isRegister = true;
                              _selectedUserType = 'Payloader';
                            });

                            _awaitReturnValue(context);
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.transparent,
                            side: const BorderSide(
                                color: Color.fromARGB(255, 102, 252, 241),
                                width: 2),
                          ),
                          child: const Text('Payloader'),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _awaitReturnValue(BuildContext context) async {
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
}
