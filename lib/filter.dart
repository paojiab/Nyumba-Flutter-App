import 'package:flutter/material.dart';
import 'package:spesnow/providers/meilisearch.dart';
import 'generated/l10n.dart';

class Filter extends StatefulWidget {
  const Filter({super.key});

  @override
  State<Filter> createState() => _FilterState();
}

class _FilterState extends State<Filter> {
  @override
  void initState() {
    _facets();
    super.initState();
  }

  _facets() async {
    await Meilisearch().getFacets("busia");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.arrow_back_ios)),
        backgroundColor: Colors.brown,
        centerTitle: true,
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
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Category',
              style: TextStyle(fontSize: 16),
            ),
          ),
          CheckboxListTile(
            value: false,
            onChanged: (_) {},
            title: const Text(
              'Shop (2)',
              style: TextStyle(fontSize: 14),
            ),
          )
        ],
      ),
    );
  }
}
