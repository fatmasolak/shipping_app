import 'package:flutter/material.dart';
import 'package:shipping_app/constants.dart';
import 'package:shipping_app/models/ad.dart';
import 'package:shipping_app/widgets/create_app_bar.dart';

class CreateAd extends StatefulWidget {
  const CreateAd({super.key});

  @override
  State<CreateAd> createState() {
    return _CreateAdState();
  }
}

class _CreateAdState extends State<CreateAd> {
  final _formKey = GlobalKey<FormState>();
  var _pickedDepartureDate = '';
  var _pickedArrivalDate = '';
  var _enteredDeparture = '';
  var _enteredArrival = '';
  var _enteredDepartureDate = '';
  var _enteredArrivalDate = '';
  var _enteredLoadContent = '';
  var _enteredCost = 1;

  var _isSending = false;

  Ad newAd = const Ad(
    departure: '',
    arrival: '',
    departureDate: '',
    arrivalDate: '',
    loadContent: '',
    cost: 0,
    id: '',
    offerId: '',
  );

  void _saveAd() async {
    final isValid = _formKey.currentState!.validate();

    if (!isValid) {
      return;
    }

    _formKey.currentState!.save();

    setState(() {
      _enteredArrivalDate = _pickedArrivalDate;
      _enteredDepartureDate = _pickedDepartureDate;
      _isSending = true;

      newAd = Ad(
        departure: _enteredDeparture,
        arrival: _enteredArrival,
        departureDate: _enteredDepartureDate,
        arrivalDate: _enteredArrivalDate,
        loadContent: _enteredLoadContent,
        cost: _enteredCost,
        id: '',
        offerId: '',
      );
    });

    Navigator.pop(context, newAd);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: const CreateAppBar(
        header: 'Create New Ad',
        isShowing: false,
        color: primaryColor,
      ),
      body: Container(
        height: size.height,
        width: double.infinity,
        child: Stack(
          alignment: Alignment.center,
          children: [
            SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    departureField(size),
                    arrivalField(size),
                    const SizedBox(height: 20),
                    datesField(context, size),
                    loadContentField(size),
                    costField(size),
                    const SizedBox(height: 40),
                    buttonsField(size),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container buttonsField(Size size) {
    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 25,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          resetButton(size),
          createAdButton(size),
        ],
      ),
    );
  }

  Container createAdButton(Size size) {
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
          onPressed: _isSending ? null : _saveAd,
          child: _isSending
              ? const SizedBox(
                  height: 16,
                  width: 16,
                  child: CircularProgressIndicator(),
                )
              : const Text(
                  'Create Ad',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
        ),
      ),
    );
  }

  TextButton resetButton(Size size) {
    return TextButton(
      onPressed: _isSending
          ? null
          : () {
              _formKey.currentState!.reset();
            },
      child: const Text(
        'Reset',
        style: TextStyle(
          color: thirdColor,
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Container costField(Size size) {
    return Container(
      width: size.width * 0.99,
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 5,
      ),
      child: TextFormField(
        decoration: const InputDecoration(
          hintText: 'Cost',
          focusColor: primaryColor,
        ),
        keyboardType: TextInputType.number,
        validator: (value) {
          if (value == null ||
              value.isEmpty ||
              int.tryParse(value) == null ||
              int.tryParse(value)! <= 0) {
            return 'Must be a valid, positive number.';
          }
          return null;
        },
        onSaved: (value) {
          _enteredCost = int.parse(value!);
        },
      ),
    );
  }

  Container loadContentField(Size size) {
    return Container(
      width: size.width * 0.99,
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 5,
      ),
      child: TextFormField(
        style: const TextStyle(color: Color.fromARGB(255, 31, 40, 51)),
        decoration: const InputDecoration(
          hintText: 'Load Content',
          focusColor: primaryColor,
        ),
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'Please enter content of your load';
          }

          return null;
        },
        onSaved: (value) {
          _enteredLoadContent = value!;
        },
      ),
    );
  }

  Container datesField(BuildContext context, Size size) {
    return Container(
      width: size.width,
      margin: const EdgeInsets.symmetric(vertical: 30),
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 5,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          departureDateField(context, size),
          arrivalDateField(context, size),
        ],
      ),
    );
  }

  Container arrivalDateField(BuildContext context, Size size) {
    return Container(
      width: size.width * 0.45,
      child: Column(
        children: [
          const Text(
            'Arrival Date',
            textAlign: TextAlign.left,
            style: TextStyle(
              color: Color.fromARGB(255, 31, 40, 51),
              fontSize: 13.5,
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
    );
  }

  Container departureDateField(BuildContext context, Size size) {
    return Container(
      width: size.width * 0.45,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Text(
            'Departure Date',
            textAlign: TextAlign.left,
            style: TextStyle(
              color: Color.fromARGB(255, 31, 40, 51),
              fontSize: 13.5,
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
    );
  }

  Container arrivalField(Size size) {
    return Container(
      width: size.width * 0.99,
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 5,
      ),
      child: TextFormField(
        style: const TextStyle(color: Color.fromARGB(255, 31, 40, 51)),
        decoration: const InputDecoration(
          hintText: 'Arrival',
          focusColor: primaryColor,
        ),
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'Please enter arrival location';
          }

          return null;
        },
        onSaved: (value) {
          _enteredArrival = value!;
        },
      ),
    );
  }

  Container departureField(Size size) {
    return Container(
      width: size.width * 0.99,
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 5,
      ),
      child: TextFormField(
        style: const TextStyle(color: Color.fromARGB(255, 31, 40, 51)),
        decoration: const InputDecoration(
          hintText: 'Departure',
          focusColor: primaryColor,
        ),
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'Please enter departure location';
          }

          return null;
        },
        onSaved: (value) {
          _enteredDeparture = value!;
        },
      ),
    );
  }
}
