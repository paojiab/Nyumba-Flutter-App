import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  static final apiKey = dotenv.env['MEILISEARCH_KEY'];
  static const String indexName = 'rentals_index';
  static final meiliSearchUrl = dotenv.env['MEILISEARCH_HOST'];

  final TextEditingController _controller = TextEditingController();
  List<String> _suggestions = [];
  List<Map<String, dynamic>> _results = [];

  Future _getSuggestions(String query) async {
    final body = {
      'q': query,
      'attributesToRetrieve': ["title"],
    };

    final url = Uri.parse('$meiliSearchUrl/indexes/$indexName/search');

    final response = await http.post(
      url,
      body: json.encode(body),
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json'
      },
    );

    if (response.statusCode == 200) {

      final List<dynamic> hits = json.decode(response.body)['hits'];

      setState(() {
        _suggestions =
            hits.map((hit) => hit['title'].toString()).toSet().toList();
      });

      print(_suggestions);

    } else {

      print("Sth went wrong with error code ${response.statusCode}");

      return [];

    }
    // try {
    //   final List<dynamic> hits = json.decode(response.body)['hits'];
    //   print(hits);
    //   return hits.map((hit) => hit['title'].toString()).toSet().toList();
    // } catch (e) {
    //   print(e);
    //   return [];
    // }
  }

  Future<void> _search(String query) async {
    final response = await http
        .get(Uri.parse('http://localhost:7700/indexes/movies/search?q=$query'));

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final hits = json['hits'] as List<dynamic>;

      setState(() {
        _results = hits.map((hit) => hit as Map<String, dynamic>).toList();
      });
    } else {
      throw Exception('Failed to search');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown,
        title: TextField(
          controller: _controller,
          onChanged: (value) {
            if (value.isNotEmpty) {
              _getSuggestions(value);
            }
          },
          onSubmitted: (value) {
            if (value.isNotEmpty) {
              _search(value);
            }
          },
          decoration: const InputDecoration(
            hintText: 'Search',
            border: InputBorder.none,
            fillColor: Colors.white,
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: _suggestions.length,
        itemBuilder: (context, index) {
          final title = _suggestions[index];
          return ListTile(
            title: Text(title),
          );
        },
      ),
    );
  }
}
