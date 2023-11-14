import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shipping_app/constants.dart';
import 'package:shipping_app/enums/value_enum.dart';
import 'package:shipping_app/models/ad.dart';
import 'package:shipping_app/widgets/create_app_bar.dart';

class UpdateDate extends StatefulWidget {
  const UpdateDate({super.key, required this.ad, required this.value});

  final Ad ad;
  final Values value;

  @override
  State<UpdateDate> createState() {
    return _UpdateDateState();
  }
}

class _UpdateDateState extends State<UpdateDate> {
  var _pickedArrivalDate = '';
  var _pickedDepartureDate = '';
  var _isUpdated = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: const CreateAppBar(
        header: 'Update Ad',
        isShowing: false,
        color: primaryColor,
      ),
      body: Container(
        height: size.height,
        width: double.infinity,
        child: Form(
          child: Column(
            children: [
              Row(
                children: [
                  if (widget.value == Values.departureDate)
                    updateDepartureDate(context, size),
                  if (widget.value == Values.arrivalDate)
                    updateArrivalDate(context, size),
                ],
              ),
              buttons(context, size),
            ],
          ),
        ),
      ),
    );
  }

  Padding buttons(BuildContext context, Size size) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 15,
        horizontal: 15,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          cancelButton(context),
          saveValueButton(context, size),
        ],
      ),
    );
  }

  TextButton cancelButton(BuildContext context) {
    return TextButton(
      onPressed: () {
        _isUpdated = false;
        Navigator.pop(context, _isUpdated);
      },
      child: const Text(
        'Cancel',
        style: TextStyle(
          color: thirdColor,
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Container saveValueButton(BuildContext context, Size size) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: SizedBox(
        width: size.width * 0.3,
        height: size.height * 0.05,
        child: ElevatedButton(
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
          onPressed: () {
            setState(() {
              _isUpdated = true;
            });

            if (widget.value == Values.departureDate) {
              FirebaseFirestore.instance
                  .collection('payloaderAds')
                  .doc(widget.ad.id)
                  .update({'departureDate': _pickedDepartureDate});
            }

            if (widget.value == Values.arrivalDate) {
              FirebaseFirestore.instance
                  .collection('payloaderAds')
                  .doc(widget.ad.id)
                  .update({'arrivalDate': _pickedArrivalDate});
            }

            Navigator.pop(context, _isUpdated);

            ScaffoldMessenger.of(context).clearSnackBars();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Value is updated.'),
              ),
            );
          },
          child: const Text(
            'Save Value',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Container updateArrivalDate(BuildContext context, Size size) {
    return Container(
      width: size.width * 0.99,
      child: Padding(
        padding: EdgeInsets.only(
          left: 10,
          right: 200,
          top: size.height * 0.3,
          bottom: 70,
        ),
        child: Column(
          children: [
            const Text(
              'Arrival Date',
              style: TextStyle(
                color: Color.fromARGB(255, 31, 40, 51),
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              children: [
                TextButton(
                  onPressed: () {
                    showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2023),
                      lastDate: DateTime(2101),
                    ).then((selectedDate) {
                      if (selectedDate != null) {
                        setState(() {
                          _pickedArrivalDate =
                              "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}";
                        });
                      }
                    });
                  },
                  child: Text(
                    _pickedArrivalDate == '' ? 'Pick Date' : 'Picked Date:',
                    style: TextStyle(
                      color: _pickedArrivalDate == ''
                          ? primaryColor
                          : const Color.fromARGB(255, 31, 40, 51),
                      fontSize: 13,
                    ),
                  ),
                ),
                Text(
                  _pickedArrivalDate,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color.fromARGB(255, 31, 40, 51),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Container updateDepartureDate(BuildContext context, Size size) {
    return Container(
      width: size.width * 0.99,
      child: Padding(
        padding: EdgeInsets.only(
          left: 10,
          right: 200,
          top: size.height * 0.3,
          bottom: 70,
        ),
        child: Column(
          children: [
            const Text(
              'Departure Date',
              style: TextStyle(
                color: Color.fromARGB(255, 31, 40, 51),
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              children: [
                TextButton(
                  onPressed: () {
                    showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2023),
                      lastDate: DateTime(2101),
                    ).then((selectedDate) {
                      if (selectedDate != null) {
                        setState(() {
                          _pickedDepartureDate =
                              "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}";
                        });
                      }
                    });
                  },
                  child: Text(
                    _pickedDepartureDate == '' ? 'Pick Date' : 'Picked Date:',
                    style: TextStyle(
                      color: _pickedDepartureDate == ''
                          ? primaryColor
                          : const Color.fromARGB(255, 31, 40, 51),
                      fontSize: 13,
                    ),
                  ),
                ),
                Text(
                  _pickedDepartureDate,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color.fromARGB(255, 31, 40, 51),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
