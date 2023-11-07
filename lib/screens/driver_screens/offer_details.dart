import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:shipping_app/models/ad.dart';

import 'package:shipping_app/models/offer.dart';

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
              'driverExpireDateOfLİcence':
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
  }

  void _cancel() async {
    setState(() {
      _isApproved = false;
    });

    Navigator.pop(context, _isApproved);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white, //change your color here
        ),
        backgroundColor: const Color.fromARGB(255, 31, 40, 51),
        title: Text(
          widget.offer.offerId,
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Column(
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
                                widget.offer.driverName,
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 100),
                        Column(
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
                                widget.offer.driverSurname,
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                    Row(
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
                                widget.offer.driverId,
                                style: const TextStyle(fontSize: 15.5),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                    Row(
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
                                widget.offer.driverPhone,
                                style: const TextStyle(fontSize: 15.5),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                    Row(
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
                                widget.offer.driverExpireDateOfLicence,
                                style: const TextStyle(fontSize: 15),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                    Row(
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
                                  widget.offer.driverLicenceLink,
                                ),
                                backgroundColor:
                                    const Color.fromARGB(255, 31, 40, 51),
                                radius: 60,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: _cancel,
                          child: const Text('Cancel'),
                        ),
                        ElevatedButton(
                          onPressed: _approveOffer,
                          child: const Text('Approve'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
