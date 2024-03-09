import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sum_cap/bloc_observer.dart';
import 'package:sum_cap/core/cach_helper.dart';
import 'package:sum_cap/runapp.dart';
import 'package:sum_cap/dependcy_injection.dart' as di;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = MyBlocObserver();
  await di.init();
  await CachHelper.init();
  bool? isLogin = CachHelper.getData(key: 'isLogin') ?? false;
  runApp(MainApp(
    isLogin: isLogin!,
  ));
}
