import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shipping_app/models/ad.dart';
import 'package:shipping_app/models/offer.dart';

class MyOffers extends StatefulWidget {
  const MyOffers({super.key});

  @override
  State<MyOffers> createState() {
    return _MyOffersState();
  }
}

class _MyOffersState extends State<MyOffers> {
  var _isLoading = true;
  List<Offer> _myOffers = [];
  List<Ad> _offeredAds = [];

  @override
  void initState() {
    super.initState();
    _loadOffers();
  }

  void _loadOffers() async {
    List<Offer> loadedOffers = [];
    List<Ad> loadedOfferedAds = [];

    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('driverOffers').get();

      if (querySnapshot.docs.isNotEmpty) {
        for (var doc in querySnapshot.docs) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

          if (FirebaseAuth.instance.currentUser!.uid == data['driverId']) {
            Offer offer = Offer(
              driverId: data['driverId'],
              driverName: data['driverName'],
              driverSurname: data['driverSurname'],
              driverPhone: data['driverPhone'],
              driverExpireDateOfLicence: data['driverExpireDateOfLİcence'],
              driverLicenceLink: data['driverLicence'],
              offerId: data['offerId'],
              adId: data['adId'],
            );

            loadedOffers.add(offer);

            QuerySnapshot querySnapshotAd = await FirebaseFirestore.instance
                .collection('payloaderAds')
                .get();

            if (querySnapshotAd.docs.isNotEmpty) {
              for (var doc in querySnapshotAd.docs) {
                Map<String, dynamic> adData =
                    doc.data() as Map<String, dynamic>;

                if (data['adId'] == adData['adId']) {
                  Ad ad = Ad(
                    departure: adData['departure'],
                    arrival: adData['arrival'],
                    departureDate: adData['departureDate'],
                    arrivalDate: adData['arrivalDate'],
                    loadContent: adData['loadContent'],
                    cost: adData['cost'],
                    id: adData['adId'],
                  );

                  loadedOfferedAds.add(ad);
                }
              }
            } else {
              print('No data found');
            }

            setState(() {
              _offeredAds = loadedOfferedAds;
            });
          }
        }
      } else {
        print('No data found');
      }

      setState(() {
        _myOffers = loadedOffers;
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        print('Something went wrong. Please try again later.');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget content = const Center(
      child: Text(
        'There is no ad offered yet.',
        style: TextStyle(
          color: Color.fromARGB(255, 31, 40, 51),
        ),
      ),
    );

    if (_isLoading) {
      content = const Center(child: CircularProgressIndicator());
    }
    if (_myOffers.isNotEmpty) {
      content = ListView.builder(
        itemCount: _myOffers.length,
        itemBuilder: (context, index) => Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                bottom: 8,
                                top: 8,
                              ),
                              child: Text(
                                'Departure',
                                style: GoogleFonts.lato(
                                  color: const Color.fromARGB(255, 31, 40, 51),
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                bottom: 8,
                              ),
                              child: Text(_offeredAds[index].departure),
                            ),
                          ],
                        ),
                        const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                left: 110,
                                right: 110,
                                bottom: 8,
                                top: 8,
                              ),
                              child: Icon(
                                Icons.local_shipping,
                                color: Color.fromARGB(255, 31, 40, 51),
                                size: 30,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                bottom: 8,
                                top: 8,
                              ),
                              child: Text(
                                'Arrival',
                                style: GoogleFonts.lato(
                                  color: const Color.fromARGB(255, 31, 40, 51),
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                bottom: 8,
                              ),
                              child: Text(_offeredAds[index].arrival),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 8,
                                right: 8,
                                bottom: 8,
                                top: 8,
                              ),
                              child: Text(
                                'Advertisement Id',
                                style: GoogleFonts.lato(
                                  color: const Color.fromARGB(255, 31, 40, 51),
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 8,
                                right: 8,
                                bottom: 8,
                              ),
                              child: Text(_offeredAds[index].id,
                                  style: const TextStyle(fontSize: 12)),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 8,
                                right: 8,
                                bottom: 8,
                                top: 8,
                              ),
                              child: Text(
                                'Cost',
                                style: GoogleFonts.lato(
                                  color: const Color.fromARGB(255, 31, 40, 51),
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 8,
                                right: 8,
                                bottom: 8,
                              ),
                              child: Text('${_offeredAds[index].cost}',
                                  style: const TextStyle(fontSize: 12)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }
    return content;
  }
}
