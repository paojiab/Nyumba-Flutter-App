import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:nyumba/models/category.dart' as my;
import 'package:nyumba/models/rental.dart';
import 'package:nyumba/providers/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SpesnowProvider {
  final String _baseUrl = 'http://127.0.0.1:8000/api/v1/';
  // final String _baseUrl = "http://10.0.2.2:8000/api/v1/";
  // final String _imgUrl='http://mark.dbestech.com/uploads/';
  // getImage(){
  //   return _imgUrl;
  // }
//   postData(data, endpoint) async {
//     var fullUrl = _baseUrl + endpoint + await _getToken();
//     return await http.post(Uri.parse(fullUrl),
//         body: jsonEncode(data), headers: _setHeaders());
//   }

//   getData(endpoint) async {
//     var fullUrl = _baseUrl + endpoint + await _getToken();
//     return await http.get(Uri.parse(fullUrl), headers: _setHeaders());
//   }

//   _setHeaders() => {
//         'Content-type': 'application/json',
//         'Accept': 'application/json',
//       };

//   _getToken() async {
//     SharedPreferences localStorage = await SharedPreferences.getInstance();
//     var token = localStorage.getString('token');
//     return '?token=$token';
//   }

//   getArticles(endpoint) async {}

//   getPublicData(endpoint) async {
//     http.Response response = await http.get(Uri.parse(_baseUrl + endpoint));
//     try {
//       if (response.statusCode == 200) {
//         return response;
//       } else {
//         return 'failed';
//       }
//     } catch (e) {
//       print(e);
//       return 'failed';
//     }
//   }

//   Future<my.Category> fetchCategory(endpoint) async {
//   final response =
//       await http.get(Uri.parse(_baseUrl + endpoint));

//   if (response.statusCode == 200) {
//     // If the server did return a 200 OK response,
//     // then parse the JSON.
//     final body = jsonDecode(response.body);
//     // return my.Category.fromJson(body["data"]);
//     return my.Category.fromJson(body);
//   } else {
//     // If the server did not return a 200 OK response,
//     // then throw an exception.
//     throw Exception('Failed to load category');
//   }
// }

  Future<Rental> fetchRental(endpoint) async {
    final response = await http.get(Uri.parse(_baseUrl + endpoint));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      final body = jsonDecode(response.body);
      return Rental.fromJson(body);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load rental');
    }
  }

  Future<bool> authCheck() async {
    final response = await http.get(Uri.parse("${_baseUrl}auth/check"));

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  // Function to login
  Future login(String email, String password) async {
    final url = Uri.parse('${_baseUrl}login');
    final body = {
      'email': email,
      'password': password,
    };
    final response = await http.post(url, body: body);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print(data);
      final token = data['token'];
      final id = data['id'];
      final name = data['name'];

      // Store the token
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('token', token);
      prefs.setString('email', email);
      prefs.setString('name', name);
      prefs.setInt('user_id', id);
    } else {
      throw Exception('Failed to login');
    }
  }

  // Function to Logout
  Future logout(String token) async {
    final url = Uri.parse('${_baseUrl}logout');

    final response = await http.post(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      // remove the token
      final prefs = await SharedPreferences.getInstance();
      prefs.remove('token');
      prefs.remove('email');
      prefs.remove('user_id');
      print('Logged out');
      return true;
    } else {
      print(response.statusCode);
      throw Exception('Failed to logout');
    }
  }

  Future<bool> checkFavorite(int rentalId) async {
    final url = Uri.parse("${_baseUrl}favorites/check?rental_id=$rentalId");

    final prefs = await SharedPreferences.getInstance();

    final String? token = prefs.getString('token');

    final response = await http.post(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> subscriptionCheck() async {
    final url = Uri.parse("${_baseUrl}users/subscription/check");

    final prefs = await SharedPreferences.getInstance();

    final String? token = prefs.getString('token');

    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      print("true");
      return true;
    } else {
      print(response.statusCode);
      return false;
    }
  }

  Future<bool> addFavorite(int rentalId) async {
    final url = Uri.parse('${_baseUrl}favorites');

    final prefs = await SharedPreferences.getInstance();

    final String? token = prefs.getString('token');

    final body = {
      "rental_id": rentalId.toString(),
    };

    final response = await http.post(
      url,
      body: body,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Failed to add favorite');
    }
  }

  Future<bool> removeFavorite(int rentalId) async {
    final url = Uri.parse('${_baseUrl}favorites/null');

    final prefs = await SharedPreferences.getInstance();

    final String? token = prefs.getString('token');

    final body = {
      "rental_id": rentalId.toString(),
    };

    final response = await http.delete(
      url,
      body: body,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Failed to remove favorite');
    }
  }

  Future<List<my.Category>> fetchCategories(http.Client client) async {
    final response = await client.get(Uri.parse('${_baseUrl}categories'));
    // Use the compute function to run parseCategories in a separate isolate.
    return compute(parseCategories, response.body);
  }

// A function that converts a response body into a List<my.Category>.
  List<my.Category> parseCategories(String responseBody) {
    final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

    return parsed
        .map<my.Category>((json) => my.Category.fromJson(json))
        .toList();
  }

  List<Rental> parseRentals(String responseBody) {
    final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

    return parsed.map<Rental>((json) => Rental.fromJson(json)).toList();
  }

  Future<List<Rental>> fetchFavoriteRentals(http.Client client) async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');

    final url = Uri.parse('${_baseUrl}favorites');

    final response = await http.get(
      url,
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      },
    );
    return compute(parseRentals, response.body);
  }

  Future<List<Rental>> fetchCategoryRentals(http.Client client, id) async {
    final response =
        await client.get(Uri.parse("${_baseUrl}categories/$id/rentals"));
    return compute(parseRentals, response.body);
  }

  Future<List<Rental>> fetchSearchRentals(http.Client client, search) async {
    final response =
        await client.get(Uri.parse(_baseUrl + "rentals?search=" + search));
    return compute(parseRentals, response.body);
  }

  Future<List<Rental>> fetchSortedRentals(http.Client client, search, sortPrice) async {
    final url = Uri.parse(_baseUrl + "rentals?search=" + search + "&sortPrice=" + sortPrice);
    final response =
        await client.get(url);
    return compute(parseRentals, response.body);
  }

  Future<List<Rental>> fetchLatestRentals(http.Client client) async {
    final response = await client.get(Uri.parse("${_baseUrl}rentals/latest"));
    return compute(parseRentals, response.body);
  }

  Future<List<Rental>> fetchNearestRentals(
      http.Client client, long, lat) async {
    final response = await client
        .get(Uri.parse("${_baseUrl}rentals/nearest?lat=$lat&long=$long"));
    return compute(parseRentals, response.body);
  }

  // Future<List<Rental>> fetchSortedRentals(http.Client client, endpoint) async {
  //   final response =
  //       await client.get(Uri.parse("${_baseUrl}query?sort=$endpoint"));
  //   return compute(parseRentals, response.body);
  // }
}
