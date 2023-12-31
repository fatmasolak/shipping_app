import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shipping_app/constants.dart';
import 'package:shipping_app/models/ad.dart';
import 'package:shipping_app/screens/account_info.dart';
import 'package:shipping_app/screens/payloader_screens/approved_ads.dart';
import 'package:shipping_app/screens/payloader_screens/completed_ads.dart';
import 'package:shipping_app/screens/payloader_screens/my_ads.dart';
import 'package:shipping_app/widgets/create_ad.dart';
import 'package:shipping_app/widgets/create_app_bar.dart';

class PayloaderLoggedInScreen extends StatefulWidget {
  const PayloaderLoggedInScreen({super.key});

  @override
  State<PayloaderLoggedInScreen> createState() {
    return _PayloaderLoggedInState();
  }
}

class _PayloaderLoggedInState extends State<PayloaderLoggedInScreen> {
  List<Ad> _payloaderAds = [];
  int _selectedIndex = 0;
  bool showButton = true;

  final List<Widget> _pages = [
    const MyAds(),
    const ApprovedAds(),
    const CompletedAds(),
    const AccountInfo(),
  ];

  @override
  void initState() {
    super.initState();
    _loadAds();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (_selectedIndex != 0) {
        showButton = false;
      } else {
        showButton = true;
      }
    });
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

      QuerySnapshot querySnapshotApprovedAds =
          await FirebaseFirestore.instance.collection('approvedAds').get();

      if (querySnapshotApprovedAds.docs.isNotEmpty) {
        for (var doc in querySnapshotApprovedAds.docs) {
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

      QuerySnapshot querySnapshotCompletedAds =
          await FirebaseFirestore.instance.collection('completedAds').get();

      if (querySnapshotCompletedAds.docs.isNotEmpty) {
        for (var doc in querySnapshotCompletedAds.docs) {
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

      QuerySnapshot querySnapshotDeletedAds =
          await FirebaseFirestore.instance.collection('deletedAds').get();

      if (querySnapshotDeletedAds.docs.isNotEmpty) {
        for (var doc in querySnapshotDeletedAds.docs) {
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
      });
    } catch (error) {
      setState(() {
        print('Something went wrong. Please try again later.');
      });
    }
  }

  void _addNewAd() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CreateAd(),
      ),
    );

    if (result == null) {
      return;
    }

    setState(() {
      _payloaderAds.add(result);
    });

    await FirebaseFirestore.instance
        .collection('payloaderAds')
        .doc(
            'Ad${_payloaderAds.length}-${FirebaseAuth.instance.currentUser!.uid}')
        .set({
      'departure': result.departure,
      'arrival': result.arrival,
      'departureDate': result.departureDate,
      'arrivalDate': result.arrivalDate,
      'loadContent': result.loadContent,
      'cost': result.cost,
      'adId':
          'Ad${_payloaderAds.length}-${FirebaseAuth.instance.currentUser!.uid}',
      'payloaderId': FirebaseAuth.instance.currentUser!.uid,
    });

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('New advertisement has added.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CreateAppBar(
        header: 'Shipping',
        isShowing: true,
        color: primaryColor,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance.collection('payloaderAds').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }

          if (snapshot.hasData) {
            return StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('approvedAds')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }

                  if (snapshot.hasData) {
                    return _pages.elementAt(_selectedIndex);
                  }
                  return _pages.elementAt(_selectedIndex);
                });
          }

          return _pages.elementAt(_selectedIndex);
        },
      ),
      floatingActionButton: showButton ? createAdButton(size) : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'My Ads',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.incomplete_circle),
            label: 'Approved Ads',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_outlined),
            label: 'Completed Ads',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_rounded),
            label: 'My Account',
          ),
        ],
        currentIndex: _selectedIndex,
        backgroundColor: primaryColor,
        unselectedItemColor: Colors.white,
        selectedItemColor: fourthColor,
        onTap: _onItemTapped,
      ),
    );
  }

  Padding createAdButton(Size size) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 80,
      ),
      child: SizedBox(
        width: size.width * 0.6,
        height: size.height * 0.06,
        child: FloatingActionButton(
          backgroundColor: primaryColor,
          shape: RoundedRectangleBorder(
            //to set border radius to button
            borderRadius: BorderRadius.circular(29),
          ),
          onPressed: _addNewAd,
          child: const Text(
            'Create an Ad',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
