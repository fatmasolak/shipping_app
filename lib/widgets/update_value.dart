import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shipping_app/constants.dart';
import 'package:shipping_app/enums/value_enum.dart';
import 'package:shipping_app/models/ad.dart';
import 'package:shipping_app/widgets/create_app_bar.dart';

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
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: const CreateAppBar(
        header: 'Update Ad',
        isShowing: false,
        color: primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Center(
          child: Form(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  if (widget.value == Values.departure)
                    updateDepartureField(size),
                  if (widget.value == Values.arrival) updateArrivalField(size),
                  if (widget.value == Values.loadContent)
                    updateLoadContentField(size),
                  if (widget.value == Values.cost) updateCostField(size),
                  const SizedBox(height: 20),
                  buttons(context, size),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Row buttons(BuildContext context, Size size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        cancelButton(context),
        saveValueButton(context, size),
      ],
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

  Container updateCostField(Size size) {
    return Container(
      width: size.width * 0.99,
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 5,
      ),
      child: TextFormField(
        controller: _controller,
        style: const TextStyle(color: Color.fromARGB(255, 31, 40, 51)),
        decoration: const InputDecoration(
          hintText: 'Cost',
          focusColor: primaryColor,
        ),
      ),
    );
  }

  Container updateLoadContentField(Size size) {
    return Container(
      width: size.width * 0.99,
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 5,
      ),
      child: TextFormField(
        controller: _controller,
        style: const TextStyle(color: Color.fromARGB(255, 31, 40, 51)),
        decoration: const InputDecoration(
          hintText: 'Load Content',
          focusColor: primaryColor,
        ),
      ),
    );
  }

  Container updateArrivalField(Size size) {
    return Container(
      width: size.width * 0.99,
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 5,
      ),
      child: TextFormField(
        controller: _controller,
        style: const TextStyle(color: Color.fromARGB(255, 31, 40, 51)),
        decoration: const InputDecoration(
          hintText: 'Arrival',
          focusColor: primaryColor,
        ),
      ),
    );
  }

  Container updateDepartureField(Size size) {
    return Container(
      width: size.width * 0.99,
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 5,
      ),
      child: TextFormField(
        controller: _controller,
        decoration: const InputDecoration(
          hintText: 'Departure',
          focusColor: primaryColor,
        ),
      ),
    );
  }
}
