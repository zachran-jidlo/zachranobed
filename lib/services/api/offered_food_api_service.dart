import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:zachranobed/auth_token.dart';
import 'package:zachranobed/models/food_info.dart';
import 'package:zachranobed/models/offered_food.dart';
import 'package:zachranobed/services/helper_service.dart';
import 'package:zachranobed/shared/constants.dart';

class OfferedFoodApiService {
  final String _urlBase = ZachranObedStrings.tabidooApiUrlBase;

  Future<List<OfferedFood>> getOfferedFoodList(
      {required int limit, required String filter}) async {
    final response = await http.get(
      Uri.parse(
          '$_urlBase/zachranobed_test/tables/nabidka_2/data?limit=$limit&filter=$filter'),
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $tabidooAuthToken',
      },
    );
    final responseJson = jsonDecode(response.body);
    final List<dynamic> responseData = responseJson['data'];

    if (response.statusCode == 200) {
      return responseData.map((food) => OfferedFood.fromJson(food)).toList();
    } else {
      throw Exception(
          'Failed to load offered food with error ${response.body}');
    }
  }

  Future<http.Response> createOffer(
    String id,
    DateTime date,
    FoodInfo foodInfo,
    String packaging,
    DateTime consumeBy,
    String donorId,
  ) async {
    final offeredFood = OfferedFood(
      id: id,
      date: date,
      foodInfo: foodInfo,
      packaging: packaging,
      consumeBy: consumeBy,
      weekNumber: HelperService.getCurrentWeekNumber,
      donorId: donorId,
    );

    final response = await http.post(
      Uri.parse('$_urlBase/zachranobed_test/tables/nabidka_2/data'),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: 'Bearer $tabidooAuthToken',
      },
      body: jsonEncode(offeredFood.toJson()),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return response;
    } else {
      throw Exception('Failed to create an offer with error ${response.body}');
    }
  }
}
