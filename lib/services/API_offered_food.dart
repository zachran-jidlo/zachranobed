import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:zachranobed/models/offered_food.dart';

class ApiOfferedFood {

  final String _urlBase = 'https://private-anon-210691e42e-tabidoo.apiary-proxy.com/api/v2/apps';
  final String _authToken = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIyZmI5MDZhMC1iMTk4LTRlMmEtYmMwMi0xOWVmZTViZDQ2MzgiLCJ1bmlxdWVfbmFtZSI6Imt1YmEudGlta29Ac2V6bmFtLmN6IiwicHVycG9zZSI6IkFQSVRva2VuIiwiYXBpVG9rZW5JZCI6ImE4N2JmYWY4LWY4MGYtNGJlOC1iOWY4LTg0NWE2YjU3NDA0YSIsIm5iZiI6MTY3NDM3ODM1MSwiZXhwIjo0ODMwMDUxOTUxLCJpYXQiOjE2NzQzNzgzNTF9._ksUc1NrUsRGUREG0lEXVNIJc5gGq9S8vsSeHviifh0';

  Future<List<OfferedFood>> getOfferedFoodList(int limit) async {
    final response = await http.get(
      Uri.parse('$_urlBase/zachranobed_test/tables/nabidka_2/data?limit=$limit'),
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $_authToken',
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
      DateTime consumeBy) async {

    var data = {
      "fields": {
        "x_ID": id,
        "pridanoDne": date.toIso8601String(),
        "nazevPokrmu": name,
        "alergeny": allergens,
        "pocetPorci": numberOfServings,
        "baleni": packaging,
        "spotrebujteDo": consumeBy.toIso8601String()
      }
    };

    final response = await http.post(
      Uri.parse('$_urlBase/zachranobed_test/tables/nabidka_2/data'),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: 'Bearer $_authToken',
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
