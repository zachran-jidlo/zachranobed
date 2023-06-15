import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:zachranobed/auth_token.dart';
import 'package:zachranobed/models/delivery.dart';
import 'package:zachranobed/shared/constants.dart';

class DeliveryApiService {
  final String _urlBase = ZachranObedStrings.tabidooApiUrlBase;

  Future<Delivery> getDelivery({required String filter}) async {
    final response = await http.get(
      Uri.parse('$_urlBase/zachranobed/tables/rozvozy/data?filter=$filter'),
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $tabidooAuthToken',
      },
    );
    final responseJson = jsonDecode(response.body);
    final List<dynamic> responseData = responseJson['data'];

    if (response.statusCode == 200) {
      return Delivery.fromJson(responseData[0]);
    } else {
      throw Exception('Failed to get delivery with error ${response.body}');
    }
  }

  Future<void> updateDeliveryStatus(String id, String state) async {
    final response = await http.patch(
      Uri.parse('$_urlBase/zachranobed/tables/rozvozy/data/$id'),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: 'Bearer $tabidooAuthToken',
      },
      body: jsonEncode({
        'fields': {'stav': state}
      }),
    );

    if (response.statusCode != 200) {
      throw Exception(
          'Failed to update delivery state with error ${response.body}');
    }
  }
}
