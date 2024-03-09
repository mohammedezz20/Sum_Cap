import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:sum_cap/features/record_audio/domain/repositories/audio_repo.dart';

import '../../../../core/error_handling.dart';
import '../../../../dependcy_injection.dart';
import '../../../app_layout/data/models/audio_model.dart';

class AudioUseCase {
  final _repo = sl<AudioRepo>();
  Future<Either<Failure, http.Response>> deleteAudio(String id) async {
    return await _repo.deleteAudio(id);
  }

  Future<Either<Failure, http.Response>> updateAudio(
      AudioModel audioModel) async {
    return await _repo.updateAudio(audioModel);
  }

  Future<Either<Failure, String>> summarizeText(String text) async {
    return await _repo.summarizeText(text);
  }

  Future<Either<Failure, String>> translateText(String text) async {
    return await _repo.translateText(text);
  }
}
