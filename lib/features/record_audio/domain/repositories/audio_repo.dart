import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:sum_cap/core/error_handling.dart';
import 'package:sum_cap/features/app_layout/data/models/audio_model.dart';

abstract class AudioRepo {
  Future<Either<Failure, http.Response>> deleteAudio(String id);
  Future<Either<Failure, http.Response>> updateAudio(AudioModel audioModel);
  Future<Either<Failure, String>> translateText(String text);
  Future<Either<Failure, String>> summarizeText(String text);

  Future<Either<Failure, String>> askChatBot(
      String text, String message, bool isRelated);
}
