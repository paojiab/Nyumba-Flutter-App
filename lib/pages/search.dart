import 'package:flutter/material.dart';
import 'package:spesnow/providers/algolia.dart';
import 'package:spesnow/search.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

  List _suggestions = [];
  late final TextEditingController _controller = TextEditingController()
    ..addListener(() {
      setState(() {});
    });

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
           
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.brown,
        title: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Center(
            child: TextField(
              autocorrect: false,
              autofocus: true,
              controller: _controller,
              onChanged: (value) async {
                final hits =
                    await AlgoliaProvider().fetchQuerySuggestions(value);
                setState(() {
                  _suggestions = hits;
                });
              },
              onSubmitted: (value) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Search(search: _controller.text),
                  ),
                );
              },
              decoration: InputDecoration(
                hintText: 'Search',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _controller.text.isNotEmpty
                    ? IconButton(
                        onPressed: () {
                          _controller.clear();
                        },
                        icon: const Icon(Icons.clear),
                      )
                    : IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.tune),
                      ),
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
        body: ListView.builder(
        itemCount: _suggestions.length,
        itemBuilder: (context, index) {
          final query = _suggestions[index]['query'];
          return ListTile(
            onTap: () {
               Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Search(search: query),
                  ),
                );
            },
            title: Text(query),
          );
        },
      ),
    );
  }
}
