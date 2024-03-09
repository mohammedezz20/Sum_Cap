import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:sum_cap/core/error_handling.dart';
import 'package:sum_cap/dependcy_injection.dart';
import 'package:sum_cap/features/user_profile/data/datasources/user_remote_data_source.dart';
import 'package:sum_cap/features/user_profile/domain/repositories/user_repo.dart';

class UserRepoImpl implements UserRepository {
  final _api = sl<UserRemoteDataSource>();

  @override
  Future<Either<Failure, Map<String, dynamic>>> editUser(
      String accessToken, String username) async {
    try {
      var response = await _api.editUser(accessToken, username);
      return Right(response);
    } catch (e) {
      return Left(SystemFailure(message: e.toString()));
    }
  }

  @override
  Future<http.Response> deleteUser(String accessToken) async {
    return await _api.deleteUser(accessToken);
    // try {
    //   var response = await _api.deleteUser(accessToken);
    //   return Right(response);
    // } catch (e) {
    //   return Left(SystemFailure(message: e.toString()));
    // }
  }
}
