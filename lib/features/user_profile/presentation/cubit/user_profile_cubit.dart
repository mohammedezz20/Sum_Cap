import 'dart:convert';
import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sum_cap/config/themes/colors.dart';
import 'package:sum_cap/core/shared_pref_helper.dart';
import 'package:sum_cap/dependcy_injection.dart';
import 'package:sum_cap/features/auth/data/models/user_model.dart';
import 'package:sum_cap/features/user_profile/domain/usecases/user_usecases.dart';

part 'user_profile_state.dart';

class UserProfileCubit extends Cubit<UserProfileState> {
  UserProfileCubit() : super(UserProfileInitial());
  final _repo = sl<UserUseCase>();
  var usernameController =
      TextEditingController(text: SharedPrefHelper.getData(key: 'username'));
  List<Map<String, dynamic>> buttonModel = [
    {
      'name': 'Save Changes',
      'color': AppColor.primaryColor,
    },
    {
      'name': 'Change Password',
      'color': AppColor.primaryColor,
    },
    {
      'name': 'Delete Account',
      'color': AppColor.redColor,
    },
    {
      'name': 'LogOut',
      'color': AppColor.redColor,
    },
  ];
  static UserProfileCubit get(context) => BlocProvider.of(context);

  void editUser(String accessToken, String username) async {
    emit(UserLoadingState());
    var response = await _repo.editUser(accessToken, username);
    response.fold(
        (l) => emit(
              UserEditUserFailureState(
                l.toString(),
              ),
            ), (r) {
      if (r['status'] != 'success') {
        emit(UserEditUserFailureState(r['message']));
      } else {
        UserModel user = UserModel.fromJson(r['data']['user']);
        log(user.username);
        SharedPrefHelper.saveData(key: 'username', value: user.username);
        usernameController.text = user.username;
        emit(UserEditUserSuccessState(user.username));
      }
    });
  }

  void deleteUser(String accessToken) async {
    emit(UserLoadingState());
    var response = await _repo.deleteUser(accessToken);
    if (response.statusCode == 204) {
      logout();
      emit(UserDeleteUserSuccessState('User deleted successfully'));
    } else {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      emit(UserDeleteUserFailureState(responseData['message']));
    }
    // responseData.fold(
    //     (l) => emit(
    //           UserDeleteUserFailureState(
    //             l.toString(),
    //           ),
    //         ), (r) {
    //   if (r['status'] == 'fail') {
    //     emit(UserDeleteUserFailureState(r['message']));
    //   } else {
    //     emit(const UserDeleteUserSuccessState('User deleted successfully'));
    //   }
    // });
  }

  void logout() {
    emit(UserLoadingState());
    SharedPrefHelper.saveData(key: 'token', value: '');
    SharedPrefHelper.saveData(key: 'email', value: '');
    SharedPrefHelper.saveData(key: 'password', value: '');
    SharedPrefHelper.saveData(key: 'username', value: '');
    SharedPrefHelper.saveData(key: 'isLogin', value: false);
    emit(const UserLogoutState());
  }
}
