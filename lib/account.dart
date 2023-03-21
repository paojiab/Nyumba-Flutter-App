import 'package:flutter/material.dart';
import 'package:spesnow/notification.dart';
import 'package:spesnow/pages/login.dart';
import 'package:spesnow/pages/preferences.dart';
import 'package:spesnow/providers/spesnow_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'generated/l10n.dart';

class Account extends StatefulWidget {
  const Account({super.key});

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  String _isLoggedIn = "check";
  @override
  void initState() {
    _check();
    super.initState();
  }

  _check() async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');
    if (token == null) {
      setState(() {
        _isLoggedIn = "false";
      });
    } else {
      setState(() {
        _isLoggedIn = "true";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoggedIn == "false") {
      return const Login(page: "account");
    }
    else if (_isLoggedIn == "check") {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.brown,
        title: Text(
          S.of(context).account,
          style: const TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.help),
            color: Colors.white,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(8.0, 25, 8, 8),
              child: SizedBox(
                width: 100,
                height: 100,
                child: CircleAvatar(
                  // backgroundImage: AssetImage('images/profile.jpg'),
                  backgroundColor: Colors.brown,
                  child: Text('OPB'),
                ),
              ),
            ),
            const Text('Ojiambo Paul Barasa',
                style: TextStyle(fontWeight: FontWeight.bold)),
            Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 20, 8, 8),
              child: ListView(
                shrinkWrap: true,
                children: [
                  const ListTile(
                    title: Text('Personal Data'),
                    leading: Icon(Icons.person),
                    iconColor: Colors.brown,
                    trailing: Icon(Icons.arrow_forward_ios),
                  ),
                  const ListTile(
                    title: Text('Subscription'),
                    leading: Icon(Icons.subscriptions),
                    iconColor: Colors.brown,
                    trailing: Icon(Icons.arrow_forward_ios),
                  ),
                  const ListTile(
                    title: Text('My rentals'),
                    leading: Icon(Icons.house),
                    iconColor: Colors.brown,
                    trailing: Icon(Icons.arrow_forward_ios),
                  ),
                  const ListTile(
                    title: Text('Tours'),
                    leading: Icon(Icons.map),
                    iconColor: Colors.brown,
                    trailing: Icon(Icons.arrow_forward_ios),
                  ),
                  const ListTile(
                    title: Text('Reviews'),
                    leading: Icon(Icons.rate_review),
                    iconColor: Colors.brown,
                    trailing: Icon(Icons.arrow_forward_ios),
                  ),
                  const ListTile(
                    title: Text('Order'),
                    leading: Icon(Icons.store),
                    iconColor: Colors.brown,
                    trailing: Icon(Icons.arrow_forward_ios),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Preferences(),
                        ),
                      );
                    },
                    child: const ListTile(
                      title: Text('Preferences'),
                      leading: Icon(Icons.settings),
                      iconColor: Colors.brown,
                      trailing: Icon(Icons.arrow_forward_ios),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      height: 40,
                      child: OutlinedButton(
                        onPressed: () async {
                          final prefs = await SharedPreferences.getInstance();
                          final String? token = prefs.getString('token');
                          await SpesnowProvider().logout(token!);
                          setState(() {
                            _isLoggedIn = "false";
                          });
                        },
                        child: const Text('Sign Out'),
                      ),
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
}
