import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ApprovedAds extends StatefulWidget {
  const ApprovedAds({super.key});

  @override
  State<ApprovedAds> createState() {
    return _ApprovedAdsState();
  }
}

class _ApprovedAdsState extends State<ApprovedAds> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'approved ads',
        style: TextStyle(
          color: Color.fromARGB(255, 31, 40, 51),
        ),
      ),
    );
  }
}
