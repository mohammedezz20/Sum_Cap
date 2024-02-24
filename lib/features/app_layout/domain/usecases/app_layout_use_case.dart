import 'package:dartz/dartz.dart';

import 'package:sum_cap/core/error_handling.dart';
import 'package:sum_cap/features/app_layout/data/models/audio_model.dart';

import '../../../../dependcy_injection.dart';
import '../repositories/app_layout_repo.dart';

class AppLayoutUseCase {
  final _repo = sl<AppLayoutRepo>();
  Future<Either<Failure, Map<String, dynamic>>> getUserAudio() async {
    return await _repo.getUserAudios();
  }

  Future<Either<Failure, Map<String, dynamic>>> transcriptAudios({
    required String filePath,
  }) async {
    return await _repo.transcriptAudios(filePath: filePath);
  }

  Future<Either<Failure, String>> uploadAudios(
      {required AudioModel audioModel}) async {
    return await _repo.uploadAudios(
      audioModel: audioModel,
    );
  }
}
