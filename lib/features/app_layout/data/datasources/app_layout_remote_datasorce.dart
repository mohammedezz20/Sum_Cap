import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart';
import 'package:sum_cap/core/utils/api_constants.dart';
import 'package:sum_cap/features/app_layout/data/models/audio_model.dart';

import '../../../../core/shared_pref_helper.dart';

abstract class AppLayoutRemoteDataSource {
  Future<Map<String, dynamic>> getUserAudios();
  Future<Map<String, dynamic>> transcritpion({required String filePath});
  Future<String> uploadAudio({required AudioModel audioModel});
  Future<String> uploadYoutubeAudio({required AudioModel audioModel});
}

class AppLayoutRemoteDataSourceImpl implements AppLayoutRemoteDataSource {
  @override
  Future<Map<String, dynamic>> getUserAudios() async {
    final token = SharedPrefHelper.getData(key: 'token');

    final response = await http.get(
      Uri.parse(APIConstants.baseUrl + APIConstants.audio),
      headers: {'Authorization': 'Bearer $token'},
    );
    final Map<String, dynamic> responseData = jsonDecode(response.body);
    return responseData;
  }

  @override
  Future<Map<String, dynamic>> transcritpion({required String filePath}) async {
    const deepgramApiKey =
        ApiModelConstatnts.deepGramApiKey; // Replace with your actual API key
    const deepgramEndpoint = ApiModelConstatnts.deepGramBaseUrl;
    const model = 'nova-2';

    final client =
        http.Client(); // Create the client outside the try-catch block

    try {
      final file = File(filePath);
      if (!await file.exists()) {
        throw Exception('File not found: $filePath');
      }

      final request = http.MultipartRequest(
          'POST',
          Uri.parse(
              'https://api.deepgram.com/v1/listen?detect_topics=true&smart_format=true&paragraphs=true&diarize=true&language=en&model=nova-2'));
      request.headers['Authorization'] = 'Token $deepgramApiKey';
      request.files.add(http.MultipartFile.fromBytes(
          'file', file.readAsBytesSync(),
          filename: basename(filePath),
          contentType: MediaType("application", "octet-stream")));
      request.fields['model'] = model;

      request.fields['smart_format'] = true.toString();
      request.fields['detect_topics'] = true.toString();
      request.fields['paragraphs'] = true.toString();
      request.fields['diarize'] = true.toString();

      final response = await client.send(request);

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();

        final result = jsonDecode(responseBody);

        return result['results']['channels'][0]['alternatives'][0];
      } else {
        log(response.toString());
        throw Exception('Error: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Error during transcription: $error');
    } finally {
      client.close();
    }
  }
  // Future<Map<String, dynamic>> transcritpion({required String filePath}) async {
  //   final client = http.Client();

  //   final file = File(filePath);

  //   final request = http.MultipartRequest(
  //     "POST",
  //     Uri.parse(
  //         "${ApiModelConstatnts.apiUrl}${ApiModelConstatnts.transcribttion}"),
  //   );

  //   request.files.add(http.MultipartFile.fromBytes(
  //     "file",
  //     file.readAsBytesSync(),
  //     filename: basename(filePath),
  //     contentType: MediaType("application", "octet-stream"),
  //   ));

  //   final response = await client.send(request);
  //   log(response.statusCode.toString());

  //   final responseBody = await response.stream.bytesToString();

  //   return jsonDecode(responseBody);
  // }

  @override
  Future<String> uploadAudio({required AudioModel audioModel}) async {
    var request = http.MultipartRequest(
        'POST', Uri.parse('https://sumcap101-uqk5.onrender.com/api/v1/audios'));
    request.fields.addAll({
      'title': audioModel.title,
      'transcriptionText': audioModel.transcriptionText,
      'duration': audioModel.duration,
      'paragraphs': jsonEncode(audioModel.paragraphs),
      'topics': jsonEncode(audioModel.topics),
    });

    request.files.add(await http.MultipartFile.fromPath(
        'audio', audioModel.audioUrl,
        filename: basename(audioModel.audioUrl)));
    request.headers['Authorization'] =
        'Bearer ${SharedPrefHelper.getData(key: 'token')}';

    http.StreamedResponse response = await request.send();

    var responseData = await response.stream.bytesToString();

    return responseData;
  }

  @override
  Future<String> uploadYoutubeAudio({required AudioModel audioModel}) {
    throw UnimplementedError();
  }
}
