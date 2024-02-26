import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:sum_cap/core/utils/api_constants.dart';

import '../../../app_layout/data/models/audio_model.dart';

abstract class AudioRemoteDataSource {
  Future<http.Response> deleteAudio(String id);
  Future<http.Response> updateAudio(AudioModel audioModel);
}

class AudioRemoteDataSourceImpl extends AudioRemoteDataSource {
  @override
  Future<http.Response> deleteAudio(String id) async {
    final response = await http.delete(
      Uri.parse("${APIConstants.baseUrl}${APIConstants.deleteAudio}$id"),
      headers: {'Content-Type': 'application/json'},
    );
    return response;
  }

  @override
  Future<http.Response> updateAudio(AudioModel audioModel) async {
    const baseUrl = '${APIConstants.baseUrl}${APIConstants.editAudio}';
    final url = Uri.parse('$baseUrl${audioModel.id}');
    log(audioModel.title);
    final requestBody = jsonEncode({
      'transcriptionText': audioModel.transcriptionText,
      'title': audioModel.title,
    });

    final response = await http.patch(
      url,
      headers: {'Content-Type': 'application/json'},
      body: requestBody,
    );
    return response;
  }
}
