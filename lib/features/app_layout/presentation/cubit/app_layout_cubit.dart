import 'dart:convert';
import 'dart:developer';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:just_audio/just_audio.dart';
import 'package:sum_cap/features/app_layout/data/models/audio_model.dart';
import 'package:sum_cap/features/app_layout/domain/usecases/app_layout_use_case.dart';
import 'package:sum_cap/features/app_layout/presentation/cubit/app_layout_states.dart';
import 'package:sum_cap/features/app_layout/presentation/pages/home_screen.dart';
import 'package:sum_cap/features/user_profile/presentation/pages/user_screen.dart';

import '../../../../core/cach_helper.dart';
import '../../../../core/global.dart';
import '../../../../dependcy_injection.dart';
import '../widgets/dialog_widget.dart';

//!Cubit

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
          log(element.toString());
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
      transcriptionText = r['text'];
      emit(TranscriptionSuccessState(
          message: 'Transcripted Successfully', fileName: title));
    });
  }

  //!Upload File
  Future<void> uploadFile({required AudioModel audioModel}) async {
    emit(UploadAudioLoadingState(
      fileName: audioModel.audioName,
    ));
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

  getdata() {
    GlobalVar.user?.token != CachHelper.getData(key: 'token');
    GlobalVar.user?.id != CachHelper.getData(key: 'id');
    GlobalVar.user?.username != CachHelper.getData(key: 'username');
    GlobalVar.user?.email != CachHelper.getData(key: 'email');
    GlobalVar.user?.password != CachHelper.getData(key: 'password');
  }
}
