import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:path/path.dart';
import 'package:sum_cap/core/global.dart';
import 'package:http/http.dart' as http;
import 'package:sum_cap/core/utils/api_constants.dart';
import 'package:http_parser/http_parser.dart';
import 'package:sum_cap/features/app_layout/data/models/audio_model.dart';

import '../../../../core/cach_helper.dart';

abstract class AppLayoutRemoteDataSource {
  Future<Map<String, dynamic>> getUserAudios();
  Future<Map<String, dynamic>> transcritpion({required String filePath});
  Future<String> uploadAudio({required AudioModel audioModel});
}

class AppLayoutRemoteDataSourceImpl implements AppLayoutRemoteDataSource {
  @override
  Future<Map<String, dynamic>> getUserAudios() async {
    final token = CachHelper.getData(key: 'token');

    final response = await http.get(
      Uri.parse(APIConstants.baseUrl + APIConstants.getUserAudio),
      headers: {'Authorization': 'Bearer $token'},
    );
    final Map<String, dynamic> responseData = jsonDecode(response.body);
    return responseData;
  }

  @override
  Future<Map<String, dynamic>> transcritpion({required String filePath}) async {
    final client = http.Client();

    final file = File(filePath);

    final request = http.MultipartRequest(
      "POST",
      Uri.parse("http://192.168.1.5:8000/api/v1/transcribe"),
    );

    request.files.add(http.MultipartFile.fromBytes(
      "file",
      file.readAsBytesSync(),
      filename: basename(filePath),
      contentType: MediaType("application", "octet-stream"),
    ));

    final response = await client.send(request);
    log(response.statusCode.toString());

    final responseBody = await response.stream.bytesToString();

    return jsonDecode(responseBody);
  }

  @override
  Future<String> uploadAudio({required AudioModel audioModel}) async {
    var request = http.MultipartRequest(
        'POST', Uri.parse('https://sumcap101-uqk5.onrender.com/api/v1/audios'));
    request.fields.addAll({
      'title': audioModel.title,
      'transcriptionText': audioModel.transcriptionText,
      'duration': audioModel.duration
    });
    request.files.add(await http.MultipartFile.fromPath(
        'audio', audioModel.audio,
        filename: basename(audioModel.audio)));
    request.headers['Authorization'] =
        'Bearer ${CachHelper.getData(key: 'token')}';
    log("---------------");
    http.StreamedResponse response = await request.send();
    log("---------------");
    var responseData = response.stream.toString();
    log("error in uploading audio$responseData");
    return responseData;
  }
}
