import 'package:get_it/get_it.dart';
import 'package:sum_cap/features/app_layout/data/datasources/app_layout_remote_datasorce.dart';
import 'package:sum_cap/features/app_layout/data/repositories/app_layout_repo_impl.dart';
import 'package:sum_cap/features/app_layout/domain/usecases/app_layout_use_case.dart';
import 'package:sum_cap/features/app_layout/presentation/cubit/app_layout_cubit.dart';
import 'package:sum_cap/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:sum_cap/features/auth/data/repositories/auth_repo_impl.dart';
import 'package:sum_cap/features/auth/domain/repositories/auth_repo.dart';
import 'package:sum_cap/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:sum_cap/features/record_audio/data/datasources/audio_remote_data_source.dart';
import 'package:sum_cap/features/record_audio/data/repositories/audio_repo_impl.dart';
import 'package:sum_cap/features/record_audio/domain/repositories/audio_repo.dart';
import 'package:sum_cap/features/record_audio/domain/usecases/audio_usecase.dart';
import 'package:sum_cap/features/user_profile/data/datasources/user_remote_data_source.dart';
import 'package:sum_cap/features/user_profile/data/repositories/user_repo_impl.dart';
import 'package:sum_cap/features/user_profile/domain/repositories/user_repo.dart';
import 'package:sum_cap/features/user_profile/domain/usecases/user_usecases.dart';
import 'package:sum_cap/features/user_profile/presentation/cubit/user_profile_cubit.dart';

import 'features/app_layout/domain/repositories/app_layout_repo.dart';
import 'features/auth/domain/usecases/auth_use_case.dart';
import 'features/record_audio/presentation/cubit/audio_cubit.dart';

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

  //! Audio
  sl.registerFactory(() => AudioCubit());
  //usecase
  sl.registerLazySingleton(() => AudioUseCase());
  //repo
  sl.registerLazySingleton<AudioRepo>(() => AudioRepoImpl());
  //datasource
  sl.registerLazySingleton<AudioRemoteDataSource>(
      () => AudioRemoteDataSourceImpl());

  //! User profile
  //cubit
  sl.registerFactory(() => UserProfileCubit());
  //UseCase
  sl.registerLazySingleton(() => UserUseCase());
  // Repository
  sl.registerLazySingleton<UserRepository>(() => UserRepoImpl());
  // DataSource
  sl.registerLazySingleton<UserRemoteDataSource>(
      () => UserRemoteDataSourceImpl());
}
