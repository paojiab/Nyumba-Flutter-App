import 'package:flutter/material.dart';
import 'package:spesnow/providers/firebase_auth_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class closeAccountPage extends StatefulWidget {
  const closeAccountPage({super.key, required this.email});
  final String email;
  @override
  State<closeAccountPage> createState() => _closeAccountPageState();
}

class _closeAccountPageState extends State<closeAccountPage> {
  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false;

  final passwordController = TextEditingController();
  bool hide = true;
  @override
  void dispose() {
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
          'Delete Account',
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
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Enter password to confirm account deletion",
                  style: TextStyle(fontSize: 16),
                ),
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
              Padding(
                padding: const EdgeInsets.all(30.0),
                child: SizedBox(
                  width: 250,
                  height: 50,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                      ),
                      backgroundColor: MaterialStateProperty.all<Color>(
                          _isLoading ? Colors.black38 : Colors.black54),
                    ),
                    onPressed: () async {
                      if (passwordController.text.isNotEmpty && !_isLoading) {
                        final password = passwordController.text;
                        setState(() {
                          _isLoading = true;
                        });
                        final result = await firebaseAuth()
                            .deleteUser(widget.email, password);
                        if (result) {
                          setState(() {
                            _isLoading = false;
                          });
                          final SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          await prefs.setInt('keys', 0);
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: Colors.black,
                              content: const Text("Account deleted"),
                            ),
                          );
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
                              content: const Text("Wrong password"),
                            ),
                          );
                        }
                      } else if (passwordController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: Colors.black,
                            content: const Text("You must enter a password"),
                          ),
                        );
                      }
                    },
                    child: _isLoading
                        ? const Text("Deleting account..")
                        : const Text('Confirm Deletion'),
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
