import 'package:get_it/get_it.dart';
import 'package:sum_cap/features/app_layout/data/datasources/app_layout_remote_datasorce.dart';
import 'package:sum_cap/features/app_layout/data/repositories/app_layout_repo_impl.dart';
import 'package:sum_cap/features/app_layout/domain/usecases/app_layout_use_case.dart';
import 'package:sum_cap/features/app_layout/presentation/cubit/app_layout_cubit.dart';
import 'package:sum_cap/features/app_layout/presentation/pages/app_layout.dart';
import 'package:sum_cap/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:sum_cap/features/auth/data/repositories/auth_repo_impl.dart';
import 'package:sum_cap/features/auth/domain/repositories/auth_repo.dart';
import 'package:sum_cap/features/auth/presentation/cubit/auth_cubit.dart';

import 'features/app_layout/domain/repositories/app_layout_repo.dart';
import 'features/auth/domain/usecases/auth_use_case.dart';

var sl = GetIt.instance;

Future<void> init() async {
  //!Auth
  //cubit
  sl.registerFactory(() => AuthCubit());
  //usecase
  sl.registerLazySingleton(() => AuthUseCase());
  //repo
  sl.registerLazySingleton<AuthRepo>(() => AuthRepoImpl());
  //datasource
  sl.registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl());
  //!AppLayout
  //cubit
  sl.registerFactory(() => AppLayoutCubit());
  //usecase
  sl.registerLazySingleton(() => AppLayoutUseCase());
  //repo
  sl.registerLazySingleton<AppLayoutRepo>(() => AppLayoutRepoImpl());
  //datasource
  sl.registerLazySingleton<AppLayoutRemoteDataSource>(
      () => AppLayoutRemoteDataSourceImpl());
}
