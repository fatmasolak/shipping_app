import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shipping_app/models/ad.dart';

class AdDetails extends StatelessWidget {
  const AdDetails({super.key, required this.ad});

  final Ad ad;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white, //change your color here
        ),
        backgroundColor: const Color.fromARGB(255, 31, 40, 51),
        title: Text(
          ad.id,
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 25,
                                bottom: 8,
                                top: 40,
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
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 25,
                                bottom: 8,
                              ),
                              child: Text(
                                ad.departure,
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 65),
                        const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                left: 8,
                                right: 8,
                                bottom: 8,
                                top: 40,
                              ),
                              child: Icon(
                                Icons.local_shipping,
                                color: Color.fromARGB(255, 31, 40, 51),
                                size: 27,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 65),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                bottom: 8,
                                top: 40,
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
                            Padding(
                              padding: const EdgeInsets.only(
                                bottom: 8,
                              ),
                              child: Text(
                                ad.arrival,
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 25,
                                bottom: 8,
                                top: 8,
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
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 25,
                                bottom: 8,
                              ),
                              child: Text(
                                ad.departureDate,
                                style: const TextStyle(fontSize: 15),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 25,
                                bottom: 8,
                                top: 8,
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
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 25,
                                bottom: 8,
                              ),
                              child: Text(
                                ad.arrivalDate,
                                style: const TextStyle(fontSize: 15),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 25,
                                right: 8,
                                bottom: 8,
                                top: 8,
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
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 25,
                                right: 8,
                                bottom: 8,
                              ),
                              child: Text(
                                ad.id,
                                style: const TextStyle(fontSize: 15.5),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 25,
                                right: 8,
                                bottom: 8,
                                top: 8,
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
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 25,
                                right: 8,
                                bottom: 8,
                              ),
                              child: Text(
                                ad.loadContent,
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 25,
                                right: 8,
                                bottom: 8,
                                top: 8,
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
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 25,
                                right: 8,
                                bottom: 8,
                              ),
                              child: Text(
                                '${ad.cost}',
                                style: const TextStyle(fontSize: 15),
                              ),
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
        ],
      ),
    );
  }
}
