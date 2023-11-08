import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shipping_app/enums/pages_enum.dart';
import 'package:shipping_app/models/ad.dart';

class CreateAdCard extends StatefulWidget {
  const CreateAdCard(
      {super.key,
      required this.ads,
      required this.index,
      this.page,
      this.completeAd,
      this.isComplating = false});

  final List<Ad> ads;
  final int index;
  final Pages? page;
  final bool isComplating;
  final Function? completeAd;

  @override
  State<CreateAdCard> createState() => _CreateAdCardState();
}

class _CreateAdCardState extends State<CreateAdCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
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
                      'Departure',
                      style: GoogleFonts.lato(
                        color: const Color.fromARGB(255, 31, 40, 51),
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      bottom: 8,
                    ),
                    child: Text(widget.ads[widget.index].departure),
                  ),
                ],
              ),
              const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      left: 110,
                      right: 110,
                      bottom: 8,
                      top: 8,
                    ),
                    child: Icon(
                      Icons.local_shipping,
                      color: Color.fromARGB(255, 31, 40, 51),
                      size: 30,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      bottom: 8,
                      top: 8,
                    ),
                    child: Text(
                      'Arrival',
                      style: GoogleFonts.lato(
                        color: const Color.fromARGB(255, 31, 40, 51),
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      bottom: 8,
                    ),
                    child: Text(widget.ads[widget.index].arrival),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 8,
                      right: 8,
                      bottom: 8,
                      top: 8,
                    ),
                    child: Text(
                      'Advertisement Id',
                      style: GoogleFonts.lato(
                        color: const Color.fromARGB(255, 31, 40, 51),
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 8,
                      right: 8,
                      bottom: 8,
                    ),
                    child: Text(widget.ads[widget.index].id,
                        style: const TextStyle(fontSize: 12)),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          widget.page == Pages.completedOffers
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 8,
                            right: 8,
                            bottom: 8,
                            top: 8,
                          ),
                          child: Text(
                            'Offer Id',
                            style: GoogleFonts.lato(
                              color: const Color.fromARGB(255, 31, 40, 51),
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 8,
                            right: 8,
                            bottom: 8,
                          ),
                          child: Text(widget.ads[widget.index].offerId,
                              style: const TextStyle(fontSize: 12)),
                        ),
                      ],
                    ),
                  ],
                )
              : SizedBox(),
          const SizedBox(height: 10),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 8,
                      right: 8,
                      bottom: 8,
                      top: 8,
                    ),
                    child: Text(
                      'Cost',
                      style: GoogleFonts.lato(
                        color: const Color.fromARGB(255, 31, 40, 51),
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 8,
                      right: 8,
                      bottom: 8,
                    ),
                    child: Text('${widget.ads[widget.index].cost}',
                        style: const TextStyle(fontSize: 12)),
                  ),
                ],
              ),
              const SizedBox(width: 220),
              (widget.page == Pages.approvedOffers)
                  ? (!widget.isComplating)
                      ? ElevatedButton(
                          onPressed: () {
                            Ad ad = widget.ads[widget.index];
                            widget.completeAd!(ad);
                          },
                          child: const Text('Complete'))
                      : const CircularProgressIndicator()
                  : SizedBox(),
            ],
          ),
        ],
      ),
    );
  }
}
