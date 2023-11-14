import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:shipping_app/constants.dart';
import 'package:shipping_app/models/ad.dart';

import 'package:shipping_app/models/offer.dart';
import 'package:shipping_app/widgets/create_app_bar.dart';

class OfferDetails extends StatefulWidget {
  const OfferDetails({super.key, required this.offer});

  final Offer offer;

  @override
  State<OfferDetails> createState() => _OfferDetailsState();
}

class _OfferDetailsState extends State<OfferDetails> {
  var _isApproved = false;

  void _approveOffer() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('payloaderAds').get();

      if (querySnapshot.docs.isNotEmpty) {
        for (var doc in querySnapshot.docs) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

          if (widget.offer.adId == data['adId']) {
            Ad ad = Ad(
              departure: data['departure'],
              arrival: data['arrival'],
              departureDate: data['departureDate'],
              arrivalDate: data['arrivalDate'],
              loadContent: data['loadContent'],
              cost: data['cost'],
              id: data['adId'],
              offerId: '',
            );

            await FirebaseFirestore.instance
                .collection('approvedAds')
                .doc(data['adId'])
                .set({
              'departure': ad.departure,
              'arrival': ad.arrival,
              'departureDate': ad.departureDate,
              'arrivalDate': ad.arrivalDate,
              'loadContent': ad.loadContent,
              'cost': ad.cost,
              'adId': ad.id,
              'payloaderId': FirebaseAuth.instance.currentUser!.uid,
              'offerId': widget.offer.offerId,
            });

            await FirebaseFirestore.instance
                .collection('approvedOffers')
                .doc(widget.offer.offerId)
                .set({
              'driverId': widget.offer.driverId,
              'driverName': widget.offer.driverName,
              'driverSurname': widget.offer.driverSurname,
              'driverPhone': widget.offer.driverPhone,
              'driverExpireDateOfLicence':
                  widget.offer.driverExpireDateOfLicence,
              'driverLicence': widget.offer.driverLicenceLink,
              'offerId': widget.offer.offerId,
              'adId': ad.id,
            });

            QuerySnapshot querySnapshotOffers = await FirebaseFirestore.instance
                .collection('driverOffers')
                .get();

            if (querySnapshotOffers.docs.isNotEmpty) {
              for (var docOffers in querySnapshotOffers.docs) {
                Map<String, dynamic> dataOffers =
                    docOffers.data() as Map<String, dynamic>;

                if (dataOffers['adId'] == data['adId']) {
                  await FirebaseFirestore.instance
                      .collection('driverOffers')
                      .doc(dataOffers['offerId'])
                      .delete()
                      .then(
                        (doc) => print("Document deleted"),
                        onError: (e) => print("Error updating document $e"),
                      );
                }
              }
            }

            await FirebaseFirestore.instance
                .collection('payloaderAds')
                .doc(data['adId'])
                .delete()
                .then(
                  (doc) => print("Document deleted"),
                  onError: (e) => print("Error updating document $e"),
                );
          }
        }
      } else {
        print('No data found');
      }

      setState(() {
        _isApproved = true;
      });
    } catch (error) {
      setState(() {
        print('Something went wrong. Please try again later.');
      });
    }

    Navigator.pop(context, _isApproved);
    Navigator.pop(context);

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Offer has approved.'),
      ),
    );
  }

  void _cancel() async {
    setState(() {
      _isApproved = false;
    });

    Navigator.pop(context, _isApproved);

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
      appBar: CreateAppBar(
        header: widget.offer.offerId,
        isShowing: false,
        color: primaryColor,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 20),
              driverNameAndSurname(),
              driverId(),
              driverPhone(),
              expireDateOfDriverLicence(),
              driverLicence(),
              approveOfferButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Padding approveOfferButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 15,
        horizontal: 25,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            onPressed: _cancel,
            child: const Text(
              'Cancel',
              style: TextStyle(
                color: thirdColor,
              ),
            ),
          ),
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
            onPressed: _approveOffer,
            child: const Text(
              'Approve',
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
                horizontal: 37,
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
                      widget.offer.driverLicenceLink,
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
                horizontal: 37,
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
                    widget.offer.driverExpireDateOfLicence,
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

  Container driverPhone() {
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
                horizontal: 37,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 5,
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
                  Text(
                    widget.offer.driverPhone,
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

  Container driverId() {
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
                horizontal: 37,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 5,
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
                  Text(
                    widget.offer.driverId,
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

  Container driverNameAndSurname() {
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
                    'Driver Name',
                    style: GoogleFonts.lato(
                      color: const Color.fromARGB(255, 31, 40, 51),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  widget.offer.driverName,
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
            const SizedBox(width: 100),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 5,
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
                Text(
                  widget.offer.driverSurname,
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
