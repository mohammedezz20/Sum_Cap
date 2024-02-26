import 'package:dartz/dartz.dart';
import 'package:http/src/response.dart';
import 'package:sum_cap/core/error_handling.dart';
import 'package:sum_cap/features/app_layout/data/models/audio_model.dart';
import 'package:sum_cap/features/record_audio/data/datasources/audio_remote_data_source.dart';
import 'package:sum_cap/features/record_audio/domain/repositories/audio_repo.dart';

import '../../../../dependcy_injection.dart';

class AudioRepoImpl extends AudioRepo {
  final _api = sl<AudioRemoteDataSource>();

  @override
  Future<Either<Failure, Response>> deleteAudio(String id) async {
    try {
      var response = await _api.deleteAudio(id);
      return Right(response);
    } catch (e) {
      return Left(SystemFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Response>> updateAudio(AudioModel audioModel) async {
    try {
      var response = await _api.updateAudio(audioModel);
      return Right(response);
    } catch (e) {
      return Left(SystemFailure(message: e.toString()));
    }
  }
}
