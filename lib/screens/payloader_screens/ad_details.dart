import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shipping_app/constants.dart';

import 'package:shipping_app/models/ad.dart';
import 'package:shipping_app/models/offer.dart';
import 'package:shipping_app/widgets/ad_offers.dart';
import 'package:shipping_app/widgets/create_app_bar.dart';
import 'package:shipping_app/widgets/create_offer.dart';
import 'package:shipping_app/widgets/update_ad.dart';

class AdDetails extends StatefulWidget {
  const AdDetails({super.key, required this.ad, required this.isDriver});

  final Ad ad;
  final bool isDriver;

  @override
  State<AdDetails> createState() => _AdDetailsState();
}

class _AdDetailsState extends State<AdDetails> {
  List<Offer> _driverOffers = [];
  List<Offer> _adOffers = [];
  String _driverName = '';
  String _driverSurname = '';
  String _driverPhone = '';
  String _driverExpireDateOfLicence = '';
  String _driverLicenceLink = '';

  bool isOffered = false;
  bool isApproved = false;

  @override
  void initState() {
    super.initState();

    _isOffered();
    _isApproved();
    _loadOffers();
    _loadAdOffers();
  }

  void _isOffered() async {
    try {
      bool isFound = false;

      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('driverOffers').get();

      if (querySnapshot.docs.isNotEmpty) {
        for (var doc in querySnapshot.docs) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

          if (data['adId'] == widget.ad.id &&
              data['driverId'] == FirebaseAuth.instance.currentUser!.uid) {
            isFound = true;
          }
        }
      } else {
        print('No data found');
      }

      setState(() {
        isOffered = isFound;
      });
    } catch (error) {
      setState(() {
        print('Something went wrong. Please try again later.');
      });
    }
  }

  void _isApproved() async {
    try {
      bool isFound = false;

      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('approvedAds').get();

      if (querySnapshot.docs.isNotEmpty) {
        for (var doc in querySnapshot.docs) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

          if (data['adId'] == widget.ad.id) {
            isFound = true;
          }
        }
      } else {
        print('No data found');
      }

      setState(() {
        isApproved = isFound;
      });
    } catch (error) {
      setState(() {
        print('Something went wrong. Please try again later.');
      });
    }
  }

  void _loadOffers() async {
    List<Offer> loadedOffers = [];
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('driverOffers').get();

      if (querySnapshot.docs.isNotEmpty) {
        for (var doc in querySnapshot.docs) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

          Offer offer = Offer(
            driverId: data['driverId'],
            driverName: data['driverName'],
            driverSurname: data['driverSurname'],
            driverPhone: data['driverPhone'],
            driverExpireDateOfLicence: data['driverExpireDateOfLicence'],
            driverLicenceLink: data['driverLicence'],
            offerId: data['offerId'],
            adId: data['adId'],
          );

          loadedOffers.add(offer);
        }
      } else {
        print('No data found');
      }

      QuerySnapshot querySnapshotApprovedOffers =
          await FirebaseFirestore.instance.collection('approvedOffers').get();

      if (querySnapshotApprovedOffers.docs.isNotEmpty) {
        for (var doc in querySnapshotApprovedOffers.docs) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

          Offer offer = Offer(
            driverId: data['driverId'],
            driverName: data['driverName'],
            driverSurname: data['driverSurname'],
            driverPhone: data['driverPhone'],
            driverExpireDateOfLicence: data['driverExpireDateOfLicence'],
            driverLicenceLink: data['driverLicence'],
            offerId: data['offerId'],
            adId: data['adId'],
          );

          loadedOffers.add(offer);
        }
      } else {
        print('No data found');
      }

      QuerySnapshot querySnapshotCompletedOffers =
          await FirebaseFirestore.instance.collection('completedOffers').get();

      if (querySnapshotCompletedOffers.docs.isNotEmpty) {
        for (var doc in querySnapshotCompletedOffers.docs) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

          Offer offer = Offer(
            driverId: data['driverId'],
            driverName: data['driverName'],
            driverSurname: data['driverSurname'],
            driverPhone: data['driverPhone'],
            driverExpireDateOfLicence: data['driverExpireDateOfLicence'],
            driverLicenceLink: data['driverLicence'],
            offerId: data['offerId'],
            adId: data['adId'],
          );

          loadedOffers.add(offer);
        }
      } else {
        print('No data found');
      }

      setState(() {
        _driverOffers = loadedOffers;
      });
    } catch (error) {
      setState(() {
        print('Something went wrong. Please try again later.');
      });
    }
  }

  void _giveAnOffer() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateOffer(
          driverId: FirebaseAuth.instance.currentUser!.uid,
        ),
      ),
    );

    if (result == false) {
      return;
    }

    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('driver').get();

    if (querySnapshot.docs.isNotEmpty) {
      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        if (data['userId'] == FirebaseAuth.instance.currentUser!.uid) {
          _driverName = data['name'];
          _driverSurname = data['surname'];
          _driverPhone = data['phone'];
          _driverExpireDateOfLicence = data['expireDateOfLicence'];
          _driverLicenceLink = data['driverLicence'];
        }
      }
    } else {
      print('No data found');
    }

    setState(() {
      _driverOffers.add(
        Offer(
          driverId: FirebaseAuth.instance.currentUser!.uid,
          driverName: _driverName,
          driverSurname: _driverSurname,
          driverPhone: _driverPhone,
          driverExpireDateOfLicence: _driverExpireDateOfLicence,
          driverLicenceLink: _driverLicenceLink,
          offerId:
              'Offer${_driverOffers.length}-${FirebaseAuth.instance.currentUser!.uid}',
          adId: widget.ad.id,
        ),
      );
      isOffered = true;
    });

    await FirebaseFirestore.instance
        .collection('driverOffers')
        .doc(
            'Offer${_driverOffers.length}-${FirebaseAuth.instance.currentUser!.uid}')
        .set({
      'driverId': FirebaseAuth.instance.currentUser!.uid,
      'driverName': _driverName,
      'driverSurname': _driverSurname,
      'driverPhone': _driverPhone,
      'driverExpireDateOfLicence': _driverExpireDateOfLicence,
      'driverLicence': _driverLicenceLink,
      'offerId':
          'Offer${_driverOffers.length}-${FirebaseAuth.instance.currentUser!.uid}',
      'adId': widget.ad.id,
    });

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Offer has given.'),
      ),
    );
  }

  void _loadAdOffers() async {
    List<Offer> loadedAdOffers = [];
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('driverOffers').get();

      if (querySnapshot.docs.isNotEmpty) {
        for (var doc in querySnapshot.docs) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

          if (data['adId'] == widget.ad.id) {
            Offer offer = Offer(
              driverId: data['driverId'],
              driverName: data['driverName'],
              driverSurname: data['driverSurname'],
              driverPhone: data['driverPhone'],
              driverExpireDateOfLicence: data['driverExpireDateOfLicence'],
              driverLicenceLink: data['driverLicence'],
              offerId: data['offerId'],
              adId: data['adId'],
            );

            loadedAdOffers.add(offer);
          }
        }
      } else {
        print('No data found');
      }

      setState(() {
        _adOffers = loadedAdOffers;
        print(_adOffers.length);
      });
    } catch (error) {
      setState(() {
        print('Something went wrong. Please try again later.');
      });
    }
  }

  void _updateAd() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UpdateAd(ad: widget.ad),
      ),
    );

    if (result == true) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ad has updated.'),
        ),
      );

      Navigator.pop(context);
    }

    if (result == false) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cancelled.'),
        ),
      );
    }
  }

  void _deleteAd() async {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Delete'),
        content: const Text('Are you sure want to delete this ad?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'No'),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () async {
              FirebaseFirestore.instance
                  .collection('payloaderAds')
                  .doc(widget.ad.id)
                  .delete();

              QuerySnapshot querySnapshot = await FirebaseFirestore.instance
                  .collection('driverOffers')
                  .get();

              if (querySnapshot.docs.isNotEmpty) {
                for (var doc in querySnapshot.docs) {
                  Map<String, dynamic> data =
                      doc.data() as Map<String, dynamic>;

                  if (data['adId'] == widget.ad.id) {
                    FirebaseFirestore.instance
                        .collection('driverOffers')
                        .doc(data['offerId'])
                        .delete();
                  }
                }
              }
              Navigator.pop(context, 'Yes');
              Navigator.pop(context, 'Yes');

              ScaffoldMessenger.of(context).clearSnackBars();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Ad has deleted.'),
                ),
              );
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CreateAppBar(
          header: widget.ad.id, isShowing: false, color: primaryColor),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Column(
              children: [
                const SizedBox(height: 20),
                departureAndArrival(),
                departureDate(),
                arrivalDate(),
                advertisementId(),
                loadContent(),
                cost(),
              ],
            ),
            const SizedBox(height: 10),
            if (!widget.isDriver && !isApproved) AdOffers(adOffers: _adOffers),
            const SizedBox(height: 10),
            if (!widget.isDriver) modifyAdButtons(),
          ],
        ),
      ),
      floatingActionButton: (widget.isDriver) ? giveOfferButton() : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Padding giveOfferButton() {
    return Padding(
      padding: const EdgeInsets.all(80.0),
      child: SizedBox(
        width: 400,
        height: 50,
        child: FloatingActionButton(
          backgroundColor: const Color.fromARGB(255, 31, 40, 51),
          onPressed: !isOffered ? _giveAnOffer : () {},
          child: Text(
            !isOffered ? 'Give an Offer' : 'Offer has already given',
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Padding modifyAdButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 15,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 5,
              ),
              shape: RoundedRectangleBorder(
                //to set border radius to button
                borderRadius: BorderRadius.circular(29),
              ),
              backgroundColor: thirdColor,
            ),
            onPressed: _updateAd,
            child: const Text(
              'Update Ad',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 30),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 5,
              ),
              shape: RoundedRectangleBorder(
                //to set border radius to button
                borderRadius: BorderRadius.circular(29),
              ),
              backgroundColor: thirdColor,
            ),
            onPressed: _deleteAd,
            child: const Text(
              'Delete Ad',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container cost() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 15,
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 45,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 5,
                    ),
                    child: Text(
                      'Cost',
                      style: GoogleFonts.lato(
                        color: const Color.fromARGB(255, 31, 40, 51),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(
                    '${widget.ad.cost}',
                    style: const TextStyle(fontSize: 15),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container loadContent() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 15,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 45,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 5,
                    ),
                    child: Text(
                      'Load Content',
                      style: GoogleFonts.lato(
                        color: const Color.fromARGB(255, 31, 40, 51),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(
                    widget.ad.loadContent,
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container advertisementId() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 15,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 45,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 5,
                    ),
                    child: Text(
                      'Advertisement Id',
                      style: GoogleFonts.lato(
                        color: const Color.fromARGB(255, 31, 40, 51),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(
                    widget.ad.id,
                    style: const TextStyle(fontSize: 15.5),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container arrivalDate() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 10,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 45,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 5,
                    ),
                    child: Text(
                      'Arrival date',
                      style: GoogleFonts.lato(
                        color: const Color.fromARGB(255, 31, 40, 51),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(
                    widget.ad.arrivalDate,
                    style: const TextStyle(fontSize: 15),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container departureDate() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 10,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 45,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 5,
                    ),
                    child: Text(
                      'Departure Date',
                      style: GoogleFonts.lato(
                        color: const Color.fromARGB(255, 31, 40, 51),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(
                    widget.ad.departureDate,
                    style: const TextStyle(fontSize: 15),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container departureAndArrival() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 10,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 5,
                  ),
                  child: Text(
                    'Departure',
                    style: GoogleFonts.lato(
                      color: const Color.fromARGB(255, 31, 40, 51),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  widget.ad.departure,
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
            const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 15,
                    horizontal: 73,
                  ),
                  child: Icon(
                    Icons.local_shipping,
                    color: Color.fromARGB(255, 31, 40, 51),
                    size: 27,
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 5,
                  ),
                  child: Text(
                    'Arrival',
                    style: GoogleFonts.lato(
                      color: const Color.fromARGB(255, 31, 40, 51),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  widget.ad.arrival,
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
