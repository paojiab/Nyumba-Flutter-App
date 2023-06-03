import 'package:flutter/material.dart';
import 'package:spesnow/providers/firebase_auth_provider.dart';

logoutDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(10.0), 
          ),
          title: const Text(
            'Are you sure you want to log out?',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            Column(
              children: [
                ButtonBar(
                  alignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 250,
                      height: 50,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50.0),
                            ),
                          ),
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.black54),
                        ),
                        child: const Text(
                          'Log Out',
                          style: TextStyle(fontSize: 18),
                        ),
                        onPressed: () {
                          Future.delayed(const Duration(milliseconds: 50),
                              () async {
                            await firebaseAuth().signOut();
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: Colors.black,
                              content: const Text('Logged out'),
                            ),
                          );
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: TextButton(
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: Colors.black54, fontSize: 18),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }