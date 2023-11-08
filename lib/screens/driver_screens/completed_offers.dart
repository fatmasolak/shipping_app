import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shipping_app/models/ad.dart';

class CompletedOffers extends StatefulWidget {
  const CompletedOffers({super.key});

  @override
  State<CompletedOffers> createState() {
    return _CompletedOffersState();
  }
}

class _CompletedOffersState extends State<CompletedOffers> {
  var _isLoading = true;
  List<Ad> _completedAds = [];

  @override
  void initState() {
    super.initState();
    _loadOffers();
  }

  void _loadOffers() async {
    List<Ad> loadedCompletedAds = [];

    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('completedOffers').get();

      if (querySnapshot.docs.isNotEmpty) {
        for (var doc in querySnapshot.docs) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

          QuerySnapshot querySnapshotAd =
              await FirebaseFirestore.instance.collection('completedAds').get();

          if (querySnapshotAd.docs.isNotEmpty) {
            for (var docAd in querySnapshotAd.docs) {
              Map<String, dynamic> dataAd =
                  docAd.data() as Map<String, dynamic>;

              if (data['offerId'] == dataAd['offerId']) {
                if (data['driverId'] ==
                    FirebaseAuth.instance.currentUser!.uid) {
                  loadedCompletedAds.add(
                    Ad(
                      departure: dataAd['departure'],
                      arrival: dataAd['arrival'],
                      departureDate: dataAd['departureDate'],
                      arrivalDate: dataAd['arrivalDate'],
                      loadContent: dataAd['loadContent'],
                      cost: dataAd['cost'],
                      id: dataAd['adId'],
                      offerId: dataAd['offerId'],
                    ),
                  );
                }
              }
            }
          }
        }
      } else {
        print('No data found');
      }

      setState(() {
        _completedAds = loadedCompletedAds;
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        print('Something went wrong. Please try again later.');
        print(error);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget content = const Center(
      child: Text(
        'There is no completed offer yet.',
        style: TextStyle(
          color: Color.fromARGB(255, 31, 40, 51),
        ),
      ),
    );

    if (_isLoading) {
      content = const Center(child: CircularProgressIndicator());
    }
    if (_completedAds.isNotEmpty) {
      content = ListView.builder(
        itemCount: _completedAds.length,
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
                              child: Text(_completedAds[index].departure),
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
                              child: Text(_completedAds[index].arrival),
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
                              child: Text(_completedAds[index].id,
                                  style: const TextStyle(fontSize: 12)),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
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
                                'Offer Id',
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
                              child: Text(_completedAds[index].offerId,
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
                              child: Text('${_completedAds[index].cost}',
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
