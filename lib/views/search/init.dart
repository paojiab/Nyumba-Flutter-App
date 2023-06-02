import 'package:flutter/material.dart';
import 'package:spesnow/providers/algolia.dart';
import 'package:spesnow/views/search/result.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List _suggestions = [];
  late List<String> _history = [];
  bool _switch = false;
  late final TextEditingController _controller = TextEditingController()
    ..addListener(() {
      setState(() {});
    });

  @override
  void initState() {
    history();
    super.initState();
  }

  history() async {
    final prefs = await SharedPreferences.getInstance();
    _history = prefs.getStringList('history') ?? [];
  }

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
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: SizedBox(
          height: 45,
          child: TextField(
            style: const TextStyle(fontSize: 13.5),
            autocorrect: false,
            autofocus: true,
            controller: _controller,
            onChanged: (value) async {
              final hits =
                  await AlgoliaProvider().fetchQuerySuggestions(value);
              setState(() {
                _suggestions = hits;
                _switch = true;
              });
            },
            onSubmitted: (value) {
              if (_controller.text.isNotEmpty) {
                Future.delayed(const Duration(milliseconds: 100), () async {
                  _history.add(_controller.text);
                  final prefs = await SharedPreferences.getInstance();
                  prefs.setStringList('history', _history);
                });
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Search(search: _controller.text),
                  ),
                );
              }
            },
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(0),
               border: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
                borderRadius: BorderRadius.all(Radius.circular(45.0)),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
                borderRadius: BorderRadius.all(Radius.circular(45.0)),
              ),
                hintText: 'Location',
                hintStyle: const TextStyle(color: Colors.black54),
                prefixIcon: const Icon(Icons.search, color: Colors.black,),
                suffixIcon: _controller.text.isNotEmpty
                    ? IconButton(
                        onPressed: () {
                          _controller.clear();
                          setState(() {
                            _switch = false;
                          });
                        },
                        icon: const Icon(Icons.clear, color: Colors.black54,),
                      )
                    : null),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
      body: _switch
          ? ListView.builder(
              itemCount: _suggestions.length,
              itemBuilder: (context, index) {
                final query = _suggestions[index]['query'];
                return ListTile(
                  onTap: () {
                    Future.delayed(const Duration(milliseconds: 100), () async {
                      _history.add(query);
                      final prefs = await SharedPreferences.getInstance();
                      prefs.setStringList('history', _history);
                    });
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Search(search: query),
                      ),
                    );
                  },
                  title: Text(query),
                );
              },
            )
          : Column(
              children: [
                _history.isNotEmpty
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(left: 8.0),
                            child: Text(
                              'Recently Searched',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Future.delayed(const Duration(milliseconds: 50),
                                  () async {
                                final prefs =
                                    await SharedPreferences.getInstance();
                                await prefs.remove('history');
                              });
                              setState(() {
                                _history.clear();
                              });
                            },
                            child: const Text('CLEAR', style: TextStyle(color: Colors.black54),),
                          ),
                        ],
                      )
                    : const Text(""),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: _history.length,
                  itemBuilder: (context, index) {
                    final query = _history.reversed.toList()[index];
                    return ListTile(
                      onTap: () {
                        Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Search(search: query),
                      ),
                    );
                      },
                      leading: const Icon(Icons.access_time),
                      title: Text(query),
                    );
                  },
                ),
              ],
            ),
    );
  }
}
