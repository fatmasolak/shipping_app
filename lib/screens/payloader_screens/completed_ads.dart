import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shipping_app/models/ad.dart';
import 'package:shipping_app/widgets/create_ad_card.dart';

class CompletedAds extends StatefulWidget {
  const CompletedAds({super.key});

  @override
  State<CompletedAds> createState() {
    return _CompletedAdsState();
  }
}

class _CompletedAdsState extends State<CompletedAds> {
  var _isLoading = true;
  List<Ad> _completedAds = [];

  @override
  void initState() {
    super.initState();
    _loadAds();
  }

  void _loadAds() async {
    List<Ad> loadedCompletedAds = [];

    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('completedAds').get();

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
              offerId: data['offerId'],
            );

            loadedCompletedAds.add(ad);

            setState(() {
              _completedAds = loadedCompletedAds;
              _isLoading = false;
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

  @override
  Widget build(BuildContext context) {
    Widget content = const Center(
      child: Text(
        'There is no completed ad yet.',
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
                child: CreateAdCard(ads: _completedAds, index: index)),
          ),
        ),
      );
    }
    return content;
  }
}
