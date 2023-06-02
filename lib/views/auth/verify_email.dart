import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:spesnow/providers/firebase_auth_provider.dart';
import 'package:spesnow/views/auth/sign_in.dart';

class verifyEmailPage extends StatelessWidget {
  const verifyEmailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Future.delayed(const Duration(milliseconds: 100), () async {
          await firebaseAuth().signOut();
        });
        Navigator.of(context).pop();
        showCupertinoModalBottomSheet(
          context: context,
          builder: (context) => const Login(),
        );
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          automaticallyImplyLeading: false,
          leading: IconButton(
            onPressed: () {
              Future.delayed(const Duration(milliseconds: 100), () async {
                await firebaseAuth().signOut();
              });
              Navigator.of(context).pop();
              showCupertinoModalBottomSheet(
                context: context,
                builder: (context) => const Login(),
              );
            },
            icon: const Icon(
              Icons.clear,
              color: Colors.black,
            ),
          ),
          centerTitle: true,
          title: const Text(
            'Verify Email',
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "We've sent you an email verification. Please open it to verify your account.",
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                      ),
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.black54),
                    ),
                    child: const Text(
                      'Resend Email Verification',
                      style: TextStyle(fontSize: 18),
                    ),
                    onPressed: () async {
                      try {
                        await firebaseAuth().verifyEmail();

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: Colors.black,
                            content: const Text(
                                "Email verification has been resent"),
                          ),
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: Colors.black,
                            content: const Text("Try again later"),
                          ),
                        );
                      }
                    },
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
