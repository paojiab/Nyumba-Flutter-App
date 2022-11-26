import 'package:flutter/material.dart';
import 'generated/l10n.dart';

class Filter extends StatelessWidget {
  const Filter({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown,
        title: Text(
          S.of(context).filter,
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
            Card(
              child: ListTile(
                title: Text(S.of(context).category),
                trailing: const Icon(Icons.arrow_forward_ios),
              ),
            ),
            Card(
              child: ListTile(
                title: Text(S.of(context).location),
                trailing: const Icon(Icons.arrow_forward_ios),
              ),
            ),
            Card(
              child: ListTile(
                title: Text(S.of(context).price),
                trailing: const Icon(Icons.arrow_forward_ios),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(40, 20, 40, 0),
              child: ElevatedButton(
                onPressed: () {},
                child: Text(S.of(context).save),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
