import 'package:sum_cap/core/cach_helper.dart';

class UserModel {
  String? id;
  final String username;
  final String email;
  final String password;
  final String passwordConfirm;
  final String? token;

  UserModel({
    this.id,
    required this.username,
    required this.email,
    required this.password,
    required this.passwordConfirm,
    this.token,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'],
      username: json['username'],
      email: json['email'],
      password: json['password'],
      passwordConfirm: json['passwordConfirm'],
      token: json['token'],
    );
  }

  Map<String, dynamic> toJson() => {
        'username': username,
        'email': email,
        'password': password,
        'passwordConfirm': passwordConfirm,
      };

  @override
  String toString() =>
      'UserModel(id: $id, username: $username, email: $email, token: $token)';

  UserModel copyWith({
    String? id,
    String? username,
    String? email,
    String? password,
    String? passwordConfirm,
    String? token,
  }) {
    return UserModel(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      password: password ?? this.password,
      passwordConfirm: passwordConfirm ?? this.passwordConfirm,
      token: token ?? this.token,
    );
  }

  Future<void> saveToCashe() async {
    CachHelper.saveData(key: 'token', value: token);
    CachHelper.saveData(key: 'id', value: id);
    CachHelper.saveData(key: 'username', value: username);
    CachHelper.saveData(key: 'email', value: email);
    CachHelper.saveData(key: 'password', value: password);
  }
}
