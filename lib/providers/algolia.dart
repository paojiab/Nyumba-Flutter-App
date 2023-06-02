import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AlgoliaProvider {
  final apiKey = dotenv.env['ALGOLIA_SECRET'] ?? "";
  final appId = dotenv.env['ALGOLIA_APP_ID'] ?? "";

  Future fetchQueries(String query, String rightIndex, String? filters) async {
    final indexName = rightIndex;
    final url = 'https://$appId.algolia.net/1/indexes/$indexName/query?';
    final response = await http.post(Uri.parse(url),
        headers: {
          'Content-Type': 'application/json; charset=utf-8',
          'X-Algolia-API-Key': apiKey,
          'X-Algolia-Application-Id': appId,
        },
        body: json.encode({
          'params':
              'query=$query&clickAnalytics=true&facets=*&filters=$filters',
        }));
    final result = json.decode(response.body);
    return result;
  }

  Future fetchQuerySuggestions(String query) async {
    const indexName = 'firestore_rental_query_suggestions';
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
      print(response.statusCode);
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
                "index": "firestore_rentals",
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

  Future<List<dynamic>> nearestRentals(Map<String, double> geoLoc) async {
    const distance = 5000; //5KM
    const indexName = "firestore_rentals";
    final url = 'https://$appId.algolia.net/1/indexes/$indexName/query?';
      final response = await http.post(Uri.parse(url),
          headers: {
            'Content-Type': 'application/json; charset=utf-8',
            'X-Algolia-API-Key': apiKey,
            'X-Algolia-Application-Id': appId,
          },
          body: json.encode({
            'params':
                'aroundLatLng=${geoLoc["lat"]},${geoLoc["lng"]}&aroundRadius=$distance',
          }));

      final hits = jsonDecode(response.body)["hits"];
      return hits;
  }
}
