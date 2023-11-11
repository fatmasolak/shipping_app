import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:shipping_app/screens/account_info.dart';
import 'package:shipping_app/screens/driver_screens/approved_offers.dart';
import 'package:shipping_app/screens/driver_screens/completed_offers.dart';
import 'package:shipping_app/screens/driver_screens/my_offers.dart';
import 'package:shipping_app/screens/driver_screens/waiting_ads.dart';
import 'package:shipping_app/widgets/create_app_bar.dart';

class DriverLoggedInScreen extends StatefulWidget {
  const DriverLoggedInScreen({super.key});

  @override
  State<DriverLoggedInScreen> createState() => _DriverLoggedInScreenState();
}

class _DriverLoggedInScreenState extends State<DriverLoggedInScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const WaitingAds(),
    const MyOffers(),
    const ApprovedOffers(),
    const CompletedOffers(),
    const AccountInfo(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CreateAppBar(header: 'Shipping', isShowing: true),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance.collection('driverOffers').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }

          if (snapshot.hasData) {
            return _pages.elementAt(_selectedIndex);
          }

          return _pages.elementAt(_selectedIndex);
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
            ),
            label: 'Ads',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.incomplete_circle),
            label: 'Offers',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_outlined),
            label: 'Approved',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.done_all),
            label: 'Completed',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_rounded),
            label: 'My Account',
          ),
        ],
        currentIndex: _selectedIndex,
        backgroundColor: const Color.fromARGB(255, 31, 40, 51),
        unselectedItemColor: Colors.white,
        selectedItemColor: const Color.fromARGB(255, 102, 252, 241),
        onTap: _onItemTapped,
      ),
    );
  }
}
