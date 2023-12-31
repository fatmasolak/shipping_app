import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shipping_app/constants.dart';
import 'package:shipping_app/widgets/create_app_bar.dart';

class CreateOffer extends StatefulWidget {
  const CreateOffer({super.key, required this.driverId});

  final String driverId;

  @override
  State<CreateOffer> createState() => _CreateOfferState(driverId);
}

class _CreateOfferState extends State<CreateOffer> {
  final String driverId;
  String _driverName = '';
  String _driverSurname = '';
  String _driverPhone = '';
  String _driverExpireDateOfLicence = '';
  String _driverLicenceLink = '';
  bool _isOffered = false;

  _CreateOfferState(this.driverId);

  @override
  void initState() {
    super.initState();
    _loadDriverCredentials();
  }

  void _loadDriverCredentials() async {
    String driverName = '';
    String driverSurname = '';
    String driverPhone = '';
    String driverExpireDateOfLicence = '';
    String driverLicenceLink = '';

    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('driver').get();

      if (querySnapshot.docs.isNotEmpty) {
        for (var doc in querySnapshot.docs) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

          if (data['userId'] == driverId) {
            driverName = data['name'];
            driverSurname = data['surname'];
            driverPhone = data['phone'];
            driverExpireDateOfLicence = data['expireDateOfLicence'];
            driverLicenceLink = data['driverLicence'];
          }
        }
      } else {
        print('No data found');
      }

      setState(() {
        _driverName = driverName;
        _driverSurname = driverSurname;
        _driverPhone = driverPhone;
        _driverExpireDateOfLicence = driverExpireDateOfLicence;
        _driverLicenceLink = driverLicenceLink;
      });
    } catch (error) {
      setState(() {
        print('Something went wrong. Please try again later.');
      });
    }
  }

  void _saveOffer() async {
    setState(() {
      _isOffered = true;
    });

    Navigator.pop(context, _isOffered);

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Offer has given.'),
      ),
    );
  }

  void _cancel() async {
    setState(() {
      _isOffered = false;
    });

    Navigator.pop(context, _isOffered);

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Cancelled.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CreateAppBar(
        header: 'Create New Offer',
        isShowing: false,
        color: primaryColor,
      ),
      body: Column(
        children: [
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    showDriverNameAndSurname(),
                    const SizedBox(height: 40),
                    showDriverId(),
                    const SizedBox(height: 40),
                    showDriverPhone(),
                    const SizedBox(height: 40),
                    showExpireDateOfLicence(),
                    const SizedBox(height: 40),
                    showDriverLicence(),
                    showButtons(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Row showButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        cancelButton(),
        saveButton(),
      ],
    );
  }

  ElevatedButton saveButton() {
    return ElevatedButton(
      onPressed: _saveOffer,
      child: const Text('Save'),
    );
  }

  TextButton cancelButton() {
    return TextButton(
      onPressed: _cancel,
      child: const Text('Cancel'),
    );
  }

  Row showDriverLicence() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: 25,
                bottom: 8,
                top: 8,
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
            Padding(
              padding: const EdgeInsets.only(
                left: 25,
                bottom: 8,
              ),
              child: CircleAvatar(
                backgroundImage: NetworkImage(
                  _driverLicenceLink,
                ),
                backgroundColor: const Color.fromARGB(255, 31, 40, 51),
                radius: 60,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Row showExpireDateOfLicence() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: 25,
                bottom: 8,
                top: 8,
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
            Padding(
              padding: const EdgeInsets.only(
                left: 25,
                bottom: 8,
              ),
              child: Text(
                _driverExpireDateOfLicence,
                style: const TextStyle(fontSize: 15),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Row showDriverPhone() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: 25,
                right: 8,
                bottom: 8,
                top: 8,
              ),
              child: Text(
                'Driver Phone',
                style: GoogleFonts.lato(
                  color: const Color.fromARGB(255, 31, 40, 51),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 25,
                right: 8,
                bottom: 8,
              ),
              child: Text(
                _driverPhone,
                style: const TextStyle(fontSize: 15.5),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Row showDriverId() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: 25,
                right: 8,
                bottom: 8,
                top: 8,
              ),
              child: Text(
                'Driver Id',
                style: GoogleFonts.lato(
                  color: const Color.fromARGB(255, 31, 40, 51),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 25,
                right: 8,
                bottom: 8,
              ),
              child: Text(
                driverId,
                style: const TextStyle(fontSize: 15.5),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Row showDriverNameAndSurname() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        driverName(),
        const SizedBox(width: 100),
        driverSurname(),
      ],
    );
  }

  Column driverSurname() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            bottom: 8,
            top: 40,
          ),
          child: Text(
            'Driver Surname',
            style: GoogleFonts.lato(
              color: const Color.fromARGB(255, 31, 40, 51),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            bottom: 8,
          ),
          child: Text(
            _driverSurname,
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }

  Column driverName() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: 25,
            bottom: 8,
            top: 40,
          ),
          child: Text(
            'Driver Name',
            style: GoogleFonts.lato(
              color: const Color.fromARGB(255, 31, 40, 51),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            left: 25,
            bottom: 8,
          ),
          child: Text(
            _driverName,
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }
}
