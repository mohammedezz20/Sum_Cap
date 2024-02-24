import 'package:dartz/dartz.dart';
import 'package:sum_cap/core/error_handling.dart';

import '../../data/models/audio_model.dart';

abstract class AppLayoutRepo {
  Future<Either<Failure, Map<String, dynamic>>> getUserAudios();
  Future<Either<Failure, Map<String, dynamic>>> transcriptAudios({
    required String filePath,
  });
  Future<Either<Failure, String>> uploadAudios(
      {required AudioModel audioModel});
}
