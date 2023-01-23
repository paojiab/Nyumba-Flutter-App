import 'package:flutter/material.dart';
import 'package:nyumba/LanguageChangeProvider.dart';
import 'package:nyumba/notification.dart';
import 'package:nyumba/pages/login.dart';
import 'package:nyumba/providers/spesnow_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'generated/l10n.dart';

class Account extends StatefulWidget {
  const Account({super.key});

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  
  bool _isLoggedIn = true;
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
        _isLoggedIn = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isLoggedIn) {
      return const Login();
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown,
        title: Text(
          S.of(context).account.toUpperCase(),
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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Notify(),
                  ),
                );
              },
              child: Card(
                child: ListTile(
                  title: Text(S.of(context).notifications),
                  leading: const Icon(Icons.notifications),
                ),
              ),
            ),
            Card(
              child: ListTile(
                title: Text(S.of(context).customOrder),
                leading: const Icon(Icons.forward),
              ),
            ),
            Card(
              child: ListTile(
                title: Text(S.of(context).becomeALandlord),
                leading: const Icon(Icons.toggle_off),
              ),
            ),
            Card(
              child: ListTile(
                title: Text(S.of(context).settings),
                leading: const Icon(Icons.settings),
              ),
            ),
            GestureDetector(
              onTap: (() async {
                final prefs = await SharedPreferences.getInstance();
                final String? token = prefs.getString('token');
                await SpesnowProvider().logout(token!);
                setState(() {
                  _isLoggedIn = false;
                });
              }),
              child: Card(
                child: ListTile(
                  title: Text(
                    S.of(context).logout,
                    style: const TextStyle(color: Colors.brown),
                  ),
                  leading: const Icon(
                    Icons.logout,
                    color: Colors.brown,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 40.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () {
                      context.read<LanguageChangeProvider>().changeLocale("en");
                    },
                    child: const Text(
                      'ENGLISH',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      context.read<LanguageChangeProvider>().changeLocale("sw");
                    },
                    child: const Text(
                      'SWAHILI',
                      style: TextStyle(color: Colors.black),
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
