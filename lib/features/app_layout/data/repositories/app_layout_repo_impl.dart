import 'package:dartz/dartz.dart';
import 'package:sum_cap/core/error_handling.dart';
import 'package:sum_cap/features/app_layout/data/datasources/app_layout_remote_datasorce.dart';
import 'package:sum_cap/features/app_layout/data/models/audio_model.dart';

import '../../../../dependcy_injection.dart';
import '../../domain/repositories/app_layout_repo.dart';

class AppLayoutRepoImpl extends AppLayoutRepo {
  final _api = sl<AppLayoutRemoteDataSource>();
  @override
  Future<Either<Failure, Map<String, dynamic>>> getUserAudios() async {
    try {
      var response = await _api.getUserAudios();
      return Right(response);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> transcriptAudios(
      {required String filePath}) async {
    try {
      var response = await _api.transcritpion(
        filePath: filePath,
      );
      return Right(response);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> uploadAudios(
      {required AudioModel audioModel}) async {
    try {
      var response = await _api.uploadAudio(
        audioModel: audioModel,
      );
      return Right(response);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
