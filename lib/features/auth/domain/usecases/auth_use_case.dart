import 'package:dartz/dartz.dart';
import 'package:sum_cap/core/error_handling.dart';
import 'package:sum_cap/features/auth/domain/repositories/auth_repo.dart';

import '../../../../dependcy_injection.dart';

class AuthUseCase {
  final _repo = sl<AuthRepo>();
  Future<Either<Failure, Map<String, dynamic>>> login(
      {required String email, required String password}) async {
    return await _repo.login(email, password);
  }

  Future<Either<Failure, Map<String, dynamic>>> register({
    required String userName,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    return await _repo.register(userName, email, password, confirmPassword);
  }

  Future<Either<Failure, Map<String, dynamic>>> forgetPassword({
    required String email,
  }) async {
    return await _repo.forgetPassword(email: email);
  }

  Future<Either<Failure, Map<String, dynamic>>> verifyCode({
    required String email,
    required String verificationCode,
  }) async {
    return await _repo.verifyCode(
        email: email, verificationCode: verificationCode);
  }

  Future<Either<Failure, Map<String, dynamic>>> resetPassword({
    required String accessToken,
    required String oldPassword,
    required String newPassword,
  }) async {
    return await _repo.resetPassword(
        accessToken: accessToken,
        oldPassword: oldPassword,
        newPassword: newPassword);
  }
}
