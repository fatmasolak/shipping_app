import 'package:flutter/material.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() {
    return _AuthScreenState();
  }
}

class _AuthScreenState extends State<AuthScreen> {
  var _selectedUserType = '';
  var _isSelected = false;
  var _isLogin = true;

  void _submit() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 31, 40, 51),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_isLogin)
                Card(
                  margin: const EdgeInsets.all(20),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Form(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'Email Address',
                              ),
                              keyboardType: TextInputType.emailAddress,
                              autocorrect: false,
                              textCapitalization: TextCapitalization.none,
                              //validator: () {},
                              //onSaved: () {},
                            ),
                            const SizedBox(height: 12),
                            TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'Password',
                              ),
                              obscureText: true,
                              //validator: () {},
                              //onSaved: () {},
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: _submit,
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.black,
                                backgroundColor:
                                    const Color.fromARGB(255, 102, 252, 241),
                              ),
                              child: Text(_isLogin ? 'Login' : 'Signup'),
                            ),
                            const SizedBox(height: 12),
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  _isLogin = !_isLogin;
                                });
                              },
                              child: Text(_isLogin
                                  ? 'Create an account'
                                  : 'I already have an acoount'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              if (!_isLogin && !_isSelected)
                Container(
                  width: 300,
                  height: 200,
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(150, 11, 12, 16),
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 30,
                      bottom: 30,
                      left: 10,
                      right: 10,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _isSelected = true;
                              _selectedUserType = 'Driver';
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.transparent,
                            side: const BorderSide(
                                color: Color.fromARGB(255, 102, 252, 241),
                                width: 2),
                          ),
                          child: const Text('Driver'),
                        ),
                        const SizedBox(height: 40),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _isSelected = true;
                              _selectedUserType = 'Payloader';
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.transparent,
                            side: const BorderSide(
                                color: Color.fromARGB(255, 102, 252, 241),
                                width: 2),
                          ),
                          child: const Text('Payloader'),
                        ),
                      ],
                    ),
                  ),
                ),
              if (!_isLogin && _isSelected)
                Card(
                  margin: const EdgeInsets.all(20),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Form(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'Email Address',
                              ),
                              keyboardType: TextInputType.emailAddress,
                              autocorrect: false,
                              textCapitalization: TextCapitalization.none,
                              //validator: () {},
                              //onSaved: () {},
                            ),
                            const SizedBox(height: 12),
                            TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'Password',
                              ),
                              obscureText: true,
                              //validator: () {},
                              //onSaved: () {},
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: _submit,
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.black,
                                backgroundColor:
                                    const Color.fromARGB(255, 102, 252, 241),
                              ),
                              child: Text(_isLogin ? 'Login' : 'Signup'),
                            ),
                            const SizedBox(height: 12),
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  _isLogin = !_isLogin;
                                  _isSelected = false;
                                });
                              },
                              child: Text(_isLogin
                                  ? 'Create an account'
                                  : 'I already have an acoount'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
