import 'package:dartz/dartz.dart';

import 'package:sum_cap/core/error_handling.dart';

import '../../../../dependcy_injection.dart';
import '../../domain/repositories/auth_repo.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepoImpl extends AuthRepo {
  final _api = sl<AuthRemoteDataSource>();

  @override
  Future<Either<Failure, Map<String, dynamic>>> login(
      String email, String password) async {
    try {
      final response = await _api.login(email, password);
      return Right(response);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> register(
    String userName,
    String email,
    String password,
    String confirmPassword,
  ) async {
    try {
      final response =
          await _api.register(userName, email, password, confirmPassword);
      return Right(response);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> forgetPassword(
      {required String email}) async {
    try {
      final response = await _api.forgetPassword(email: email);
      return Right(response);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> resetPassword(
      {required String accessToken,
      required String oldPassword,
      required String newPassword}) async {
    try {
      final response = await _api.updatePassword(
          accessToken: accessToken,
          oldPassword: oldPassword,
          newPassword: newPassword);
      return Right(response);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> verifyCode(
      {required String email, required String verificationCode}) async {
    try {
      final response = await _api.verifyCode(
          email: email, verificationCode: verificationCode);
      return Right(response);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
