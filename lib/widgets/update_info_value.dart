import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:shipping_app/constants.dart';
import 'package:shipping_app/enums/info_value.dart';

import 'package:shipping_app/widgets/create_app_bar.dart';
import 'package:shipping_app/widgets/user_image_picker.dart';

class UpdateInfoValue extends StatefulWidget {
  const UpdateInfoValue(
      {super.key,
      required this.userId,
      required this.value,
      required this.userType});

  final InfoValue value;
  final String userId;
  final String userType;

  @override
  State<UpdateInfoValue> createState() {
    return _UpdateInfoValueState();
  }
}

class _UpdateInfoValueState extends State<UpdateInfoValue> {
  final TextEditingController _controller = TextEditingController();

  var _isUpdated = false;
  var _pickedDate = '';
  var _pickedImagePath = '';

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
                  if (widget.value == InfoValue.name) updateNameField(size),
                  if (widget.value == InfoValue.surname)
                    updateSurnameField(size),
                  if (widget.value == InfoValue.phone) updatePhoneField(size),
                  if (widget.value == InfoValue.companyName)
                    updateCompanyNameField(size),
                  if (widget.value == InfoValue.companyEmail)
                    updateCompanyEmailField(size),
                  if (widget.value == InfoValue.expireDateOfDriverLicence)
                    updateExpireDateOfLicence(context, size),
                  if (widget.value == InfoValue.driverLicence)
                    updateDriverLicence(),
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

  Padding buttons(BuildContext context, Size size) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 15,
        horizontal: 15,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: (widget.value == InfoValue.expireDateOfDriverLicence)
            ? MainAxisAlignment.end
            : MainAxisAlignment.center,
        children: [
          cancelButton(context),
          saveValueButton(context, size),
        ],
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
            String enteredValue = _controller.text;

            setState(() {
              _isUpdated = true;
            });

            if (widget.value == InfoValue.name) {
              if (widget.userType == 'payloader') {
                FirebaseFirestore.instance
                    .collection('payloader')
                    .doc(widget.userId)
                    .update({'name': enteredValue});
              }

              if (widget.userType == 'driver') {
                FirebaseFirestore.instance
                    .collection('driver')
                    .doc(widget.userId)
                    .update({'name': enteredValue});

                void updateOffers() async {
                  //because offers saved with driver information, we should update their driver informations when driver update own information
                  QuerySnapshot querySnapshot = await FirebaseFirestore.instance
                      .collection('driverOffers')
                      .get();

                  if (querySnapshot.docs.isNotEmpty) {
                    for (var doc in querySnapshot.docs) {
                      Map<String, dynamic> data =
                          doc.data() as Map<String, dynamic>;

                      if (data['driverId'] == widget.userId) {
                        FirebaseFirestore.instance
                            .collection('driverOffers')
                            .doc(data['offerId'])
                            .update({'driverName': enteredValue});
                      }
                    }
                  }

                  QuerySnapshot querySnapshotApproved = await FirebaseFirestore
                      .instance
                      .collection('approvedOffers')
                      .get();

                  if (querySnapshotApproved.docs.isNotEmpty) {
                    for (var doc in querySnapshotApproved.docs) {
                      Map<String, dynamic> data =
                          doc.data() as Map<String, dynamic>;

                      if (data['driverId'] == widget.userId) {
                        FirebaseFirestore.instance
                            .collection('approvedOffers')
                            .doc(data['offerId'])
                            .update({'driverName': enteredValue});
                      }
                    }
                  }

                  QuerySnapshot querySnapshotCompleted = await FirebaseFirestore
                      .instance
                      .collection('completedOffers')
                      .get();

                  if (querySnapshotCompleted.docs.isNotEmpty) {
                    for (var doc in querySnapshotCompleted.docs) {
                      Map<String, dynamic> data =
                          doc.data() as Map<String, dynamic>;

                      if (data['driverId'] == widget.userId) {
                        FirebaseFirestore.instance
                            .collection('completedOffers')
                            .doc(data['offerId'])
                            .update({'driverName': enteredValue});
                      }
                    }
                  }

                  QuerySnapshot querySnapshotDeleted = await FirebaseFirestore
                      .instance
                      .collection('deletedOffers')
                      .get();

                  if (querySnapshotDeleted.docs.isNotEmpty) {
                    for (var doc in querySnapshotDeleted.docs) {
                      Map<String, dynamic> data =
                          doc.data() as Map<String, dynamic>;

                      if (data['driverId'] == widget.userId) {
                        FirebaseFirestore.instance
                            .collection('deletedOffers')
                            .doc(data['offerId'])
                            .update({'driverName': enteredValue});
                      }
                    }
                  }
                }

                updateOffers();
              }
            }

