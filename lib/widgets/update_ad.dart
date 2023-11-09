import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shipping_app/enums/value_enum.dart';
import 'package:shipping_app/models/ad.dart';
import 'package:shipping_app/widgets/update_date.dart';
import 'package:shipping_app/widgets/update_value.dart';

class UpdateAd extends StatefulWidget {
  const UpdateAd({super.key, required this.ad});

  final Ad ad;

  @override
  State<UpdateAd> createState() {
    return _CreateAdState();
  }
}

class _CreateAdState extends State<UpdateAd> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white, //change your color here
        ),
        backgroundColor: const Color.fromARGB(255, 31, 40, 51),
        title: const Text(
          'Update Ad',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Center(
          child: Form(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UpdateValue(
                                  ad: widget.ad, value: Values.departure),
                            ),
                          );

                          Navigator.pop(context, result);
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Departure',
                              style: GoogleFonts.lato(
                                color: const Color.fromARGB(255, 31, 40, 51),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              widget.ad.departure,
                            ),
                          ],
                        ),
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
                              top: 10,
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
                      ElevatedButton(
                        onPressed: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UpdateValue(
                                  ad: widget.ad, value: Values.arrival),
                            ),
                          );

                          Navigator.pop(context, result);
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'Arrival',
                              style: GoogleFonts.lato(
                                color: const Color.fromARGB(255, 31, 40, 51),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              widget.ad.arrival,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UpdateDate(
                                  ad: widget.ad, value: Values.departureDate),
                            ),
                          );

                          Navigator.pop(context, result);
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Departure Date',
                              style: GoogleFonts.lato(
                                color: const Color.fromARGB(255, 31, 40, 51),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              widget.ad.departureDate,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UpdateDate(
                                  ad: widget.ad, value: Values.arrivalDate),
                            ),
                          );

                          Navigator.pop(context, result);
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Arrival date',
                              style: GoogleFonts.lato(
                                color: const Color.fromARGB(255, 31, 40, 51),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              widget.ad.arrivalDate,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UpdateValue(
                                  ad: widget.ad, value: Values.loadContent),
                            ),
                          );

                          Navigator.pop(context, result);
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Load Content',
                              style: GoogleFonts.lato(
                                color: const Color.fromARGB(255, 31, 40, 51),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              widget.ad.loadContent,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UpdateValue(
                                  ad: widget.ad, value: Values.cost),
                            ),
                          );

                          Navigator.pop(context, result);
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Cost',
                              style: GoogleFonts.lato(
                                color: const Color.fromARGB(255, 31, 40, 51),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${widget.ad.cost}',
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
