import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shipping_app/enums/pages_enum.dart';
import 'package:shipping_app/models/ad.dart';
import 'package:shipping_app/widgets/create_ad_card.dart';

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
              child: CreateAdCard(
                ads: _completedAds,
                index: index,
                page: Pages.completedOffers,
              ),
            ),
          ),
        ),
      );
    }
    return content;
  }
}
