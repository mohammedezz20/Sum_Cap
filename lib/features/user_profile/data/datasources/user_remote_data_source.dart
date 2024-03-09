import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:sum_cap/core/utils/api_constants.dart';

abstract class UserRemoteDataSource {
  Future<Map<String, dynamic>> editUser(String accessToken, String username);

  Future<http.Response> deleteUser(String accessToken);
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  @override
  Future<Map<String, dynamic>> editUser(
      String accessToken, String username) async {
    const url = APIConstants.baseUrl + APIConstants.editUser;
    final finalUrl = Uri.parse(url);
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    };
    final Map<String, dynamic> requestData = {
      'username': username,
    };
    http.Response response = await http.patch(
      finalUrl,
      headers: headers,
      body: jsonEncode(requestData),
    );
    final Map<String, dynamic> responseData = jsonDecode(response.body);
    return responseData;
  }

  @override
  Future<http.Response> deleteUser(String accessToken) async {
    const url = APIConstants.baseUrl + APIConstants.deleteUser;
    final finalUrl = Uri.parse(url);
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    };
    http.Response response = await http.delete(finalUrl, headers: headers);
    // final Map<String, dynamic> responseData = jsonDecode(response.body);
    return response;
  }
}
