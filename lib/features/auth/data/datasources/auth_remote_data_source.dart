import 'dart:convert';
import 'dart:ffi';

import 'package:sum_cap/core/utils/api_constants.dart';

import '../models/user_model.dart';
import 'package:http/http.dart' as http;

abstract class AuthRemoteDataSource {
  Future<Map<String, dynamic>> login(String email, String password);
  Future<Map<String, dynamic>> register(
    String userName,
    String email,
    String password,
    String confirmPassword,
  );
  Future<Map<String, dynamic>> forgetPassword({required String email});
  Future<Map<String, dynamic>> verifyCode({
    required String email,
    required String verificationCode,
  });
  Future<Map<String, dynamic>> updatePassword({
    required String accessToken,
    required String oldPassword,
    required String newPassword,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  @override
  Future<Map<String, dynamic>> login(String email, String password) async {
    const url = APIConstants.baseUrl + APIConstants.login;
    final finalUrl = Uri.parse(url);
    final headers = {'Content-Type': 'application/json'};
    final Map<String, dynamic> requestData = {
      "username": email,
      "password": password,
    };
    final http.Response response = await http.post(
      finalUrl,
      headers: headers,
      body: jsonEncode(requestData),
    );
    final Map<String, dynamic> responseData = jsonDecode(response.body);
    return responseData;
  }

  @override
  Future<Map<String, dynamic>> register(
    String userName,
    String email,
    String password,
    String confirmPassword,
  ) async {
    final body = jsonEncode({
      'username': userName,
      'email': email,
      'password': password,
      'passwordConfirm': confirmPassword,
    });
    const url = APIConstants.baseUrl + APIConstants.register;
    final finalUrl = Uri.parse(url);
    final headers = {'Content-Type': 'application/json'};
    final response = await http.post(
      finalUrl,
      headers: headers,
      body: body,
    );
    final Map<String, dynamic> responseData = jsonDecode(response.body);
    return responseData;
  }

  @override
  Future<Map<String, dynamic>> forgetPassword({required String email}) async {
    const url = APIConstants.baseUrl + APIConstants.forgetPassword;
    final finalUrl = Uri.parse(url);
    final Map<String, dynamic> requestData = {
      "email": email,
    };

    final http.Response response = await http.post(
      finalUrl,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(requestData),
    );
    final Map<String, dynamic> responseData = jsonDecode(response.body);
    return responseData;
  }

  @override
  Future<Map<String, dynamic>> updatePassword({
    required String accessToken,
    required String oldPassword,
    required String newPassword,
  }) async {
    const url = APIConstants.baseUrl + APIConstants.updatePassword;
    final finalUrl = Uri.parse(url);
    final Map<String, dynamic> requestData = {
      "oldPassword": oldPassword,
      "newPassword": newPassword,
    };

    final http.Response response = await http.patch(
      finalUrl,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode(requestData),
    );

    final Map<String, dynamic> responseData = jsonDecode(response.body);
    return responseData;
  }

  @override
  Future<Map<String, dynamic>> verifyCode({
    required String email,
    required String verificationCode,
  }) async {
    const url = APIConstants.baseUrl + APIConstants.verifyCode;
    final finalUrl = Uri.parse(url);
    final Map<String, dynamic> requestData = {
      "email": email,
      "verificationCode": verificationCode,
    };
    final http.Response response = await http.post(
      finalUrl,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(requestData),
    );
    final Map<String, dynamic> responseData = jsonDecode(response.body);
    return responseData;
  }
}
