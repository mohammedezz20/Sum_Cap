import 'dart:convert';
import 'dart:developer';

import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:http/http.dart' as http;
import 'package:sum_cap/core/utils/api_constants.dart';

import '../../../app_layout/data/models/audio_model.dart';

abstract class AudioRemoteDataSource {
  Future<http.Response> deleteAudio(String id);
  Future<http.Response> updateAudio(AudioModel audioModel);

  Future<String> translateText(String text);
  Future<String> summarizeText(String text, isArabic);
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
    final url = Uri.parse('$baseUrl${audioModel.audioId}');
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

  @override
  Future<String> summarizeText(text, isArabic) async {
    String apiKey = 'AIzaSyAZ9fB6JQB_FyuuQtaatHaGDFIRhMBaWDY';
    final model = GenerativeModel(model: 'gemini-pro', apiKey: apiKey);

    String prompt =
        isArabic ? '$text summarize this in arabic' : '$text summarize this';
    final content = [Content.text(prompt)];
    final response = await model.generateContent(content);
    return response.text!;
  }

  @override
  Future<String> translateText(text) async {
    String apiKey = 'AIzaSyAZ9fB6JQB_FyuuQtaatHaGDFIRhMBaWDY';
    final model = GenerativeModel(model: 'gemini-pro', apiKey: apiKey);

    String prompt = '$text translate this to arabic';
    final content = [Content.text(prompt)];
    final response = await model.generateContent(content);
    return response.text!;
  }
}
