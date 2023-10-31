import 'package:flutter/material.dart';
import 'package:shipping_app/models/payloader.dart';

class PayloaderCredentials extends StatefulWidget {
  const PayloaderCredentials({
    super.key,
  });

  @override
  State<PayloaderCredentials> createState() {
    return _PayloaderCredentialsState();
  }
}

class _PayloaderCredentialsState extends State<PayloaderCredentials> {
  final _formKey = GlobalKey<FormState>();

  var _enteredName = '';
  var _enteredSurname = '';
  var _enteredPhone = '';
  var _enteredCompanyName = '';
  var _enteredCompanyEmail = '';
  Payloader payloader = const Payloader(
    name: '',
    surname: '',
    phone: '',
    companyName: '',
    companyEmail: '',
  );

  void _save() async {
    final isValid = _formKey.currentState!.validate();

    if (!isValid) {
      return;
    }

    _formKey.currentState!.save();

    setState(() {
      payloader = Payloader(
        name: _enteredName,
        surname: _enteredSurname,
        phone: _enteredPhone,
        companyName: _enteredCompanyName,
        companyEmail: _enteredCompanyEmail,
      );
    });

    Navigator.pop(context, payloader);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 31, 40, 51),
      appBar: AppBar(
        title: const Text('Payloader Credentials'),
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
                            labelText: 'Company Name',
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter your company name';
                            }

                            return null;
                          },
                          onSaved: (value) {
                            _enteredCompanyName = value!;
                          },
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            labelStyle: TextStyle(
                                color: Color.fromARGB(255, 225, 226, 228)),
                            labelText: 'Company Email',
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
                            _enteredCompanyEmail = value!;
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