            if (widget.value == InfoValue.surname) {
              if (widget.userType == 'payloader') {
                FirebaseFirestore.instance
                    .collection('payloader')
                    .doc(widget.userId)
                    .update({'surname': enteredValue});
              }

              if (widget.userType == 'driver') {
                FirebaseFirestore.instance
                    .collection('driver')
                    .doc(widget.userId)
                    .update({'surname': enteredValue});

                void updateOffers() async {
                  QuerySnapshot querySnapshot = await FirebaseFirestore.instance
                      .collection('driverOffers')
                      .get();

                  if (querySnapshot.docs.isNotEmpty) {
                    for (var doc in querySnapshot.docs) {
                      Map<String, dynamic> data =
                          doc.data() as Map<String, dynamic>;

                      if (data['driverId'] == widget.userId) {
                        FirebaseFirestore.instance
                            .collection('driverOffers')
                            .doc(data['offerId'])
                            .update({'driverSurname': enteredValue});
                      }
                    }
                  }

                  QuerySnapshot querySnapshotApproved = await FirebaseFirestore
                      .instance
                      .collection('approvedOffers')
                      .get();

                  if (querySnapshotApproved.docs.isNotEmpty) {
                    for (var doc in querySnapshotApproved.docs) {
                      Map<String, dynamic> data =
                          doc.data() as Map<String, dynamic>;

                      if (data['driverId'] == widget.userId) {
                        FirebaseFirestore.instance
                            .collection('approvedOffers')
                            .doc(data['offerId'])
                            .update({'driverSurname': enteredValue});
                      }
                    }
                  }

                  QuerySnapshot querySnapshotCompleted = await FirebaseFirestore
                      .instance
                      .collection('completedOffers')
                      .get();

                  if (querySnapshotCompleted.docs.isNotEmpty) {
                    for (var doc in querySnapshotCompleted.docs) {
                      Map<String, dynamic> data =
                          doc.data() as Map<String, dynamic>;

                      if (data['driverId'] == widget.userId) {
                        FirebaseFirestore.instance
                            .collection('completedOffers')
                            .doc(data['offerId'])
                            .update({'driverSurname': enteredValue});
                      }
                    }
                  }

                  QuerySnapshot querySnapshotDeleted = await FirebaseFirestore
                      .instance
                      .collection('deletedOffers')
                      .get();

                  if (querySnapshotDeleted.docs.isNotEmpty) {
                    for (var doc in querySnapshotDeleted.docs) {
                      Map<String, dynamic> data =
                          doc.data() as Map<String, dynamic>;

                      if (data['driverId'] == widget.userId) {
                        FirebaseFirestore.instance
                            .collection('deletedOffers')
                            .doc(data['offerId'])
                            .update({'driverSurname': enteredValue});
                      }
                    }
                  }
                }

                updateOffers();
              }
            }

