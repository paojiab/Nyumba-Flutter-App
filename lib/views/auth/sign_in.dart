import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:spesnow/providers/firebase_auth_provider.dart';
import 'package:spesnow/providers/regex_provider.dart';
import 'package:spesnow/views/auth/reset_password.dart';
import 'package:spesnow/views/auth/sign_up.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  bool _isLoading = false;

  bool hide = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Log In',
          style: TextStyle(color: Colors.black),
        ),
        automaticallyImplyLeading: false,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.clear,
              color: Colors.black,
            )),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                showCupertinoModalBottomSheet(
                  context: context,
                  builder: (context) => const signUpPage(),
                );
              },
              child: const Text(
                "SIGN UP",
                style: TextStyle(color: Colors.brown, fontSize: 16),
              ))
        ],
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
                      if (value != null &&
                          value.isNotEmpty &&
                          !value.isValidEmail) {
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
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "PASSWORD",
                      style: TextStyle(color: Colors.black54),
                    )),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  height: 50,
                  child: TextFormField(
                    controller: passwordController,
                    obscureText: hide ? true : false,
                    decoration: InputDecoration(
                      border: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black54),
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black54),
                      ),
                      suffixIcon: !hide
                          ? Padding(
                              padding:
                                  const EdgeInsetsDirectional.only(end: 12.0),
                              child: IconButton(
                                onPressed: () {
                                  setState(() {
                                    hide = true;
                                  });
                                },
                                icon: const Icon(Icons.remove_red_eye),
                              ),
                            )
                          : Padding(
                              padding:
                                  const EdgeInsetsDirectional.only(end: 12.0),
                              child: IconButton(
                                onPressed: () {
                                  setState(() {
                                    hide = false;
                                  });
                                },
                                icon: const Icon(Icons.visibility_off),
                              ),
                            ),
                    ),
                  ),
                ),
              ),
              TextButton(
                onPressed: () async {
                  showCupertinoModalBottomSheet(
                    context: context,
                    builder: (context) => const ResetPasswordPage(),
                  );
                },
                child: const Text(
                  "Forgot your password?",
                  style: TextStyle(fontSize: 12, color: Colors.black54),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                    height: 50,
                    width: 250,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50.0),
                          ),
                        ),
                        backgroundColor: MaterialStateProperty.all<Color>(
                            _isLoading ? Colors.brown.shade300 : Colors.brown),
                      ),
                      onPressed: () async {
                        if (emailController.text.isNotEmpty ||
                            passwordController.text.isNotEmpty) {
                          if (_formKey.currentState!.validate() && !_isLoading) {
                            final email = emailController.text;
                            final password = passwordController.text;
                            setState(() {
                              _isLoading = true;
                            });
                            final result =
                                await firebaseAuth().signIn(email, password);
                            if (result == "user-found") {
                              setState(() {
                                _isLoading = false;
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  behavior: SnackBarBehavior.floating,
                                  backgroundColor: Colors.black,
                                  content: const Text(
                                    "Logged in",
                                  ),
                                ),
                              );
                              Navigator.pop(context);
                            } else {
                              setState(() {
                                _isLoading = false;
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  behavior: SnackBarBehavior.floating,
                                  backgroundColor: Colors.black,
                                  content: Text(result),
                                ),
                              );
                            }
                          }
                        } else if (emailController.text.isEmpty ||
                            passwordController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: Colors.black,
                              content: const Text(
                                  "You must complete the entire form"),
                            ),
                          );
                        }
                      },
                      child: _isLoading
                          ? const Text("Logging in..")
                          : const Text(
                              'Log In',
                              style: TextStyle(fontSize: 18),
                            ),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
