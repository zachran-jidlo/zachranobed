import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:zachranobed/auth_token.dart';
import 'package:zachranobed/helpers/current_week_number.dart';
import 'package:zachranobed/models/offered_food.dart';

class ApiOfferedFood {

  final String _urlBase = 'https://private-anon-210691e42e-tabidoo.apiary-proxy.com/api/v2/apps';

  Future<List<OfferedFood>> getOfferedFoodList({required int limit, required String filter}) async {
    final response = await http.get(
      Uri.parse('$_urlBase/zachranobed_test/tables/nabidka_2/data?limit=$limit&filter=$filter'),
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $tabidooAuthToken',
      },
    );
    final responseJson = jsonDecode(response.body);
    final List<dynamic> responseData = responseJson['data'];

    if (response.statusCode == 200) {
      return responseData.map((food) => OfferedFood.fromJson(food)).toList();
    } else {
      throw Exception('Failed to load offered food with error ${response.body}');
    }
  }

  Future<http.Response> createOffer(
      String id,
      DateTime date,
      String name,
      String allergens,
      int numberOfServings,
      String packaging,
      DateTime consumeBy,
      String donorID) async {

    print("User internal id: $donorID");

    var data = {
      "fields": {
        "x_ID": id,
        "pridanoDne": date.toIso8601String(),
        "nazevPokrmu": name,
        "alergeny": allergens,
        "pocetPorci": numberOfServings,
        "baleni": packaging,
        "spotrebujteDo": consumeBy.toIso8601String(),
        "cisloTydne": currentWeekNumber(),
        "darce": {
          "id": donorID
        }
      }
    };

    final response = await http.post(
      Uri.parse('$_urlBase/zachranobed_test/tables/nabidka_2/data'),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: 'Bearer $tabidooAuthToken',
      },
      body: jsonEncode(data),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return response;
    } else {
      throw Exception('Failed to create an offer with error ${response.body}');
    }
  }
}
