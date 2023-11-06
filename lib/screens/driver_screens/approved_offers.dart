import 'package:flutter/material.dart';

class ApprovedOffers extends StatefulWidget {
  const ApprovedOffers({super.key});

  @override
  State<ApprovedOffers> createState() {
    return _ApprovedOffersState();
  }
}

class _ApprovedOffersState extends State<ApprovedOffers> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'approved offers',
        style: TextStyle(
          color: Color.fromARGB(255, 31, 40, 51),
        ),
      ),
    );
  }
}
