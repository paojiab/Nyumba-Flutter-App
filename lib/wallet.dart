import 'package:flutter/material.dart';
import 'package:spesnow/pages/keys.dart';
import 'generated/l10n.dart';

class Wallet extends StatelessWidget {
  const Wallet({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const KeysPage(),
            ),
          );
        },
        label: const Text('Buy'),
        icon: const Icon(Icons.add),
      ),
      appBar: AppBar(
        leading: const Icon(Icons.key),
        backgroundColor: Colors.brown,
        centerTitle: true,
        title: Column(
          children: [
            const Text(
              "0 KEYS",
              style: TextStyle(color: Colors.yellow),
            ),
            Text(
              S.of(context).wallet,
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.help),
            color: Colors.white,
          ),
        ],
      ),
      body: const Center(
        child: Text("No transactions to show"),
      ),
    );
  }
}
