import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:deepgram_speech_to_text/deepgram_speech_to_text.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:just_audio/just_audio.dart';
import 'package:sum_cap/core/utils/api_constants.dart';
import 'package:sum_cap/features/app_layout/data/models/audio_model.dart';
import 'package:sum_cap/features/app_layout/domain/usecases/app_layout_use_case.dart';
import 'package:sum_cap/features/app_layout/presentation/cubit/app_layout_states.dart';
import 'package:sum_cap/features/app_layout/presentation/pages/home_screen.dart';
import 'package:sum_cap/features/user_profile/presentation/pages/user_screen.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

import '../../../../core/cach_helper.dart';
import '../../../../core/global.dart';
import '../../../../dependcy_injection.dart';
import '../widgets/dialog_widget.dart';

//!Cubit
final yt = YoutubeExplode();

class AppLayoutCubit extends Cubit<AppLayoutStates> {
  AppLayoutCubit() : super(AppInitialState());

  static AppLayoutCubit get(context) => BlocProvider.of(context);
  List<Widget> screens = [
    const HomeScreen(),
    const UserScreen(),
  ];
  int selectedIndex = 0;

  void changeNavBar(int index) {
    if (index == 0) {
      getAudios();
    }
    selectedIndex = index;
    emit(AppInitialState());
  }

  bool isMorning = int.parse(DateFormat('HH').format(DateTime.now())) < 12;
  final _usecases = sl<AppLayoutUseCase>();
  List<AudioModel> audios = [];
  Future<void> getAudios() async {
    audios.clear();
    emit(AppLayoutGetUserAudioLoadingState());
    var response = await _usecases.getUserAudio();
    response.fold((l) {
      Map<String, dynamic> res = jsonDecode(l.toString());
      emit(AppLayoutGetUserAudioErrorState(res['message']));
    }, (r) {
      if (r['status'] != 'success') {
        emit(AppLayoutGetUserAudioErrorState(r['message']));
      } else {
        r['data']['audios'].forEach((element) {
          audios.add(AudioModel.fromJson(element));
        });

        emit(AppLayoutGetUserAudioSuccessState('Get Audios Successfully'));
      }
    });
  }

  //!PicFile
  String? filePath;
  String? audioDuration;
  Future<void> pickFile(context) async {
    emit(PickAudioLoadingState());
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.audio,
      );
      if (result != null) {
        filePath = result.files.single.path;

        log('Picked MP3 file path: $filePath');
        final player = AudioPlayer();
        await player.setAudioSource(AudioSource.uri(Uri.parse(filePath!)));
        final duration = await player.durationStream.first;
        await player.dispose();
        audioDuration = duration.toString().substring(2, 7);
        log(audioDuration!);
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return const CustomDialogWidget();
          },
        );
        emit(PickAudioSuccessState());
      } else {
        emit(PickAudioErrorState('User canceled the file picker'));
        log('User canceled the file picker');
      }
    } catch (e) {
      emit(PickAudioErrorState('error picking MP3 file: $e'));
      log('Error picking MP3 file: $e');
    }
  }

  //!Transcripe File
  String? transcriptionText;
  Map<String, dynamic>? data;
  List<Topic> topics = [];
  List<Paragraph> paragraphs = [];

//!!!!!!!!!!!!!!!!!!!!!!    هي دي يا علاء
  transcriptFile(filepath, title) async {
    emit(TranscriptionLoadingState(fileName: title));
    // try {
    Map<String, dynamic> params = {
      'model': 'whisper-medium',
      'detect_language': true,
      'detect_topics': true,
      'smart_format': true,
      'punctuate': true,
      'paragraphs': true,
      'diarize': true,
    };
    Deepgram deepgram =
        Deepgram(ApiModelConstatnts.deepGramApiKey, baseQueryParams: params);
    DeepgramSttResult text = await deepgram.transcribeFromFile(
      File(filepath),
    );
    log('file path: $filepath');
    data = text.map;
    transcriptionText = data!['results']['channels'][0]['alternatives'][0]
        ['paragraphs']['transcript'];
    // log('data : $data');
    // log(data!['results']['channels'][0]['alternatives'][0]['paragraphs']
    //     ['transcript']);

    for (Map<String, dynamic> x
        in data!['results']['channels'][0]['alternatives'][0]['topics'] ?? []) {
      Topic n = Topic.fromJson(x);
      topics.add(n);
    }
    log('Topics: $topics');
    log('topics length: ${topics.length}');

    for (Map<String, dynamic> x in data!['results']['channels'][0]
            ['alternatives'][0]['paragraphs']['paragraphs'] ??
        []) {
      Paragraph n = Paragraph.fromJson(x);
      paragraphs.add(n);
    }

    emit(TranscriptionSuccessState(
        fileName: title, message: 'Transcripted Successfully'));
    // } catch (e) {
    //   log(e.toString());
    //   emit(TranscriptionErrorState(error: e.toString(), fileName: title));
    // }
  }

  Future<void> transcripeFile(filePath, title) async {
    emit(TranscriptionLoadingState(
      fileName: title,
    ));
    var response = await _usecases.transcriptAudios(filePath: filePath);
    response.fold((l) {
      log(l.toString());
      emit(TranscriptionErrorState(
          fileName: title, error: 'Error When Transcripting'));
    }, (r) {
      log(r.toString());
      data = r;
      transcriptionText = r['transcript'];
      log('topics : ${r['topics']}');
      log('Total paragraphs : ${r['paragraphs']}');
      log('paragraphs : ${r['paragraphs']['paragraphs']}');

      for (Map<String, dynamic> x in r['topics']) {
        Topic n = Topic.fromJson(x);
        topics.add(n);
      }
      for (Map<String, dynamic> x in r['paragraphs']['paragraphs']) {
        Paragraph n = Paragraph.fromJson(x);
        paragraphs.add(n);
      }

      emit(TranscriptionSuccessState(
          message: 'Transcripted Successfully', fileName: title));
    });
  }

  Future<void> transcripeYoutubeVideo(filePath, title) async {
    // emit(TranscriptionLoadingState(
    //   fileName: title,
    // ));
    // var response = await _usecases.transcriptYoutubeVideo(filePath: filePath);
    // response.fold((l) {
    //   log(l.toString());
    //   emit(TranscriptionErrorState(
    //       fileName: title, error: 'Error When Transcripting'));
    // }, (r) {
    //   log(r.toString());
    //   data = r;
    //   transcriptionText = r['paragraphs']['transcript'];
    //   log('topics : ${r['topics']}');
    //   log('Total paragraphs : ${r['paragraphs']}');
    //   log('paragraphs : ${r['paragraphs']['paragraphs']}');

    //   for (Map<String, dynamic> x in r['topics']) {
    //     Topic n = Topic.fromJson(x);
    //     topics.add(n);
    //   }
    //   for (Map<String, dynamic> x in r['paragraphs']['paragraphs']) {
    //     Paragraph n = Paragraph.fromJson(x);
    //     paragraphs.add(n);
    //   }

    //   emit(TranscriptionSuccessState(
    //       message: 'Transcripted Successfully', fileName: title));
    // });
  }

  //!Upload File
  Future<void> uploadFile({required AudioModel audioModel}) async {
    emit(UploadAudioLoadingState(
      fileName: audioModel.audioName,
    ));
    log('while uploading    topics is : ${audioModel.topics!.length}');
    var response = await _usecases.uploadAudios(audioModel: audioModel);
    response.fold((l) {
      log(l.toString());
      emit(UploadAudioErrorState(
          error: 'Error When Uploading', fileName: audioModel.audioName));
    }, (r) {
      log(r.toString());
      emit(UploadAudioSuccessState(
          message: 'Uploaded Successfully', fileName: audioModel.audioName));
    });
  }

  Future<void> uploadYouTubeFile({required AudioModel audioModel}) async {
    emit(UploadAudioLoadingState(
      fileName: audioModel.audioName,
    ));
    var response;
    // var response =
    //     await _usecases.uploadAudioFromYoutube(audioModel: audioModel);
    response.fold((l) {
      log(l.toString());
      emit(UploadAudioErrorState(
          error: 'Error When Uploading', fileName: audioModel.audioName));
    }, (r) {
      log(r.toString());
      emit(UploadAudioSuccessState(
          message: 'Uploaded Successfully', fileName: audioModel.audioName));
    });
  }

  // Future<String> uploadAudio({required AudioModel audioModel}) async {
  //   var request = http.MultipartRequest(
  //       'POST', Uri.parse('https://sumcap101-uqk5.onrender.com/api/v1/audios'));
  //   request.fields.addAll({
  //     'title': audioModel.title,
  //     'transcriptionText': audioModel.transcriptionText,
  //     'duration': audioModel.duration
  //   });
  //   request.files.add(await http.MultipartFile.fromPath(
  //       'audio', audioModel.audio,
  //       filename: basename(audioModel.audio)));
  //   request.headers['Authorization'] = 'Bearer ${GlobalVar.user?.token}';

  //   http.StreamedResponse response = await request.send();

  //   var responseData = await response.stream.bytesToString();

  //   log("error in uploading audio$responseData");
  //   return responseData;
  // }
  Future<void> download(String id, context) async {
    // Get video metadata.
    final video = await yt.videos.get(id);

    // Get the video manifest.
    final manifest = await yt.videos.streamsClient.getManifest(id);
    final streams = manifest.audioOnly;
    final audio = streams.withHighestBitrate();
    final audioStream = yt.videos.streamsClient.get(audio);

    final fileName = '${video.title}.${audio.container.name}'
        .replaceAll(r'\', '')
        .replaceAll('.mp4', '')
        .replaceAll('.webm', '')
        .replaceAll('/', '')
        .replaceAll('*', '')
        .replaceAll('?', '')
        .replaceAll('"', '')
        .replaceAll('<', '')
        .replaceAll('>', '')
        .replaceAll('|', '');
    final appDir = Directory('/storage/emulated/0/Download');
    final file = File(
        '${'${appDir!.path}/$fileName'.replaceAll('.webm', '').replaceAll('.mp4', '')}.mp3');
    log(file.path);
    // Delete the file if exists.
    if (file.existsSync()) {
      file.deleteSync();
    }

    // Open the file in writeAppend.
    final output = file.openWrite(mode: FileMode.writeOnlyAppend);

    // Track the file download status.
    final len = audio.size.totalBytes;
    var count = 0;

    // Create the message and set the cursor position.
    final msg = 'Downloading ${video.title}.${audio.container.name}';
    stdout.writeln(msg);

    // Listen for data received.
    await for (final data in audioStream) {
      // Keep track of the current downloaded data.
      count += data.length;

      // Calculate the current progress.
      final progress = ((count / len) * 100).ceil();

      log(progress.toStringAsFixed(2));
      // Write to file.
      output.add(data);
    }
    await output.close();
    log('Downloaded ${video.title}.${audio.container.name}');
    filePath = file.path;

    String fileUri = '$filePath';

    log('Picked MP3 file path: $fileUri');
    audioDuration = video.duration.toString().substring(2, 7);
    log('================ audio type ${audio.codec.change(subtype: 'mp3')}');
  }

  getdata() {
    GlobalVar.user?.token != CachHelper.getData(key: 'token');
    GlobalVar.user?.id != CachHelper.getData(key: 'id');
    GlobalVar.user?.username != CachHelper.getData(key: 'username');
    GlobalVar.user?.email != CachHelper.getData(key: 'email');
    GlobalVar.user?.password != CachHelper.getData(key: 'password');
  }
}
