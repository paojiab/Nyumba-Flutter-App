import 'dart:convert';

import 'package:http/http.dart' as http;

const _baseUrl = "https://ms-a967dd46a651-1819.lon.meilisearch.io";
const indexUID = "rentals_index";
const _token = "6870b7a3c9ca9077bf5e3b263bb9fc3e6f0ae94b";
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
