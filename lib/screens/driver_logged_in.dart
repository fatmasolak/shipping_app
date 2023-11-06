import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shipping_app/screens/driver_screens/approved_offers.dart';
import 'package:shipping_app/screens/driver_screens/my_offers.dart';
import 'package:shipping_app/screens/driver_screens/waiting_ads.dart';

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
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 31, 40, 51),
        title: const Text(
          'Shipping',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
            icon: const Icon(
              Icons.exit_to_app,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: _pages.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color.fromARGB(255, 31, 40, 51),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Waiting Ads',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.incomplete_circle),
            label: 'My Offers',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_outlined),
            label: 'Approved Offers',
          ),
        ],
        currentIndex: _selectedIndex,
        unselectedItemColor: Colors.white,
        selectedItemColor: const Color.fromARGB(255, 102, 252, 241),
        onTap: _onItemTapped,
      ),
    );
  }
}
