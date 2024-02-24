import 'package:dartz/dartz.dart';
import 'package:sum_cap/core/error_handling.dart';

abstract class AuthRepo {
  Future<Either<Failure, Map<String, dynamic>>> login(
      String email, String password);
  Future<Either<Failure, Map<String, dynamic>>> register(
    String userName,
    String email,
    String password,
    String confirmPassword,
  );
  Future<Either<Failure, Map<String, dynamic>>> forgetPassword(
      {required String email});
  Future<Either<Failure, Map<String, dynamic>>> verifyCode({
    required String email,
    required String verificationCode,
  });
  Future<Either<Failure, Map<String, dynamic>>> resetPassword({
    required String accessToken,
    required String oldPassword,
    required String newPassword,
  });
}
