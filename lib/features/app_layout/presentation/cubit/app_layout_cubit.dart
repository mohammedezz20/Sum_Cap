import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:deepgram_speech_to_text/deepgram_speech_to_text.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:sum_cap/core/utils/api_constants.dart';
import 'package:sum_cap/features/app_layout/data/models/audio_model.dart';
import 'package:sum_cap/features/app_layout/domain/usecases/app_layout_use_case.dart';
import 'package:sum_cap/features/app_layout/presentation/cubit/app_layout_states.dart';
import 'package:sum_cap/features/app_layout/presentation/pages/home_screen.dart';
import 'package:sum_cap/features/user_profile/presentation/pages/user_screen.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

import '../../../../core/shared_pref_helper.dart';
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
            return CustomDialogWidget(
              audioPath: filePath ?? '',
            );
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
  bool isArabic = false;
  changeLang(val) {
    isArabic = val;
    emit(ChangeLangState());
  }

//!!!!!!!!!!!!!!!!!!!!!!    هي دي يا علاء
  transcriptFile(filepath, title, {bool isArabic = false}) async {
    emit(TranscriptionLoadingState(
      fileName: title,
    ));
    try {
      Map<String, dynamic> params = isArabic
          ? {
              'model': 'whisper-large',
              'detect_language': true,
              'punctuate': true,
              "utterances": true,
              "utt_split": 1,
              'diarize': true,
            }
          : {
              'model': 'nova-2',
              'detect_language': true,
              'detect_topics': true,
              'smart_format': true,
              'punctuate': true,
              "utterances": true,
              "utt_split": 1,
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
      log(data!.map.toString());
      log(text.transcript);
      transcriptionText = isArabic
          ? text.transcript
          : data!['results']['channels'][0]['alternatives'][0]['paragraphs']
                  ['transcript'] ??
              '';

      if (!isArabic) {
        for (Map<String, dynamic> x in data!['results']['channels'][0]
                ['alternatives'][0]['topics'] ??
            []) {
          Topic n = Topic.fromJson(x);
          topics.add(n);
        }

        for (Map<String, dynamic> x in data!['results']['channels'][0]
                ['alternatives'][0]['paragraphs']['paragraphs'] ??
            []) {
          Paragraph n = Paragraph.fromJson(x);
          paragraphs.add(n);
        }
      }
      emit(TranscriptionSuccessState(
          fileName: title, message: 'Transcripted Successfully'));
      isArabic = false;
    } catch (e) {
      log(e.toString());
      emit(TranscriptionErrorState(error: e.toString(), fileName: title));
    }
  }

  Future<void> transcriptFileWithAPI(filePath, title) async {
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

  Future<void> requestStoragePermission() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
  }

  Future<void> download(String id) async {
    try {
      // Ensure storage permission is granted
      await requestStoragePermission();

      // Initialize YoutubeExplode
      final yt = YoutubeExplode();

      // Get video metadata
      var video = await yt.videos.get(id);

      // Get the best audio stream
      var manifest = await yt.videos.streamsClient.getManifest(id);
      var audio = manifest.audioOnly.withHighestBitrate();
      var audioStream = yt.videos.streamsClient.get(audio);

      // Prepare file name for download
      var fileName = '${video.title}.${audio.container.name}'
          .replaceAll(RegExp(r'[\\/:*?"<>|]'), '')
          .replaceAll('.mp4', '.mp3')
          .replaceAll('.webm', '.mp3'); // Replace invalid characters

      // Ensure the download directory exists
      Directory appDir = await getApplicationDocumentsDirectory();
      final file = File('${appDir.path}/$fileName'
          .replaceAll('.webm', 'mp3')
          .replaceAll('.mp4', 'mp3'));
      if (!await appDir.exists()) {
        await appDir.create(recursive: true);
      }

      // Create the file to save the downloaded audio
      filePath = file.path;

      // Delete file if already exists
      if (await file.exists()) {
        await file.delete();
      }

      // Open file for writing
      var output = file.openWrite(mode: FileMode.writeOnlyAppend);

      // Track download progress
      var len = audio.size.totalBytes;
      var count = 0;

      // Output initial message
      stdout.writeln('Downloading $fileName');

      // Listen for data and write to file
      await audioStream.forEach((data) {
        count += data.length;
        var progress = ((count / len) * 100).ceil();
        stdout.write('Downloading $progress% \r');
        output.add(data);
      });

      // Close file stream
      await output.close();

      // Output completion message
      stdout.writeln('Downloaded $fileName');
      log('Downloaded $fileName');
      audioDuration = video.duration.toString().substring(2, 7);
    } catch (e) {
      // Handle errors
      stderr.writeln('Error downloading video: $e');
      log('Error downloading video: $e');
    } finally {
      // Ensure YoutubeExplode is properly closed
      yt.close();
    }
  }

  getdata() {
    GlobalVar.user?.token != SharedPrefHelper.getData(key: 'token');
    GlobalVar.user?.id != SharedPrefHelper.getData(key: 'id');
    GlobalVar.user?.username != SharedPrefHelper.getData(key: 'username');
    GlobalVar.user?.email != SharedPrefHelper.getData(key: 'email');
    GlobalVar.user?.password != SharedPrefHelper.getData(key: 'password');
  }

  // late StreamSubscription _intentSub;
  // final _sharedFiles = <SharedMediaFile>[];

  // @override
  // void checkAudioReceived(BuildContext context) {
  //   _intentSub = ReceiveSharingIntent.instance.getMediaStream().listen((value) {
  //     _sharedFiles.clear();
  //     if (value.isNotEmpty) {
  //       _sharedFiles.addAll(value);

  //       for (var file in _sharedFiles) {
  //         log("file path : ${file.path}");
  //         _handleSharedAudio(file.path, context);
  //       }
  //     } else {
  //       log('No shared files received');
  //     }
  //   }, onError: (err) {
  //     print("getIntentDataStream error: $err");
  //   });

  //   // Get the media sharing coming from outside the app while the app is closed.
  //   ReceiveSharingIntent.instance.getInitialMedia().then((value) {
  //     _sharedFiles.clear();
  //     if (value.isNotEmpty) {
  //       _sharedFiles.addAll(value);

  //       for (var file in _sharedFiles) {
  //         log("file path : ${file.path}");
  //         _handleSharedAudio(file.path, context);
  //       }
  //     } else {
  //       log('No initial shared files received');
  //     }

  //     // WidgetsBinding.instance.addPostFrameCallback((_) {
  //     //   showDialog(
  //     //     context: context,
  //     //     builder: (context) => CustomDialogWidget(audioPath: audioPath),
  //     //   );
  //     // });

  //     // Tell the library that we are done processing the intent.
  //     ReceiveSharingIntent.instance.reset();
  //   });
  // }

  // void _handleSharedAudio(String audioPath, context) {
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     showDialog(
  //       context: context,
  //       builder: (context) => CustomDialogWidget(audioPath: audioPath),
  //     );
  //   });
  // }
}
