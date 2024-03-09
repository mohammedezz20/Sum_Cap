import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:sum_cap/core/error_handling.dart';

abstract class UserRepository {
  Future<Either<Failure, Map<String, dynamic>>> editUser(
      String accessToken, String username);

  Future<http.Response> deleteUser(String accessToken);
}
