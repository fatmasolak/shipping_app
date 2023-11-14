import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:shipping_app/constants.dart';
import 'package:shipping_app/widgets/update_account_info.dart';

class AccountInfo extends StatefulWidget {
  const AccountInfo({super.key});

  @override
  State<AccountInfo> createState() => _AccountInfoState();
}

class _AccountInfoState extends State<AccountInfo> {
  var _isDriver = false;
  var _isLoading = true;
  var _name = '';
  var _surname = '';
  var _phone = '';
  var _driverLicence = '';
  var _expireDateOfLicence = '';
  var _companyName = '';
  var _companyEmail = '';

  @override
  void initState() {
    super.initState();
    isDriver();
    isPayloader();
  }

  void isDriver() async {
    try {
      bool isFound = false;

      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('driver').get();

      if (querySnapshot.docs.isNotEmpty) {
        for (var doc in querySnapshot.docs) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

          if (data['userId'] == FirebaseAuth.instance.currentUser!.uid) {
            isFound = true;
            _name = data['name'];
            _surname = data['surname'];
            _phone = data['phone'];
            _driverLicence = data['driverLicence'];
            _expireDateOfLicence = data['expireDateOfLicence'];
          }
        }
      } else {
        print('No data found');
      }

      setState(() {
        _isDriver = isFound;
        if (_isDriver) {
          _isLoading = false;
        }
      });
    } catch (error) {
      setState(() {
        print('Something went wrong. Please try again later.');
      });
    }
  }

  void isPayloader() async {
    if (!_isDriver) {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('payloader').get();

      if (querySnapshot.docs.isNotEmpty) {
        for (var doc in querySnapshot.docs) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

          if (data['userId'] == FirebaseAuth.instance.currentUser!.uid) {
            _name = data['name'];
            _surname = data['surname'];
            _phone = data['phone'];
            _companyName = data['companyName'];
            _companyEmail = data['companyEmail'];
          }
        }
      }
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _updateInfo() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const UpdateAccountInfo(),
      ),
    );

    if (result == true) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Value has updated.'),
        ),
      );
    }

    if (result == false) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cancelled.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget content;

    if (_isLoading) {
      content = const Center(child: CircularProgressIndicator());
    } else {
      content = SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  nameAndSurname(),
                  userId(),
                  phone(),
                  _isDriver ? expireDateOfDriverLicence() : companyName(),
                  _isDriver ? driverLicence() : companyEmail(),
                  updateButton(),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return content;
  }

  Padding updateButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 15,
        horizontal: 25,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 5,
              ),
              shape: RoundedRectangleBorder(
                //to set border radius to button
                borderRadius: BorderRadius.circular(29),
              ),
              backgroundColor: thirdColor,
            ),
            onPressed: _updateInfo,
            child: const Text(
              'Update',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container driverLicence() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 15,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 50,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 5,
                    ),
                    child: Text(
                      'Driver Licence',
                      style: GoogleFonts.lato(
                        color: const Color.fromARGB(255, 31, 40, 51),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  CircleAvatar(
                    backgroundImage: NetworkImage(
                      _driverLicence,
                    ),
                    backgroundColor: const Color.fromARGB(255, 31, 40, 51),
                    radius: 60,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container expireDateOfDriverLicence() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 15,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 50,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 5,
                    ),
                    child: Text(
                      'Expire Date Of Driver licence',
                      style: GoogleFonts.lato(
                        color: const Color.fromARGB(255, 31, 40, 51),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(
                    _expireDateOfLicence,
                    style: const TextStyle(fontSize: 15),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container companyEmail() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 15,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 50,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 5,
                    ),
                    child: Text(
                      'Company Email',
                      style: GoogleFonts.lato(
                        color: const Color.fromARGB(255, 31, 40, 51),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(
                    _companyEmail,
                    style: const TextStyle(fontSize: 15.5),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container companyName() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 15,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 50,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 5,
                    ),
                    child: Text(
                      'Company Name',
                      style: GoogleFonts.lato(
                        color: const Color.fromARGB(255, 31, 40, 51),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(
                    _companyName,
                    style: const TextStyle(fontSize: 15.5),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container phone() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 15,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 50,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 5,
                    ),
                    child: Text(
                      'User Phone',
                      style: GoogleFonts.lato(
                        color: const Color.fromARGB(255, 31, 40, 51),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(
                    _phone,
                    style: const TextStyle(fontSize: 15.5),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container userId() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 15,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 50,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 5,
                    ),
                    child: Text(
                      'User Id',
                      style: GoogleFonts.lato(
                        color: const Color.fromARGB(255, 31, 40, 51),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(
                    FirebaseAuth.instance.currentUser!.uid,
                    style: const TextStyle(fontSize: 15.5),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container nameAndSurname() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 10,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 5,
                  ),
                  child: Text(
                    'User Name',
                    style: GoogleFonts.lato(
                      color: const Color.fromARGB(255, 31, 40, 51),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  _name,
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
            const SizedBox(width: 100),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 5,
                  ),
                  child: Text(
                    'User Surname',
                    style: GoogleFonts.lato(
                      color: const Color.fromARGB(255, 31, 40, 51),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  _surname,
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
