// ignore: depend_on_referenced_packages
import 'package:convert/convert.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:uuid/uuid.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_3des/flutter_3des.dart';

const _baseURL = "https://api.flutterwave.com/v3";

final _token = dotenv.env['FLW_SECRET_KEY'];

final _headers = {
  'Authorization': 'Bearer $_token',
  'Content-Type': 'application/json',
};

String _hexString(String string) {
  var bytes = utf8.encode(string);
  final hexString = hex.encode(bytes);
  return hexString;
}

int _keys(charged) {
  int keys;
  switch (charged) {
    case 5000:
      keys = 45;
      break;
    case 10000:
      keys = 90;
      break;
    case 20000:
      keys = 200;
      break;
    default:
      keys = 540;
  }
  return keys;
}

class flutteraveProvider {
  Future<dynamic> initiatePayment(
      String name, String email, String phoneNumber, int amount) async {
    final url = Uri.parse("$_baseURL/charges?type=mobile_money_uganda");

    Map<String, dynamic> body = {
      "currency": "UGX",
      "amount": amount,
      "phone_number": "07$phoneNumber",
      "email": email,
      "fullname": name,
      "tx_ref": const Uuid().v1(),
    };

    final response =
        await http.post(url, headers: _headers, body: json.encode(body));

    final String link =
        json.decode(response.body)["meta"]["authorization"]["redirect"];

    final initial = {"link": link, "tx_ref": "${body['tx_ref']}"};

    return initial;
  }

  Future getTransaction(String txRef) async {
    final url =
        Uri.parse("$_baseURL/transactions/verify_by_reference?tx_ref=$txRef");
    try {
      final response = await http.get(url, headers: _headers);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)["data"];
        final charged = data["charged_amount"];
        final purchasedKeys = _keys(charged);
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        final int initialKeys = prefs.getInt('keys') ?? 0;
        await prefs.setInt('keys', initialKeys + purchasedKeys);
        final transaction = {
          "status": data["status"],
          "currency": data["currency"],
          "charged": charged,
          "reference": data["flw_ref"],
          "timestamp": data["created_at"],
          "phoneNumber": data["customer"]["phone_number"],
          "tokens": purchasedKeys
        };
        return transaction;
      } else {
        print("A ${response.statusCode} error has ocurred");
      }
    } catch (e) {
      print("Error is $e");
    }
  }

  initiateCardPayment() async {
    Map<String, dynamic> details = {
      "card_number": "4187427415564246",
      "cvv": "828",
      "expiry_month": "09",
      "expiry_year": "32",
      "currency": "UGX",
      "amount": "5000",
      "fullname": "Yolande Aglaé Colbert",
      "email": "user@example.com",
      "tx_ref": "MC-3243e",
    };
    final plainBody = jsonEncode(details);
    const plainKey = "FLWSECK_TEST292000a9eaae";
    String key = _hexString(plainKey);
    String iv = _hexString("12345678");

    var encryptedBody =
        await Flutter3des.encryptToBase64(plainBody, key, iv: iv);

    try {
      final url = Uri.parse("$_baseURL/charges?type=card");
      final response =
          await http.post(url, headers: _headers, body: encryptedBody);
      final result = jsonDecode(response.body);
      print(result);
      if (response.statusCode != 200) {
        print("Error with code ${response.statusCode}");
      }
    } catch (e) {
      print(e);
    }
  }
}
