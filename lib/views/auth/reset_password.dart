import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:spesnow/providers/firebase_auth_provider.dart';
import 'package:spesnow/providers/regex_provider.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.clear,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        title: const Text(
          "Reset Password",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Form(
            key: _formKey,
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "EMAIL",
                        style: TextStyle(color: Colors.black54),
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: 50,
                    child: TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Email required';
                        } else if (!value.isValidEmail) {
                          return 'Enter valid email';
                        }
                        return null;
                      },
                      controller: emailController,
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black54),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black54),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: SizedBox(
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
                        backgroundColor: MaterialStateProperty.all<Color>(
                            _isLoading ? Colors.black38 : Colors.black54),
                      ),
                      onPressed: () async {
                        if (_formKey.currentState!.validate() && !_isLoading) {
                          setState(() {
                            _isLoading = true;
                          });
                          try {
                            await firebaseAuth()
                                .resetPassword(emailController.text);
                            setState(() {
                              _isLoading = false;
                            });
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                behavior: SnackBarBehavior.floating,
                                backgroundColor: Colors.black,
                                content: const Text(
                                    "We've sent you an email with a reset link. Please open it to continue."),
                              ),
                            );
                          } on FirebaseAuthException catch (e) {
                            setState(() {
                              _isLoading = false;
                            });
                            if (e.code == 'user-not-found') {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  behavior: SnackBarBehavior.floating,
                                  backgroundColor: Colors.black,
                                  content: const Text(
                                      "No user found for that email"),
                                ),
                              );
                            } else {
                               ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                behavior: SnackBarBehavior.floating,
                                backgroundColor: Colors.black,
                                content: const Text("Unknown error"),
                              ),
                            );
                            }
                          }
                        }
                      },
                      child: _isLoading
                          ? const Text("Sending reset link..")
                          : const Text("Send Reset Link"),
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
