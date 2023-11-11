import 'package:flutter/material.dart';
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
    return Scaffold(
      appBar: const CreateAppBar(header: 'Create New Ad', isShowing: false),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Center(
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  departureField(),
                  const SizedBox(height: 20),
                  arrivalField(),
                  const SizedBox(height: 30),
                  datesField(context),
                  const SizedBox(height: 10),
                  loadContentField(),
                  const SizedBox(height: 20),
                  costField(),
                  const SizedBox(height: 40),
                  buttonsField(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Row buttonsField() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        resetButton(),
        createAdButton(),
      ],
    );
  }

  ElevatedButton createAdButton() {
    return ElevatedButton(
      onPressed: _isSending ? null : _saveAd,
      child: _isSending
          ? const SizedBox(
              height: 16,
              width: 16,
              child: CircularProgressIndicator(),
            )
          : const Text('Create Ad'),
    );
  }

  TextButton resetButton() {
    return TextButton(
      onPressed: _isSending
          ? null
          : () {
              _formKey.currentState!.reset();
            },
      child: const Text('Reset'),
    );
  }

  TextFormField costField() {
    return TextFormField(
      decoration: const InputDecoration(
        label: Text('Cost'),
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
    );
  }

  TextFormField loadContentField() {
    return TextFormField(
      style: const TextStyle(color: Color.fromARGB(255, 31, 40, 51)),
      decoration: const InputDecoration(
        labelStyle: TextStyle(
          color: Color.fromARGB(255, 31, 40, 51),
        ),
        labelText: 'Load Content',
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
    );
  }

  Row datesField(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        departureDateField(context),
        arrivalDateField(context),
      ],
    );
  }

  Expanded arrivalDateField(BuildContext context) {
    return Expanded(
      child: Column(
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
                  _pickedArrivalDate == '' ? 'Pick Date' : 'Picked Date:',
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
    );
  }

  Expanded departureDateField(BuildContext context) {
    return Expanded(
      child: Column(
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
                  _pickedDepartureDate == '' ? 'Pick Date' : 'Picked Date:',
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
    );
  }

  TextFormField arrivalField() {
    return TextFormField(
      style: const TextStyle(color: Color.fromARGB(255, 31, 40, 51)),
      decoration: const InputDecoration(
        labelStyle: TextStyle(
          color: Color.fromARGB(255, 31, 40, 51),
        ),
        labelText: 'Arrival',
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
    );
  }

  TextFormField departureField() {
    return TextFormField(
      style: const TextStyle(color: Color.fromARGB(255, 31, 40, 51)),
      decoration: const InputDecoration(
        labelStyle: TextStyle(
          color: Color.fromARGB(255, 31, 40, 51),
        ),
        labelText: 'Departure',
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
    );
  }
}
