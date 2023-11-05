import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

//The idea behind this screen  simply is to use it as a loading screen whilst
//Firebase is figuring out whether we have a token or not

class DriverLoggedInScreen extends StatelessWidget {
  const DriverLoggedInScreen({super.key});

  @override
  Widget build(context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 31, 40, 51),
      appBar: AppBar(
        title: const Text('Shipping'),
        actions: [
          IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
            icon: const Icon(
              Icons.exit_to_app,
              color: Color.fromARGB(255, 31, 40, 51),
            ),
          ),
        ],
      ),
      body: const Center(
        child: Text(
          'Driver Logged in',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
