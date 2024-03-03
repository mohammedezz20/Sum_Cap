part of 'user_profile_cubit.dart';

abstract class UserProfileState extends Equatable {
  const UserProfileState();

  @override
  List<Object> get props => [];
}

class UserProfileInitial extends UserProfileState {}

class UserLoadingState extends UserProfileState {}

class UserEditUserSuccessState extends UserProfileState {
  final String message;

  const UserEditUserSuccessState(this.message);

  @override
  List<Object> get props => [message];
}

class UserEditUserFailureState extends UserProfileState {
  final String message;

  const UserEditUserFailureState(this.message);

  @override
  List<Object> get props => [message];
}

class UserDeleteUserSuccessState extends UserProfileState {
  final String message;

  UserDeleteUserSuccessState(this.message) {}

  @override
  List<Object> get props => [message];
}

class UserDeleteUserFailureState extends UserProfileState {
  final String message;

  const UserDeleteUserFailureState(this.message);

  @override
  List<Object> get props => [message];
}

class UserLogoutState extends UserProfileState {
  const UserLogoutState();
}
