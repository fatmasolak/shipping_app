import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shipping_app/enums/value_enum.dart';
import 'package:shipping_app/models/ad.dart';

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
              child: Row(
                children: [
                  if (widget.value == Values.departureDate)
                    Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(right: 20),
                          child: Text(
                            'Departure Date',
                            style: TextStyle(
                              color: Color.fromARGB(255, 31, 40, 51),
                              fontSize: 13.5,
                            ),
                          ),
                        ),
                        const SizedBox(height: 5),
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
                                _pickedDepartureDate == ''
                                    ? 'Pick Date'
                                    : 'Picked Date:',
                                style: TextStyle(
                                  color: _pickedDepartureDate == ''
                                      ? const Color.fromARGB(255, 102, 252, 241)
                                      : const Color.fromARGB(255, 31, 40, 51),
                                  fontSize: 13,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 80,
                              child: Text(
                                _pickedDepartureDate,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Color.fromARGB(255, 31, 40, 51),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  if (widget.value == Values.arrivalDate)
                    Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(right: 20),
                          child: Text(
                            'Arrival Date',
                            style: TextStyle(
                              color: Color.fromARGB(255, 31, 40, 51),
                              fontSize: 13.5,
                            ),
                          ),
                        ),
                        const SizedBox(height: 5),
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
                                _pickedArrivalDate == ''
                                    ? 'Pick Date'
                                    : 'Picked Date:',
                                style: TextStyle(
                                  color: _pickedArrivalDate == ''
                                      ? const Color.fromARGB(255, 102, 252, 241)
                                      : const Color.fromARGB(255, 31, 40, 51),
                                  fontSize: 13,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 80,
                              child: Text(
                                _pickedArrivalDate,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Color.fromARGB(255, 31, 40, 51),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  const SizedBox(height: 60),
                  Padding(
                    padding: const EdgeInsets.only(top: 140),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () {
                            _isUpdated = false;
                            Navigator.pop(context, _isUpdated);
                          },
                          child: const Text('Cancel'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _isUpdated = true;
                            });

                            if (widget.value == Values.departureDate) {
                              FirebaseFirestore.instance
                                  .collection('payloaderAds')
                                  .doc(widget.ad.id)
                                  .update(
                                      {'departureDate': _pickedDepartureDate});
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
                          child: const Text('Save Value'),
                        ),
                      ],
                    ),
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
