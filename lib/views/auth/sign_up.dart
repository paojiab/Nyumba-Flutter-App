import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:spesnow/providers/firebase_auth_provider.dart';
import 'package:spesnow/providers/regex_provider.dart';
import 'package:spesnow/views/auth/sign_in.dart';
import 'package:spesnow/views/auth/verify_email.dart';
import 'package:shared_preferences/shared_preferences.dart';

class signUpPage extends StatefulWidget {
  const signUpPage({super.key});

  @override
  State<signUpPage> createState() => _signUpPageState();
}

class _signUpPageState extends State<signUpPage> {
  final _formKey = GlobalKey<FormState>();

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool hide = true;

  bool hideConfirm = true;

  bool _isLoading = false;

  bool initial = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Sign Up',
          style: TextStyle(color: Colors.black),
        ),
        automaticallyImplyLeading: false,
        elevation: 0,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.clear,
              color: Colors.black,
            )),
        actions: [
          initial
              ? TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    showCupertinoModalBottomSheet(
                      context: context,
                      builder: (context) => const Login(),
                    );
                  },
                  child: const Text(
                    "LOGIN",
                    style: TextStyle(color: Colors.brown, fontSize: 16),
                  ))
              : TextButton(
                  onPressed: () {
                    setState(() {
                      initial = true;
                    });
                  },
                  child: const Text(
                    "BACK",
                    style: TextStyle(color: Colors.brown, fontSize: 16),
                  ))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                if (initial) ...[
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "FIRST NAME",
                          style: TextStyle(color: Colors.black54),
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      height: 50,
                      child: TextFormField(
                        controller: firstNameController,
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
                          "LAST NAME",
                          style: TextStyle(color: Colors.black54),
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      height: 50,
                      child: TextFormField(
                        controller: lastNameController,
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
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.black54),
                        ),
                        onPressed: () {
                          if (firstNameController.text.isNotEmpty &&
                              lastNameController.text.isNotEmpty) {
                            setState(() {
                              initial = false;
                            });
                          } else {
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
                        child: const Text("Continue"),
                      ),
                    ),
                  ),
                ] else ...[
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
                        validator: (value) {
                          if (value != null &&
                              value.isNotEmpty &&
                              !value.isValidEmail) {
                            return 'Enter a valid email';
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
                                  padding: const EdgeInsetsDirectional.only(
                                      end: 12.0),
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
                                  padding: const EdgeInsetsDirectional.only(
                                      end: 12.0),
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
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextButton(
                      onPressed: () {},
                      child: const Text(
                        'By tapping "Sign up & accept", you acknowledge that you have read the PRIVACY POLICY and agree to the TERMS OF SERVICE.',
                        style: TextStyle(fontSize: 12, color: Colors.black),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                        height: 50,
                        width: 250,
                        child: ElevatedButton(
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50.0),
                              ),
                            ),
                            backgroundColor: MaterialStateProperty.all<Color>(
                                _isLoading
                                    ? Colors.brown.shade300
                                    : Colors.brown),
                          ),
                          onPressed: () async {
                            if (_formKey.currentState!.validate() &&
                                !_isLoading) {
                              if (passwordController.text.isEmpty ||
                                  firstNameController.text.isEmpty ||
                                  lastNameController.text.isEmpty ||
                                  emailController.text.isEmpty) {
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
                              } else {
                                final name =
                                    "${firstNameController.text} ${lastNameController.text}";
                                final email = emailController.text;
                                final password = passwordController.text;
                                setState(() {
                                  _isLoading = true;
                                });
                                final result = await firebaseAuth()
                                    .signUp(email, password, name);
                                if (result == "user-created") {
                                  final SharedPreferences prefs =
                                      await SharedPreferences.getInstance();
                                  await prefs.setInt('keys', 0);
                                  setState(() {
                                    _isLoading = false;
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                      ),
                                      behavior: SnackBarBehavior.floating,
                                      backgroundColor: Colors.black,
                                      content: const Text("Account created"),
                                    ),
                                  );
                                  Navigator.pop(context);
                                  showCupertinoModalBottomSheet(
                                    context: context,
                                    builder: (context) =>
                                        const verifyEmailPage(),
                                  );
                                } else {
                                  setState(() {
                                    _isLoading = false;
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                      ),
                                      behavior: SnackBarBehavior.floating,
                                      backgroundColor: Colors.black,
                                      content: Text(result),
                                    ),
                                  );
                                }
                              }
                            }
                          },
                          child: _isLoading
                              ? const Text("Signing up..")
                              : const Text('Sign up & accept'),
                        )),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
