import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shipping_app/constants.dart';
import 'package:shipping_app/enums/value_enum.dart';
import 'package:shipping_app/models/ad.dart';
import 'package:shipping_app/widgets/create_app_bar.dart';
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
      appBar: const CreateAppBar(
        header: 'Update Ad',
        isShowing: false,
        color: primaryColor,
      ),
      body: Form(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              updateDepartureAndArrival(context),
              updateDepartureDate(context),
              updateArrivalDate(context),
              updateLoadContent(context),
              updateCost(context),
            ],
          ),
        ),
      ),
    );
  }

  Container updateCost(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 10,
        ),
        child: Row(
          children: [
            TextButton(
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        UpdateValue(ad: widget.ad, value: Values.cost),
                  ),
                );

                Navigator.pop(context, result);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
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
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    Text(
                      '${widget.ad.cost}',
                      style: const TextStyle(
                        fontSize: 15,
                        color: secondaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container updateLoadContent(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 10,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TextButton(
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        UpdateValue(ad: widget.ad, value: Values.loadContent),
                  ),
                );

                Navigator.pop(context, result);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
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
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    Text(
                      widget.ad.loadContent,
                      style: const TextStyle(
                        fontSize: 16,
                        color: secondaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container updateArrivalDate(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 10,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TextButton(
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        UpdateDate(ad: widget.ad, value: Values.arrivalDate),
                  ),
                );

                Navigator.pop(context, result);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
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
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    Text(
                      widget.ad.arrivalDate,
                      style: const TextStyle(
                        fontSize: 15,
                        color: secondaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container updateDepartureDate(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 10,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TextButton(
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        UpdateDate(ad: widget.ad, value: Values.departureDate),
                  ),
                );

                Navigator.pop(context, result);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
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
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    Text(
                      widget.ad.departureDate,
                      style: const TextStyle(
                        fontSize: 15,
                        color: secondaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container updateDepartureAndArrival(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 10,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            departureUpdateButton(context),
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
            arrivalUpdateButton(context),
          ],
        ),
      ),
    );
  }

  TextButton arrivalUpdateButton(BuildContext context) {
    return TextButton(
      onPressed: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                UpdateValue(ad: widget.ad, value: Values.arrival),
          ),
        );

        Navigator.pop(context, result);
      },
      child: Column(
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
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
          Text(
            widget.ad.arrival,
            style: const TextStyle(
              fontSize: 16,
              color: secondaryColor,
            ),
          ),
        ],
      ),
    );
  }

  TextButton departureUpdateButton(BuildContext context) {
    return TextButton(
      onPressed: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                UpdateValue(ad: widget.ad, value: Values.departure),
          ),
        );

        Navigator.pop(context, result);
      },
      child: Column(
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
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
          Text(
            widget.ad.departure,
            style: const TextStyle(
              fontSize: 16,
              color: secondaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
