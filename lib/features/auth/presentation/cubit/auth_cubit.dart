import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sum_cap/core/cach_helper.dart';
import 'package:sum_cap/core/global.dart';
import 'package:sum_cap/features/auth/data/models/user_model.dart';
import 'package:sum_cap/features/auth/domain/usecases/auth_use_case.dart';

import '../../../../dependcy_injection.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());
  static AuthCubit get(context) => BlocProvider.of(context);

  final _repo = sl<AuthUseCase>();

  TextEditingController emailController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  bool isPassword = true;
  IconData icon = Icons.visibility_outlined;
  changePasswordIcon() {
    if (isPassword == true) {
      icon = Icons.visibility_off_outlined;
      isPassword = false;
      emit(AuthVisiblePasswordOffState());
    } else {
      icon = Icons.visibility_outlined;
      isPassword = true;
      emit(AuthVisiblePasswordOnState());
    }
  }

//! REGISTER FUNCTION
  void register({
    required String userName,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    emit(AuthRegisterLoadingState());
    final response = await _repo.register(
      userName: userName,
      email: email,
      password: password,
      confirmPassword: confirmPassword,
    );
    response.fold((l) {
      emit(AuthRegisterErrorState(l.toString()));
    }, (r) {
      if (r['status'] != 'success') {
        emit(AuthRegisterErrorState(r['message']));
      } else {
        UserModel user = UserModel.fromJson(r['data']['user']);
        log(user.toString());
        emit(AuthRegisterSuccessState(user));
      }
    });
  }

//! LOGIN FUNCTION
  void login({
    required String email,
    required String password,
  }) async {
    emit(AuthLoginLoadingState());
    final response = await _repo.login(
      email: email,
      password: password,
    );
    response.fold((l) {
      emit(AuthLoginErrorState(l.toString()));
    }, (r) {
      if (r['status'] != 'success') {
        emit(AuthLoginErrorState(r['message']));
      } else {
        UserModel user = UserModel.fromJson(r['data']['user']);
        log(user.toString());
        emit(AuthLoginSuccessState(user));
      }
    });
  }

  String code = '000000';
  //! RESET PASSWORD Step 1
  Future<void> forgetPassword({
    required String email,
  }) async {
    emit(AuthForGetPasswordLoadingState());
    final response = await _repo.forgetPassword(email: email);
    response.fold((l) => emit(AuthForGetPasswordFailerState(l.toString())),
        (r) {
      if (r['status'] != 'success') {
        emit(AuthForGetPasswordFailerState(r['message']));
      } else {
        emit(AuthForGetPasswordSuccessState(r['message']));
      }
    });
  }

  //! RESET PASSWORD Step 2
//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
//response in  this Function is Map<String, dynamic>
// like {
//     "status": "success",
//     "message": "Verification successful",
//     "oldPassword": "Alikotsbali1965",
//     "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.      eyJlbWFpbCI6Im1vaGFtbWVkNzhlenpAZ21haWwuY29tIiwiaWQiOiI2NWNiZGU1MGJkZTk5YjJjYzQ5ZWRlOGIiLCJpYXQiOjE3MDc4NTk1MzYsImV4cCI6MTcxNTYzNTUzNn0.bhF2O8bTmZ1A2o76IUTLgiItXVevy-EbxTwjRUXdqWo"
// }
// we will use oldPassword  and token to reset password in step 3
//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

  Future<void> verifyCode({
    required String email,
    required String code,
  }) async {
    emit(AuthVerifyCodeLoadingState());
    final response =
        await _repo.verifyCode(email: email, verificationCode: code);
    response.fold((l) => emit(AuthVerifyCodeFailerState(l.toString())), (r) {
      if (r['status'] != 'success') {
        emit(AuthVerifyCodeFailerState(r['message']));
      } else {
        log(r.toString());
        emit(AuthVerifyCodeSuccessState(
          message: r['message'],
          oldPassword: r['oldPassword'],
          token: r['token'],
        ));
      }
    });
  }

  //! RESET PASSWORD Step 3
  Future<void> resetPassword({
    required String accessToken,
    required String oldPassword,
    required String newPassword,
  }) async {
    emit(AuthResetPasswordLoadingState());
    final response = await _repo.resetPassword(
        accessToken: accessToken,
        oldPassword: oldPassword,
        newPassword: newPassword);
    response.fold((l) => emit(AuthResetPasswordFailerState(l.toString())), (r) {
      if (r['status'] != 'success') {
        emit(AuthResetPasswordFailerState(r['message']));
      } else {
        log(r.toString());
        emit(AuthResetPasswordSuccessState(r['message']));
      }
    });
  }
}
