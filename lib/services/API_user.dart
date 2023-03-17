import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:zachranobed/auth_token.dart';
import 'package:zachranobed/models/user.dart';

class ApiUser {
  final String _urlBase =
      'https://private-anon-210691e42e-tabidoo.apiary-proxy.com/api/v2/apps';

  Future<User?> logIn({required String email}) async {
    final response = await http.get(
      Uri.parse(
          '$_urlBase/zachranobed_test/tables/darci/data?filter=email(eq)$email'),
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
      throw Exception(
          'Failed to load offered food with error ${response.body}');
    }
  }
}
