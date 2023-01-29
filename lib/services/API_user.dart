import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:zachranobed/models/user.dart';

class ApiUser {

  final String _urlBase = 'https://private-anon-210691e42e-tabidoo.apiary-proxy.com/api/v2/apps';
  final String _authToken = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIyZmI5MDZhMC1iMTk4LTRlMmEtYmMwMi0xOWVmZTViZDQ2MzgiLCJ1bmlxdWVfbmFtZSI6Imt1YmEudGlta29Ac2V6bmFtLmN6IiwicHVycG9zZSI6IkFQSVRva2VuIiwiYXBpVG9rZW5JZCI6ImE4N2JmYWY4LWY4MGYtNGJlOC1iOWY4LTg0NWE2YjU3NDA0YSIsIm5iZiI6MTY3NDM3ODM1MSwiZXhwIjo0ODMwMDUxOTUxLCJpYXQiOjE2NzQzNzgzNTF9._ksUc1NrUsRGUREG0lEXVNIJc5gGq9S8vsSeHviifh0';

  Future<User> logIn({required String email}) async {
    final response = await http.get(
      Uri.parse('$_urlBase/zachranobed_test/tables/darci/data?filter=email(eq)$email'),
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $_authToken',
      },
    );
    final responseJson = jsonDecode(response.body);
    final List<dynamic> responseData = responseJson['data'];

    if (response.statusCode == 200) {
      if (responseData.isNotEmpty) {
        return User.fromJson(responseData[0]);
      } else {
        return User.empty();
      }
    } else {
      throw Exception('Failed to load offered food with error ${response.body}');
    }
  }
}
