import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shipping_app/models/ad.dart';
import 'package:shipping_app/screens/payloader_screens/ad_details.dart';
import 'package:shipping_app/widgets/create_ad_card.dart';

class ApprovedAds extends StatefulWidget {
  const ApprovedAds({super.key});

  @override
  State<ApprovedAds> createState() {
    return _ApprovedAdsState();
  }
}

class _ApprovedAdsState extends State<ApprovedAds> {
  var _isLoading = true;
  List<Ad> _myAds = [];

  @override
  void initState() {
    super.initState();
    _loadAds();
  }

  void _loadAds() async {
    List<Ad> loadedAds = [];

    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('approvedAds').get();

      if (querySnapshot.docs.isNotEmpty) {
        for (var doc in querySnapshot.docs) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

          if (FirebaseAuth.instance.currentUser!.uid == data['payloaderId']) {
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
        }
      } else {
        print('No data found');
      }

      setState(() {
        _myAds = loadedAds;
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
        'There is no approved ad yet.',
        style: TextStyle(
          color: Color.fromARGB(255, 31, 40, 51),
        ),
      ),
    );

    if (_isLoading) {
      content = const Center(child: CircularProgressIndicator());
    }
    if (_myAds.isNotEmpty) {
      content = ListView.builder(
        itemCount: _myAds.length,
        itemBuilder: (context, index) => Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          AdDetails(ad: _myAds[index], isDriver: false),
                    ),
                  );
                },
                child: CreateAdCard(ads: _myAds, index: index),
              ),
            ),
          ),
        ),
      );
    }
    return content;
  }
}
