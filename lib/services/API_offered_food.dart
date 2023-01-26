import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:zachranobed/models/offered_food.dart';

class APIofferedFood {

  final String _urlBase = 'https://private-anon-210691e42e-tabidoo.apiary-proxy.com/api/v2/';
  final String _authToken = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIyZmI5MDZhMC1iMTk4LTRlMmEtYmMwMi0xOWVmZTViZDQ2MzgiLCJ1bmlxdWVfbmFtZSI6Imt1YmEudGlta29Ac2V6bmFtLmN6IiwicHVycG9zZSI6IkFQSVRva2VuIiwiYXBpVG9rZW5JZCI6ImE4N2JmYWY4LWY4MGYtNGJlOC1iOWY4LTg0NWE2YjU3NDA0YSIsIm5iZiI6MTY3NDM3ODM1MSwiZXhwIjo0ODMwMDUxOTUxLCJpYXQiOjE2NzQzNzgzNTF9._ksUc1NrUsRGUREG0lEXVNIJc5gGq9S8vsSeHviifh0';

  Future<List<OfferedFood>> getOfferedFoodList(int limit) async {
    final response = await http.get(
      Uri.parse('${_urlBase}apps/zachranobed_test/tables/nabidka_2/data?limit=$limit'),
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $_authToken',
      },
    );
    final responseJson = jsonDecode(response.body);
    final List<dynamic> data = responseJson['data'];

    if (response.statusCode == 200) {
      return data.map((food) => OfferedFood.fromJson(food)).toList();
    } else {
      throw Exception('Failed to load offered food');
    }
  }
}
