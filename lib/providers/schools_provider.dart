import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:spesnow/models/school.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class SchoolProvider {
  // get nearby Schools
  Future<List<SchoolModel>> getNearbySchools(String institute, double latitude, double longitude) async {
    final apiKey = dotenv.get('GOOGLE_MAPS_API_KEY');
    LatLng location = LatLng(latitude, longitude);
    const radius = '5000'; // in meters
    final type = institute;
    const rankBy = 'distance';

    final url = 'https://maps.googleapis.com/maps/api/place/nearbysearch/json'
        '?location=${location.latitude},${location.longitude}'
        '&radius=$radius'
        '&type=$type'
        '&rankBy=$rankBy'
        '&key=$apiKey';

    final response = await http.get(Uri.parse(url));

    // return compute(parseSchools, response.body);

    final data = json.decode(response.body);

    // final schools = List<Map<String, dynamic>>.from(data['results']);

    final schools =
        List<SchoolModel>.from(data['results'].map((result) => SchoolModel(
              name: result['name'],
            )));

    return schools;
  }
  // end get near by schools

  List<SchoolModel> parseSchools(String responseBody) {
    final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

    return parsed
        .map<SchoolModel>((json) => SchoolModel.fromJson(json))
        .toList();
  }
}
