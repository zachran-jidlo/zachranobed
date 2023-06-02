import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:zachranobed/auth_token.dart';
import 'package:zachranobed/models/user.dart';
import 'package:zachranobed/shared/constants.dart';

class UserApiService {
  final String _urlBase = ZachranObedStrings.tabidooApiUrlBase;

  Future<User?> logIn({required String email}) async {
    final response = await http.get(
      Uri.parse(
          '$_urlBase/zachranobed/tables/darci/data?filter=polozka3(eq)$email'),
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $tabidooAuthToken',
      },
    );
    final responseJson = jsonDecode(response.body);
    final List<dynamic> responseData = responseJson['data'];

    if (response.statusCode == 200) {
      if (responseData.isNotEmpty) {
        return User.fromJson(responseData[0]);
      } else {
        return null;
      }
    } else {
      throw Exception('Failed to log in with error ${response.body}');
    }
  }
}
