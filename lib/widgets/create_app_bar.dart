import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CreateAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CreateAppBar(
      {super.key, required this.header, required this.isShowing});

  final bool isShowing;
  final String header;

  @override
  Size get preferredSize => const Size.fromHeight(70);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      iconTheme: const IconThemeData(
        color: Colors.white, //change your color here
      ),
      backgroundColor: const Color.fromARGB(255, 31, 40, 51),
      title: Text(
        header,
        style: const TextStyle(
          color: Colors.white,
        ),
      ),
      actions: [
        if (isShowing)
          IconButton(
            onPressed: () => showDialog<String>(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                title: const Text('Logout'),
                content: const Text('Are you sure want to log out?'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'No'),
                    child: const Text('No'),
                  ),
                  TextButton(
                    onPressed: () {
                      FirebaseAuth.instance.signOut();
                      Navigator.pop(context, 'Yes');
                    },
                    child: const Text('Yes'),
                  ),
                ],
              ),
            ),
            icon: const Icon(
              Icons.exit_to_app,
              color: Colors.white,
            ),
          ),
      ],
    );
  }
}
