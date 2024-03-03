import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:sum_cap/core/error_handling.dart';
import 'package:sum_cap/dependcy_injection.dart';
import 'package:sum_cap/features/user_profile/domain/repositories/user_repo.dart';

class UserUseCase {
  final _repo = sl<UserRepository>();

  Future<Either<Failure, Map<String, dynamic>>> editUser(
      String accessToken, String username) async {
    return await _repo.editUser(accessToken, username);
  }

  Future<http.Response> deleteUser(String accessToken) async {
    return await _repo.deleteUser(accessToken);
  }
}
