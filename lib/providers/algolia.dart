import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AlgoliaProvider {
  final apiKey = dotenv.env['ALGOLIA_SECRET'] as String;
  final appId = dotenv.env['ALGOLIA_APP_ID'] as String;

  Future fetchQueries(String query, String rightIndex, String? filters) async {
    final indexName = rightIndex;
    final url = 'https://$appId.algolia.net/1/indexes/$indexName/query';

    final response = await http.post(Uri.parse(url),
        headers: {
          'Content-Type': 'application/json; charset=utf-8',
          'X-Algolia-API-Key': apiKey,
          'X-Algolia-Application-Id': appId,
        },
        body: json.encode({
          'params': 'query=$query&clickAnalytics=true&facets=*&filters=$filters',
        }));

    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      return result;
    } else {
      throw Exception('Failed to Fetch Queries');
    }
  }

  Future fetchQuerySuggestions(String query) async {
    const indexName = 'rental_suggestions';
    final url = 'https://$appId.algolia.net/1/indexes/$indexName/query';

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
      final hits = json.decode(response.body)['hits'];
      final suggestion = hits[0]['query'];
      return hits;
    } else {
      throw Exception('Failed to fetch query suggestions');
    }
  }

  Future sendEvents(
      String queryID, String objectID, int position, String userToken) async {
    const url = "https://insights.algolia.io/1/events";
    try {
      final response = await http.post(Uri.parse(url),
          headers: {
            'Content-Type': 'application/json; charset=utf-8',
            'X-Algolia-API-Key': apiKey,
            'X-Algolia-Application-Id': appId,
          },
          body: json.encode({
            "events": [
              {
                "eventType": "click",
                "eventName": "Rental Clicked",
                "index": "rentals",
                "userToken": userToken,
                "queryID": queryID,
                "objectIDs": [objectID],
                "positions": [position]
              }
            ]
          }));
      print(response.statusCode);
    } catch (e) {
      print(e);
    }
  }


}
