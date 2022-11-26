import 'package:flutter/material.dart';
import 'package:nyumba/LanguageChangeProvider.dart';
import 'package:nyumba/notification.dart';
import 'package:provider/provider.dart';
import 'generated/l10n.dart';

class Account extends StatelessWidget {
  const Account({super.key});

  @override
  Widget build(BuildContext context) {
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
            Card(
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
