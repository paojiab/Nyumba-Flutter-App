import 'package:flutter/material.dart';
import 'package:spesnow/components/logout_dialog.dart';
import '../auth/close_account.dart';

class AccountSettingsPage extends StatefulWidget {
  const AccountSettingsPage({super.key, required this.user});
  final Map<String, dynamic> user;
  @override
  State<AccountSettingsPage> createState() => _AccountSettingsPageState();
}

class _AccountSettingsPageState extends State<AccountSettingsPage> {
  @override
  Widget build(BuildContext context) {
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
                        logoutDialog(context);
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

 
}
