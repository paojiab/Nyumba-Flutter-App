import 'package:flutter/material.dart';
import 'package:spesnow/views/account/account.dart';
import 'package:spesnow/providers/firebase_auth_provider.dart';

import 'preferences.dart';
import '../auth/close_account.dart';

class accountSettingsPage extends StatefulWidget {
  const accountSettingsPage({super.key, required this.user});
  final Map<String, dynamic> user;
  @override
  State<accountSettingsPage> createState() => _accountSettingsPageState();
}

class _accountSettingsPageState extends State<accountSettingsPage> {
  bool _isLoggedOut = false;
  @override
  Widget build(BuildContext context) {
    if (_isLoggedOut) {
      return const Account();
    }
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            )),
        elevation: 0,
        title: const Text(
          "Settings",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(top: 10.0),
                    child: Text(
                      "MY ACCOUNT",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              Card(
                child: Column(children: [
                  ListTile(
                    title: const Text('Name'),
                    subtitle: Text(widget.user['name'] ?? ""),
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.grey,
                      size: 20,
                    ),
                  ),
                  const Divider(),
                  ListTile(
                    title: const Text('Phone Number'),
                    subtitle: Text(widget.user['phoneNumber'] ?? ""),
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.grey,
                      size: 20,
                    ),
                  ),
                  const Divider(),
                  ListTile(
                    title: const Text('Email'),
                    subtitle: Text(widget.user['email']),
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.grey,
                      size: 20,
                    ),
                  ),
                  const Divider(),
                  const ListTile(
                    title: Text('Become A Landlord'),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.grey,
                      size: 20,
                    ),
                  ),
                  const Divider(),
                  const ListTile(
                    title: Text('Password'),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.grey,
                      size: 20,
                    ),
                  ),
                  const Divider(),
                  const ListTile(
                    title: Text('Notifications'),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.grey,
                      size: 20,
                    ),
                  ),
                  const Divider(),
                  const ListTile(
                    title: Text('App Appearance'),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.grey,
                      size: 20,
                    ),
                  ),
                ]),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(top: 10.0),
                    child: Text(
                      "ACCOUNT ACTIONS",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              Card(
                child: Column(
                  children: [
                    ListTile(
                      onTap: () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: ((context) =>
                              closeAccountPage(email: widget.user['email'])),
                        ),
                      ),
                      title: const Text('Delete Account'),
                      trailing: const Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.grey,
                        size: 20,
                      ),
                    ),
                    const Divider(),
                    ListTile(
                      onTap: (() {
                        Navigator.pop(context);
                        showMyDialog();
                      }),
                      title: const Text('Log Out'),
                      trailing: const Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.grey,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 5.0, top: 25.0),
                child: Column(
                  children: const [
                    Text(
                      "Spesnow v1.0.0",
                      style: TextStyle(color: Colors.black54, fontSize: 12),
                    ),
                    Text(
                      "Made in Uganda",
                      style: TextStyle(color: Colors.black54, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(10.0), // Set the desired border radius
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
}
