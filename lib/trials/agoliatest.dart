import 'dart:convert';
import 'package:http/http.dart' as http;

Future<List<String>> fetchQuerySuggestions(String query) async {
  const apiKey = '1e8773c89cc1b8d55b284542c3759ab4';
  const appId = 'VB23OHDUAO';
  const indexName = 'rentals';
  const url = 'https://$appId.algolia.net/1/indexes/$indexName/query';

  final response = await http.post(Uri.parse(url),
      headers: {
        'Content-Type': 'application/json; charset=utf-8',
        'X-Algolia-API-Key': apiKey,
        'X-Algolia-Application-Id': appId,
      },
      body: json.encode({
        'params': 'query=$query&hitsPerPage=10&facets=*&facetFilters=[]',
      }));

  if (response.statusCode == 200) {
    print(json.decode(response.body));
    final suggestions =
        json.decode(response.body)['facets']['_query_suggestion'];
    return List<String>.from(suggestions);
  } else {
    throw Exception('Failed to fetch query suggestions');
  }
}
