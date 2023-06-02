import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:spesnow/views/auth/close_account.dart';
import 'package:spesnow/providers/firebase_auth_provider.dart';
import 'package:spesnow/views/auth/sign_in.dart';
import 'package:spesnow/views/auth/sign_up.dart';
import 'package:spesnow/views/auth/verify_email.dart';
import 'package:spesnow/components/bottom_modal_keys.dart';
import 'package:spesnow/views/payment/payment.dart';
import '../generated/l10n.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Wallet extends StatefulWidget {
  const Wallet({super.key});

  @override
  State<Wallet> createState() => _WalletState();
}

class _WalletState extends State<Wallet> {
  String _isLoggedIn = "loading";
  Map<String, dynamic> _user = {};
  late int keys;

  @override
  void initState() {
    _checkLogin();
    _getKeys();
    super.initState();
  }

  _getKeys() async {
    final prefs = await SharedPreferences.getInstance();
    keys = prefs.getInt('keys') ?? 0;
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
          backgroundColor: Colors.transparent,
          elevation: 0,
          automaticallyImplyLeading: false,
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 0, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(8.0, 0, 8, 8),
                child: Text(
                  'Wallet',
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
                  "Login in to access your wallet",
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
            backgroundColor: Colors.transparent,
            elevation: 0,
            automaticallyImplyLeading: false,
          ),
          body: Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 0, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(8.0, 0, 8, 8),
                  child: Text(
                    'Wallet',
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
                    "Verify email to access your wallet",
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
                        "Not a valid Email?",
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
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            HapticFeedback.mediumImpact();
            final prefs = await SharedPreferences.getInstance();
            setState(() {
              keys = prefs.getInt('keys') ?? 0;
            });
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 0, 8, 8),
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(8.0, 0, 8, 8),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Wallet',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 26,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 1.5),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Stack(
                      children: [
                        SizedBox(
                            width: double.infinity,
                            height: 200,
                            child: Card(
                              elevation: 4.0,
                              color: Colors.white,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "$keys",
                                    style: const TextStyle(fontSize: 32),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.only(left: 8.0),
                                    child: Text(
                                      "KEYS",
                                      style: TextStyle(letterSpacing: 3.0),
                                    ),
                                  ),
                                ],
                              ),
                            )),
                        const Positioned(
                          bottom: 30,
                          right: 30,
                          child: Icon(Icons.vpn_key),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8.0, 20.0, 8.0, 8.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50.0),
                      child: SizedBox(
                        height: 50,
                        width: 150,
                        child: ElevatedButton(
                          onPressed: () {
                            showBottomModalKeys(
                                context, _user["name"], _user["email"]);
                            // showModalBottomSheet(
                            //     shape: const RoundedRectangleBorder(
                            //       borderRadius: BorderRadius.vertical(
                            //         top: Radius.circular(10.0),
                            //       ),
                            //     ),
                            //     context: context,
                            //     builder: (context) {
                            //       return Column(
                            //         mainAxisAlignment: MainAxisAlignment.center,
                            //         children: [
                            //           Padding(
                            //             padding: const EdgeInsets.only(bottom:8.0),
                            //             child: Container(
                            //               width: 50,
                            //               height: 5,
                            //               decoration: BoxDecoration(
                            //                 color: Colors.grey,
                            //                 borderRadius: BorderRadius.circular(50),
                            //               ),
                            //             ),
                            //           ),
                            //           Padding(
                            //             padding: const EdgeInsets.all(8.0),
                            //             child: ListTile(
                            //               onTap: () {
                            //                 Navigator.pushReplacement(
                            //                   context,
                            //                   MaterialPageRoute(
                            //                       builder: (context) =>
                            //                           PaymentPage(
                            //                             name: _user["name"],
                            //                             email: _user["email"],
                            //                             amount: 5000,
                            //                           )),
                            //                 );
                            //               },
                            //               title: const Text(
                            //                 '45 KEYS',
                            //                 style: TextStyle(
                            //                     letterSpacing: 2.0,
                            //                     color: Colors.black54),
                            //               ),
                            //               trailing: const Text(
                            //                 'UGX 5,000',
                            //                 style: TextStyle(
                            //                     color: Colors.black,
                            //                     fontSize: 16,
                            //                     letterSpacing: 1.0),
                            //               ),
                            //             ),
                            //           ),
                            //           const Divider(),
                            //           Padding(
                            //             padding: const EdgeInsets.all(8.0),
                            //             child: ListTile(
                            //               onTap: () {
                            //                 Navigator.pushReplacement(
                            //                   context,
                            //                   MaterialPageRoute(
                            //                       builder: (context) =>
                            //                           PaymentPage(
                            //                               name: _user["name"],
                            //                               email: _user["email"],
                            //                               amount: 10000)),
                            //                 );
                            //               },
                            //               title: const Text(
                            //                 '90 KEYS',
                            //                 style: TextStyle(
                            //                     letterSpacing: 2.0,
                            //                     color: Colors.black54),
                            //               ),
                            //               trailing: const Text(
                            //                 'UGX 10,000',
                            //                 style: TextStyle(
                            //                     color: Colors.black,
                            //                     fontSize: 16,
                            //                     letterSpacing: 1.0),
                            //               ),
                            //             ),
                            //           ),
                            //           const Divider(),
                            //           Padding(
                            //             padding: const EdgeInsets.all(8.0),
                            //             child: ListTile(
                            //               onTap: () {
                            //                 Navigator.pushReplacement(
                            //                   context,
                            //                   MaterialPageRoute(
                            //                       builder: (context) =>
                            //                           PaymentPage(
                            //                             name: _user["name"],
                            //                             email: _user["email"],
                            //                             amount: 20000,
                            //                           )),
                            //                 );
                            //               },
                            //               title: const Text(
                            //                 '200 KEYS',
                            //                 style: TextStyle(
                            //                     letterSpacing: 2.0,
                            //                     color: Colors.black54),
                            //               ),
                            //               trailing: const Text(
                            //                 'UGX 20,000',
                            //                 style: TextStyle(
                            //                     color: Colors.black,
                            //                     fontSize: 16,
                            //                     letterSpacing: 1.0),
                            //               ),
                            //             ),
                            //           ),
                            //           const Divider(),
                            //           Padding(
                            //             padding: const EdgeInsets.all(8.0),
                            //             child: ListTile(
                            //               onTap: () {
                            //                 Navigator.pushReplacement(
                            //                   context,
                            //                   MaterialPageRoute(
                            //                       builder: (context) =>
                            //                           PaymentPage(
                            //                             name: _user["name"],
                            //                             email: _user["email"],
                            //                             amount: 50000,
                            //                           )),
                            //                 );
                            //               },
                            //               title: const Text(
                            //                 '540 KEYS',
                            //                 style: TextStyle(
                            //                     letterSpacing: 2.0,
                            //                     color: Colors.black54),
                            //               ),
                            //               trailing: const Text(
                            //                 'UGX 50,000',
                            //                 style: TextStyle(
                            //                     color: Colors.black,
                            //                     fontSize: 16,
                            //                     letterSpacing: 1.0),
                            //               ),
                            //             ),
                            //           ),
                            //         ],
                            //       );
                            //     });
                          },
                          child: const Text(
                            'Add keys',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
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
