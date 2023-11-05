import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CompletedAds extends StatefulWidget {
  const CompletedAds({super.key});

  @override
  State<CompletedAds> createState() {
    return _CompletedAdsState();
  }
}

class _CompletedAdsState extends State<CompletedAds> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'completed ads',
        style: TextStyle(
          color: Color.fromARGB(255, 31, 40, 51),
        ),
      ),
    );
  }
}
