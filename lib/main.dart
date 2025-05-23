import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sum_cap/bloc_observer.dart';
import 'package:sum_cap/core/shared_pref_helper.dart';
import 'package:sum_cap/runapp.dart';
import 'package:sum_cap/dependcy_injection.dart' as di;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = MyBlocObserver();
  await di.init();
  await SharedPrefHelper.init();
  bool? isLogin = SharedPrefHelper.getData(key: 'isLogin') ?? false;
  bool? isFirst = SharedPrefHelper.getData(key: 'isFirst') ?? true;
  runApp(MainApp(
    isLogin: isLogin!,
    isFirst: isFirst!,
  ));
}
