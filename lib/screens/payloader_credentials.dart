import 'package:flutter/material.dart';
import 'package:shipping_app/constants.dart';
import 'package:shipping_app/models/payloader.dart';
import 'package:shipping_app/widgets/create_app_bar.dart';

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
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: const CreateAppBar(
        header: 'Payloader Credentials',
        isShowing: false,
        color: primaryColor,
      ),
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
                    payloaderNameField(size),
                    payloaderSurnameField(size),
                    payloaderPhoneField(size),
                    companyNameField(size),
                    companyEmailField(size),
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

  Container companyEmailField(Size size) {
    return Container(
      width: size.width * 0.99,
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 5,
      ),
      child: TextFormField(
        decoration: const InputDecoration(
          hintText: 'Company Email',
          focusColor: primaryColor,
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
          _enteredCompanyEmail = value!;
        },
      ),
    );
  }

  Container companyNameField(Size size) {
    return Container(
      width: size.width * 0.99,
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 5,
      ),
      child: TextFormField(
        decoration: const InputDecoration(
          hintText: 'Company Name',
          focusColor: primaryColor,
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
    );
  }

  Container payloaderPhoneField(Size size) {
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

  Container payloaderSurnameField(Size size) {
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

  Container payloaderNameField(Size size) {
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
