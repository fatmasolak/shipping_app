import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shipping_app/enums/pages_enum.dart';
import 'package:shipping_app/models/ad.dart';
import 'package:shipping_app/models/offer.dart';
import 'package:shipping_app/widgets/create_ad_card.dart';

class ApprovedOffers extends StatefulWidget {
  const ApprovedOffers({super.key});

  @override
  State<ApprovedOffers> createState() {
    return _ApprovedOffersState();
  }
}

class _ApprovedOffersState extends State<ApprovedOffers> {
  var _isLoading = true;
  List<Ad> _offeredAds = [];
  var _isCompleted = false;
  var _isComplating = false;

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
          await FirebaseFirestore.instance.collection('approvedOffers').get();

      if (querySnapshot.docs.isNotEmpty) {
        for (var doc in querySnapshot.docs) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

          if (FirebaseAuth.instance.currentUser!.uid == data['driverId']) {
            Offer offer = Offer(
              driverId: data['driverId'],
              driverName: data['driverName'],
              driverSurname: data['driverSurname'],
              driverPhone: data['driverPhone'],
              driverExpireDateOfLicence: data['driverExpireDateOfLicence'],
              driverLicenceLink: data['driverLicence'],
              offerId: data['offerId'],
              adId: data['adId'],
            );

            loadedOffers.add(offer);

            QuerySnapshot querySnapshotAd = await FirebaseFirestore.instance
                .collection('approvedAds')
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
                    offerId: adData['offerId'],
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
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        print('Something went wrong. Please try again later.');
      });
    }
  }

  void _completeAd(Ad ad) async {
    setState(() {
      _isComplating = true;
    });

    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('approvedOffers').get();

    if (querySnapshot.docs.isNotEmpty) {
      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        if (data['offerId'] == ad.offerId) {
          await FirebaseFirestore.instance
              .collection('completedOffers')
              .doc(data['offerId'])
              .set({
            'driverId': data['driverId'],
            'driverName': data['driverName'],
            'driverSurname': data['driverSurname'],
            'driverPhone': data['driverPhone'],
            'driverExpireDateOfLicence': data['driverExpireDateOfLicence'],
            'driverLicence': data['driverLicence'],
            'offerId': data['offerId'],
            'adId': ad.id,
          });

          await FirebaseFirestore.instance
              .collection('approvedOffers')
              .doc(data['offerId'])
              .delete()
              .then(
                (doc) => print("Document deleted"),
                onError: (e) => print("Error updating document $e"),
              );
        }
      }
    }

    QuerySnapshot querySnapshotAd =
        await FirebaseFirestore.instance.collection('approvedAds').get();

    if (querySnapshotAd.docs.isNotEmpty) {
      for (var doc in querySnapshotAd.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        if (data['adId'] == ad.id) {
          await FirebaseFirestore.instance
              .collection('completedAds')
              .doc(ad.id)
              .set({
            'departure': ad.departure,
            'arrival': ad.arrival,
            'departureDate': ad.departureDate,
            'arrivalDate': ad.arrivalDate,
            'loadContent': ad.loadContent,
            'cost': ad.cost,
            'adId': ad.id,
            'payloaderId': data['payloaderId'],
            'offerId': ad.offerId,
          });
        }
      }
    }

    await FirebaseFirestore.instance
        .collection('approvedAds')
        .doc(ad.id)
        .delete()
        .then(
          (doc) => print("Document deleted"),
          onError: (e) => print("Error updating document $e"),
        );

    setState(() {
      _isCompleted = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget content = const Center(
      child: Text(
        'There is no approved offer yet.',
        style: TextStyle(
          color: Color.fromARGB(255, 31, 40, 51),
        ),
      ),
    );

    if (_isLoading) {
      content = const Center(child: CircularProgressIndicator());
    }
    if (_offeredAds.isNotEmpty && !_isCompleted) {
      content = ListView.builder(
        itemCount: _offeredAds.length,
        itemBuilder: (context, index) => Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CreateAdCard(
                ads: _offeredAds,
                index: index,
                completeAd: _completeAd,
                isComplating: _isComplating,
                page: Pages.approvedOffers,
              ),
            ),
          ),
        ),
      );
    }
    return content;
  }

  Row advertisementId(int index) {
    return Row(
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
    );
  }

  Row departureAndArrival(int index) {
    return Row(
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
    );
  }
}
