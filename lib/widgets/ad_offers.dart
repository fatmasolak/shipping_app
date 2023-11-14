import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shipping_app/constants.dart';
import 'package:shipping_app/models/offer.dart';
import 'package:shipping_app/screens/driver_screens/offer_details.dart';

class AdOffers extends StatefulWidget {
  const AdOffers({super.key, required this.adOffers});

  final List<Offer> adOffers;

  @override
  State<AdOffers> createState() => _AdOffersState();
}

class _AdOffersState extends State<AdOffers> {
  var _isApproved = false;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: widget.adOffers.length,
        itemBuilder: (context, index) {
          if (!_isApproved) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OfferDetails(
                          offer: widget.adOffers[index],
                        ),
                      ),
                    );

                    setState(() {
                      if (result) {
                        _isApproved = true;
                      }
                    });
                  },
                  child: Card(
                    color: primaryLightColor,
                    child: Column(
                      children: [
                        driverInformations(index),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }
          return const SizedBox();
        });
  }

  Row driverInformations(int index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        driverName(index),
        const SizedBox(width: 100),
        driverSurname(index),
      ],
    );
  }

  Column driverSurname(int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            bottom: 8,
            top: 8,
          ),
          child: Text(
            'Driver Surname',
            style: GoogleFonts.lato(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            bottom: 8,
          ),
          child: Text(
            widget.adOffers[index].driverSurname,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Column driverName(int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            bottom: 8,
            top: 8,
          ),
          child: Text(
            'Driver Name',
            style: GoogleFonts.lato(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            bottom: 8,
          ),
          child: Text(
            widget.adOffers[index].driverName,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
