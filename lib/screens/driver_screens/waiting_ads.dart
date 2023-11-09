import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shipping_app/models/ad.dart';
import 'package:shipping_app/screens/payloader_screens/ad_details.dart';
import 'package:shipping_app/widgets/create_ad_card.dart';

class WaitingAds extends StatefulWidget {
  const WaitingAds({super.key});

  @override
  State<WaitingAds> createState() {
    return _WaitingAdsState();
  }
}

class _WaitingAdsState extends State<WaitingAds> {
  var _isLoading = true;
  List<Ad> _payloaderAds = [];

  @override
  void initState() {
    super.initState();
    _loadAds();
  }

  void _loadAds() async {
    List<Ad> loadedAds = [];

    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('payloaderAds').get();

      if (querySnapshot.docs.isNotEmpty) {
        for (var doc in querySnapshot.docs) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

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

          loadedAds.add(ad);
        }
      } else {
        print('No data found');
      }

      setState(() {
        _payloaderAds = loadedAds;
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
        'No ads added yet.',
        style: TextStyle(
          color: Color.fromARGB(255, 31, 40, 51),
        ),
      ),
    );

    if (_isLoading) {
      content = const Center(child: CircularProgressIndicator());
    }
    if (_payloaderAds.isNotEmpty) {
      content = ListView.builder(
        itemCount: _payloaderAds.length,
        itemBuilder: (context, index) => Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AdDetails(
                        ad: _payloaderAds[index],
                        isDriver: true,
                      ),
                    ),
                  );
                },
                child: CreateAdCard(ads: _payloaderAds, index: index),
              ),
            ),
          ),
        ),
      );
    }
    return content;
  }
}
