import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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

                    ScaffoldMessenger.of(context).clearSnackBars();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Offer has approved.'),
                      ),
                    );

                    setState(() {
                      if (result) {
                        _isApproved = true;
                      }
                    });
                  },
                  child: Card(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
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
                                      color:
                                          const Color.fromARGB(255, 31, 40, 51),
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    bottom: 8,
                                  ),
                                  child:
                                      Text(widget.adOffers[index].driverName),
                                ),
                              ],
                            ),
                            const SizedBox(width: 100),
                            Column(
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
                                      color:
                                          const Color.fromARGB(255, 31, 40, 51),
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
                                      widget.adOffers[index].driverSurname),
                                ),
                              ],
                            ),
                          ],
                        ),
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
}
