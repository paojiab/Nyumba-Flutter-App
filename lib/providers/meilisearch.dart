import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

const _baseUrl = "https://ms-a967dd46a651-1819.lon.meilisearch.io";
const indexUID = "rentals_index";
final _token = dotenv.env['MEILISEARCH_KEY'] as String;
final _headers = {
  'Authorization': 'Bearer $_token',
  "Accept": "application/json",
  "content-type": "application/json"
};

class Meilisearch {
  Future getFacets(query) async {
    const url = "$_baseUrl/indexes/$indexUID/search";
    final postBody = jsonEncode({
      "q": query,
      "facets": ["category"],
    });
    final response =
        await http.post(Uri.parse(url), headers: _headers, body: postBody);
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      print(body["facetDistribution"]);
      return (body["facetDistribution"]);
    } else {
      print(response.statusCode);
    }
  }
}