            if (widget.value == InfoValue.phone) {
              if (int.tryParse(enteredValue) == null ||
                  int.tryParse(enteredValue)! <= 0) {
                ScaffoldMessenger.of(context).clearSnackBars();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please enter valid number'),
                  ),
                );
                return;
              }

              if (widget.userType == 'payloader') {
                FirebaseFirestore.instance
                    .collection('payloader')
                    .doc(widget.userId)
                    .update({'phone': enteredValue});
              }

              if (widget.userType == 'driver') {
                FirebaseFirestore.instance
                    .collection('driver')
                    .doc(widget.userId)
                    .update({'phone': enteredValue});

                void updateOffers() async {
                  QuerySnapshot querySnapshot = await FirebaseFirestore.instance
                      .collection('driverOffers')
                      .get();

                  if (querySnapshot.docs.isNotEmpty) {
                    for (var doc in querySnapshot.docs) {
                      Map<String, dynamic> data =
                          doc.data() as Map<String, dynamic>;

                      if (data['driverId'] == widget.userId) {
                        FirebaseFirestore.instance
                            .collection('driverOffers')
                            .doc(data['offerId'])
                            .update({'driverPhone': enteredValue});
                      }
                    }
                  }

                  QuerySnapshot querySnapshotApproved = await FirebaseFirestore
                      .instance
                      .collection('approvedOffers')
                      .get();

                  if (querySnapshotApproved.docs.isNotEmpty) {
                    for (var doc in querySnapshotApproved.docs) {
                      Map<String, dynamic> data =
                          doc.data() as Map<String, dynamic>;

                      if (data['driverId'] == widget.userId) {
                        FirebaseFirestore.instance
                            .collection('approvedOffers')
                            .doc(data['offerId'])
                            .update({'driverPhone': enteredValue});
                      }
                    }
                  }

                  QuerySnapshot querySnapshotCompleted = await FirebaseFirestore
                      .instance
                      .collection('completedOffers')
                      .get();

                  if (querySnapshotCompleted.docs.isNotEmpty) {
                    for (var doc in querySnapshotCompleted.docs) {
                      Map<String, dynamic> data =
                          doc.data() as Map<String, dynamic>;

                      if (data['driverId'] == widget.userId) {
                        FirebaseFirestore.instance
                            .collection('completedOffers')
                            .doc(data['offerId'])
                            .update({'driverPhone': enteredValue});
                      }
                    }
                  }

                  QuerySnapshot querySnapshotDeleted = await FirebaseFirestore
                      .instance
                      .collection('deletedOffers')
                      .get();

                  if (querySnapshotDeleted.docs.isNotEmpty) {
                    for (var doc in querySnapshotDeleted.docs) {
                      Map<String, dynamic> data =
                          doc.data() as Map<String, dynamic>;

                      if (data['driverId'] == widget.userId) {
                        FirebaseFirestore.instance
                            .collection('deletedOffers')
                            .doc(data['offerId'])
                            .update({'driverPhone': enteredValue});
                      }
                    }
                  }
                }

                updateOffers();
              }
            }

            if (widget.value == InfoValue.companyName) {
              FirebaseFirestore.instance
                  .collection('payloader')
                  .doc(widget.userId)
                  .update({'companyName': enteredValue});
            }

            if (widget.value == InfoValue.companyEmail) {
              if (enteredValue.trim().isEmpty || !enteredValue.contains('@')) {
                ScaffoldMessenger.of(context).clearSnackBars();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please enter positive number'),
                  ),
                );
                return;
              }

              FirebaseFirestore.instance
                  .collection('payloader')
                  .doc(widget.userId)
                  .update({'companyEmail': enteredValue});
            }

            if (widget.value == InfoValue.expireDateOfDriverLicence) {
              FirebaseFirestore.instance
                  .collection('driver')
                  .doc(widget.userId)
                  .update({'expireDateOfLicence': _pickedDate});

              void updateOffers() async {
                QuerySnapshot querySnapshot = await FirebaseFirestore.instance
                    .collection('driverOffers')
                    .get();

                if (querySnapshot.docs.isNotEmpty) {
                  for (var doc in querySnapshot.docs) {
                    Map<String, dynamic> data =
                        doc.data() as Map<String, dynamic>;

                    if (data['driverId'] == widget.userId) {
                      FirebaseFirestore.instance
                          .collection('driverOffers')
                          .doc(data['offerId'])
                          .update({'driverExpireDateOfLicence': _pickedDate});
                    }
                  }
                }

                QuerySnapshot querySnapshotApproved = await FirebaseFirestore
                    .instance
                    .collection('approvedOffers')
                    .get();

                if (querySnapshotApproved.docs.isNotEmpty) {
                  for (var doc in querySnapshotApproved.docs) {
                    Map<String, dynamic> data =
                        doc.data() as Map<String, dynamic>;

                    if (data['driverId'] == widget.userId) {
                      FirebaseFirestore.instance
                          .collection('approvedOffers')
                          .doc(data['offerId'])
                          .update({'driverExpireDateOfLicence': _pickedDate});
                    }
                  }
                }

                QuerySnapshot querySnapshotCompleted = await FirebaseFirestore
                    .instance
                    .collection('completedOffers')
                    .get();

                if (querySnapshotCompleted.docs.isNotEmpty) {
                  for (var doc in querySnapshotCompleted.docs) {
                    Map<String, dynamic> data =
                        doc.data() as Map<String, dynamic>;

                    if (data['driverId'] == widget.userId) {
                      FirebaseFirestore.instance
                          .collection('completedOffers')
                          .doc(data['offerId'])
                          .update({'driverExpireDateOfLicence': _pickedDate});
                    }
                  }
                }

                QuerySnapshot querySnapshotDeleted = await FirebaseFirestore
                    .instance
                    .collection('deletedOffers')
                    .get();

                if (querySnapshotDeleted.docs.isNotEmpty) {
                  for (var doc in querySnapshotDeleted.docs) {
                    Map<String, dynamic> data =
                        doc.data() as Map<String, dynamic>;

                    if (data['driverId'] == widget.userId) {
                      FirebaseFirestore.instance
                          .collection('deletedOffers')
                          .doc(data['offerId'])
                          .update({'driverExpireDateOfLicence': _pickedDate});
                    }
                  }
                }
              }

              updateOffers();
            }

            if (widget.value == InfoValue.driverLicence) {
              FirebaseFirestore.instance
                  .collection('driver')
                  .doc(widget.userId)
                  .update({'driverLicence': _pickedImagePath});

              void updateOffers() async {
                QuerySnapshot querySnapshot = await FirebaseFirestore.instance
                    .collection('driverOffers')
                    .get();

                if (querySnapshot.docs.isNotEmpty) {
                  for (var doc in querySnapshot.docs) {
                    Map<String, dynamic> data =
                        doc.data() as Map<String, dynamic>;

                    if (data['driverId'] == widget.userId) {
                      FirebaseFirestore.instance
                          .collection('driverOffers')
                          .doc(data['offerId'])
                          .update({'driverLicence': _pickedImagePath});
                    }
                  }
                }

                QuerySnapshot querySnapshotApproved = await FirebaseFirestore
                    .instance
                    .collection('approvedOffers')
                    .get();

                if (querySnapshotApproved.docs.isNotEmpty) {
                  for (var doc in querySnapshotApproved.docs) {
                    Map<String, dynamic> data =
                        doc.data() as Map<String, dynamic>;

                    if (data['driverId'] == widget.userId) {
                      FirebaseFirestore.instance
                          .collection('approvedOffers')
                          .doc(data['offerId'])
                          .update({'driverLicence': _pickedImagePath});
                    }
                  }
                }

                QuerySnapshot querySnapshotCompleted = await FirebaseFirestore
                    .instance
                    .collection('completedOffers')
                    .get();

                if (querySnapshotCompleted.docs.isNotEmpty) {
                  for (var doc in querySnapshotCompleted.docs) {
                    Map<String, dynamic> data =
                        doc.data() as Map<String, dynamic>;

                    if (data['driverId'] == widget.userId) {
                      FirebaseFirestore.instance
                          .collection('completedOffers')
                          .doc(data['offerId'])
                          .update({'driverLicence': _pickedImagePath});
                    }
                  }
                }

                QuerySnapshot querySnapshotDeleted = await FirebaseFirestore
                    .instance
                    .collection('deletedOffers')
                    .get();

                if (querySnapshotDeleted.docs.isNotEmpty) {
                  for (var doc in querySnapshotDeleted.docs) {
                    Map<String, dynamic> data =
                        doc.data() as Map<String, dynamic>;

                    if (data['driverId'] == widget.userId) {
                      FirebaseFirestore.instance
                          .collection('deletedOffers')
                          .doc(data['offerId'])
                          .update({'driverLicence': _pickedImagePath});
                    }
                  }
                }
              }

              updateOffers();
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

  Container updateNameField(Size size) {
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
          hintText: 'Name',
          focusColor: primaryColor,
        ),
      ),
    );
  }

  Container updateSurnameField(Size size) {
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
          hintText: 'Surname',
          focusColor: primaryColor,
        ),
      ),
    );
  }

  Container updatePhoneField(Size size) {
    return Container(
      width: size.width * 0.99,
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 5,
      ),
      child: TextFormField(
        controller: _controller,
        keyboardType: TextInputType.number,
        style: const TextStyle(color: Color.fromARGB(255, 31, 40, 51)),
        decoration: const InputDecoration(
          hintText: 'Phone',
          focusColor: primaryColor,
        ),
      ),
    );
  }

  Container updateCompanyNameField(Size size) {
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
          hintText: 'Company Name',
          focusColor: primaryColor,
        ),
      ),
    );
  }

  Container updateCompanyEmailField(Size size) {
    return Container(
      width: size.width * 0.99,
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 5,
      ),
      child: TextFormField(
        controller: _controller,
        keyboardType: TextInputType.emailAddress,
        style: const TextStyle(color: Color.fromARGB(255, 31, 40, 51)),
        decoration: const InputDecoration(
          hintText: 'Company Email',
          focusColor: primaryColor,
        ),
      ),
    );
  }

  Container updateExpireDateOfLicence(BuildContext context, Size size) {
    return Container(
      width: size.width * 0.99,
      child: Padding(
        padding: const EdgeInsets.only(
          left: 10,
          right: 200,
          bottom: 10,
        ),
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(right: 9),
              child: Text(
                'Expire Date Of Licence',
                style: TextStyle(
                  color: Color.fromARGB(255, 31, 40, 51),
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
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
                          _pickedDate =
                              "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}";
                        });
                      }
                    });
                  },
                  child: Text(
                    _pickedDate == '' ? 'Pick Date' : 'Picked Date:',
                    style: TextStyle(
                      color: _pickedDate == ''
                          ? primaryColor
                          : const Color.fromARGB(255, 31, 40, 51),
                      fontSize: 13,
                    ),
                  ),
                ),
                Text(
                  _pickedDate,
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

  UserImagePicker updateDriverLicence() {
    return UserImagePicker(
      onPickImage: (pickedImage) async {
        await FirebaseStorage.instance
            .ref()
            .child('driver_licence_images')
            .child('${widget.userId}.jpg')
            .putFile(File(pickedImage.path));

        _pickedImagePath = await FirebaseStorage.instance
            .ref()
            .child('driver_licence_images')
            .child('${widget.userId}.jpg')
            .getDownloadURL();
      },
    );
  }
}
