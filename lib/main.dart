import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'package:shipping_app/screens/driver_logged_in.dart';
import 'package:shipping_app/screens/payloader_logged_in.dart';
import 'package:shipping_app/screens/auth.dart';
import 'package:shipping_app/screens/splash.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shipping',
      theme: ThemeData().copyWith(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 197, 198, 199),
        ),
      ),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SplashScreen();
          }

          if (snapshot.hasData) {
            return FutureBuilder<String>(
              future: getUserType(),
              builder: (ctx, userTypeSnapshot) {
                if (userTypeSnapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const SplashScreen();
                } else if (userTypeSnapshot.hasData) {
                  final userType = userTypeSnapshot.data;
                  //userTypeSnapshot.data is the value that is returned by getusertype()
                  if (userType == 'Driver') {
                    print(userType);
                    return const DriverLoggedInScreen();
                  } else {
                    print(userType);
                    return const PayloaderLoggedInScreen();
                  }
                } else {
                  return const AuthScreen();
                }
              },
            );
          }

          return const AuthScreen();
        },
      ),
    );
  }
}
