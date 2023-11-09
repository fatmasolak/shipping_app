import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shipping_app/enums/value_enum.dart';
import 'package:shipping_app/models/ad.dart';

class UpdateValue extends StatefulWidget {
  const UpdateValue({super.key, required this.ad, required this.value});

  final Ad ad;
  final Values value;

  @override
  State<UpdateValue> createState() {
    return _UpdateValueState();
  }
}

class _UpdateValueState extends State<UpdateValue> {
  final TextEditingController _controller = TextEditingController();

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
              child: Column(
                children: [
                  if (widget.value == Values.departure)
                    TextFormField(
                      controller: _controller,
                      style: const TextStyle(
                          color: Color.fromARGB(255, 31, 40, 51)),
                      decoration: const InputDecoration(
                        labelStyle: TextStyle(
                          color: Color.fromARGB(255, 31, 40, 51),
                        ),
                        labelText: 'Departure',
                      ),
                    ),
                  if (widget.value == Values.arrival)
                    TextFormField(
                      controller: _controller,
                      style: const TextStyle(
                          color: Color.fromARGB(255, 31, 40, 51)),
                      decoration: const InputDecoration(
                        labelStyle: TextStyle(
                          color: Color.fromARGB(255, 31, 40, 51),
                        ),
                        labelText: 'Arrival',
                      ),
                    ),
                  if (widget.value == Values.loadContent)
                    TextFormField(
                      controller: _controller,
                      style: const TextStyle(
                          color: Color.fromARGB(255, 31, 40, 51)),
                      decoration: const InputDecoration(
                        labelStyle: TextStyle(
                          color: Color.fromARGB(255, 31, 40, 51),
                        ),
                        labelText: 'Load Content',
                      ),
                    ),
                  if (widget.value == Values.cost)
                    TextFormField(
                      controller: _controller,
                      style: const TextStyle(
                          color: Color.fromARGB(255, 31, 40, 51)),
                      decoration: const InputDecoration(
                        labelStyle: TextStyle(
                          color: Color.fromARGB(255, 31, 40, 51),
                        ),
                        labelText: 'Cost',
                      ),
                    ),
                  const SizedBox(height: 20),
                  Row(
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
                          String enteredValue = _controller.text;

                          setState(() {
                            _isUpdated = true;
                          });

                          if (widget.value == Values.departure) {
                            FirebaseFirestore.instance
                                .collection('payloaderAds')
                                .doc(widget.ad.id)
                                .update({'departure': enteredValue});
                          }

                          if (widget.value == Values.arrival) {
                            FirebaseFirestore.instance
                                .collection('payloaderAds')
                                .doc(widget.ad.id)
                                .update({'arrival': enteredValue});
                          }

                          if (widget.value == Values.loadContent) {
                            FirebaseFirestore.instance
                                .collection('payloaderAds')
                                .doc(widget.ad.id)
                                .update({'loadContent': enteredValue});
                          }

                          if (widget.value == Values.cost) {
                            if (int.tryParse(enteredValue) == null ||
                                int.tryParse(enteredValue)! <= 0) {
                              ScaffoldMessenger.of(context).clearSnackBars();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Please enter positive number'),
                                ),
                              );
                              return;
                            }

                            FirebaseFirestore.instance
                                .collection('payloaderAds')
                                .doc(widget.ad.id)
                                .update({'cost': int.tryParse(enteredValue)});
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
