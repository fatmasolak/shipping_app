import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PayloaderCredentialsScreen extends StatefulWidget {
  const PayloaderCredentialsScreen({super.key});

  @override
  State<PayloaderCredentialsScreen> createState() {
    return _PayloaderCredentialsScreenState();
  }
}

class _PayloaderCredentialsScreenState
    extends State<PayloaderCredentialsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 31, 40, 51),
      appBar: AppBar(
        title: const Text('FlutterChat'),
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
      body: Center(
        child: Container(
          width: 300,
          height: 200,
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 197, 198, 199),
            borderRadius: BorderRadius.all(Radius.circular(30)),
          ),
          child: const Padding(
            padding: EdgeInsets.only(
              top: 30,
              bottom: 30,
              left: 10,
              right: 10,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('logged in'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
