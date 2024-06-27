part of 'auth_cubit.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class AuthVisiblePasswordOnState extends AuthState {}

class AuthVisiblePasswordOffState extends AuthState {}

//!Login

class AuthLoginLoadingState extends AuthState {}

class AuthLoginSuccessState extends AuthState {
  final UserModel user;

  AuthLoginSuccessState(this.user) {
    GlobalVar.user = user;
    user.saveToCashe();
    SharedPrefHelper.saveData(key: 'isLogin', value: true);
  }

  @override
  List<Object> get props => [user];
}

class AuthLoginErrorState extends AuthState {
  final String message;

  const AuthLoginErrorState(this.message);

  @override
  List<Object> get props => [message];
}

//!Register

class AuthRegisterLoadingState extends AuthState {}

class AuthRegisterSuccessState extends AuthState {
  final UserModel user;

  AuthRegisterSuccessState(this.user) {
    GlobalVar.user = user;
    user.saveToCashe();
  }

  @override
  List<Object> get props => [user];
}

class AuthRegisterErrorState extends AuthState {
  final String message;

  const AuthRegisterErrorState(this.message);

  @override
  List<Object> get props => [message];
}

class AuthForGetPasswordLoadingState extends AuthState {}

class AuthForGetPasswordSuccessState extends AuthState {
  final String message;
  const AuthForGetPasswordSuccessState(this.message);
  @override
  List<Object> get props => [message];
}

class AuthForGetPasswordFailerState extends AuthState {
  final String message;

  const AuthForGetPasswordFailerState(this.message);
  @override
  List<Object> get props => [message];
}

class AuthResetPasswordLoadingState extends AuthState {}

class AuthResetPasswordSuccessState extends AuthState {
  final String message;
  const AuthResetPasswordSuccessState(this.message);
  @override
  List<Object> get props => [message];
}

class AuthResetPasswordFailerState extends AuthState {
  final String message;

  const AuthResetPasswordFailerState(this.message);
  @override
  List<Object> get props => [message];
}

class AuthVerifyCodeLoadingState extends AuthState {}

class AuthVerifyCodeSuccessState extends AuthState {
  final String message;
  String oldPassword;
  String token;
  AuthVerifyCodeSuccessState({
    required this.message,
    required this.oldPassword,
    required this.token,
  });
  @override
  List<Object> get props => [message];
}

class AuthVerifyCodeFailerState extends AuthState {
  final String message;

  const AuthVerifyCodeFailerState(this.message);
  @override
  List<Object> get props => [message];
}
