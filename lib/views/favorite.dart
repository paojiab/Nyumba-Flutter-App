import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:spesnow/views/auth/close_account.dart';
import 'package:spesnow/providers/firebase_auth_provider.dart';
import 'package:spesnow/views/auth/sign_in.dart';
import 'package:spesnow/views/auth/sign_up.dart';
import 'package:spesnow/views/auth/verify_email.dart';

class Favorite extends StatefulWidget {
  const Favorite({super.key});

  @override
  State<Favorite> createState() => _FavoriteState();
}

class _FavoriteState extends State<Favorite> {
  String _isLoggedIn = "loading";
  bool hide = true;
  Map<String, dynamic> _user = {};
  @override
  void initState() {
    _checkLogin();
    super.initState();
  }

  _checkLogin() async {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        setState(() {
          _isLoggedIn = "false";
        });
      } else {
        _user = firebaseAuth().getUser();
        setState(() {
          _isLoggedIn = "true";
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoggedIn == "false") {
      return Scaffold(
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 0, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(8.0, 0, 8, 8),
                child: Text(
                  'Saved',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 26,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 1.5),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Login in to access your saved rentals",
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 30.0, 8.0, 8.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50.0),
                  child: SizedBox(
                    height: 50,
                    width: 150,
                    child: ElevatedButton(
                      onPressed: () {
                        showCupertinoModalBottomSheet(
                  context: context,
                  builder: (context) => const Login(),
                );
                      },
                      child: const Text(
                        'Log In',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    const Text(
                      "Don't have an account?",
                      style: TextStyle(color: Colors.black54),
                    ),
                    TextButton(
                      onPressed: () {
                        showCupertinoModalBottomSheet(
                  context: context,
                  builder: (context) => const signUpPage(),
                );
                      },
                      child: const Text(
                        'Sign Up',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            decoration: TextDecoration.underline,
                            decorationColor: Colors.black),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    } else if (_isLoggedIn == "true") {
      if (!_user['emailVerified']) {
        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
          ),
          body: Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 0, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(8.0, 0, 8, 8),
                  child: Text(
                    'Saved',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 26,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1.5),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Verify email to access your saved rentals",
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8.0, 30.0, 8.0, 8.0),
                  child: SizedBox(
                    height: 50,
                    width: 150,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50.0),
                          ),
                        ),
                      ),
                      onPressed: () {
                        showCupertinoModalBottomSheet(
                          context: context,
                          builder: (context) => const verifyEmailPage(),
                        );
                      },
                      child: const Text(
                        'Verify Email',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      const Text(
                        "Not a valid email?",
                        style: TextStyle(color: Colors.black54),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      closeAccountPage(email: _user['email'])));
                        },
                        child: const Text(
                          'Delete Account',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              decoration: TextDecoration.underline,
                              decorationColor: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }
      return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 0, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Padding(
                  padding: EdgeInsets.fromLTRB(8.0, 0, 8, 8),
                  child: Text(
                    'Saved',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 26,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1.5),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top:250.0),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Coming soon..",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
