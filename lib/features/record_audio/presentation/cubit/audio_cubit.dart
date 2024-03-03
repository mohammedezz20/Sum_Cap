import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:record/record.dart';
import 'package:sum_cap/features/app_layout/presentation/pages/app_layout.dart';
import 'package:sum_cap/features/record_audio/data/datasources/audio_record_helper.dart';
import 'package:sum_cap/features/record_audio/domain/usecases/audio_usecase.dart';
import 'package:sum_cap/features/record_audio/presentation/pages/record_details.dart';
import 'package:sum_cap/features/record_audio/presentation/widgets/translate_text.dart';
import 'package:translator/translator.dart';

import '../../../../dependcy_injection.dart';
import '../../../app_layout/data/models/audio_model.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:async';
import 'package:path/path.dart' as path;

import '../../../app_layout/presentation/cubit/app_layout_cubit.dart';

part 'audio_state.dart';

class AudioCubit extends Cubit<AudioState> {
  AudioCubit() : super(AudioInitial());
  static AudioCubit get(context) => BlocProvider.of(context);
  final _usecase = sl<AudioUseCase>();

  AudioModel? tempModel;

  Future<void> deleteAudio(AudioModel audio, context) async {
    emit(DeleteAudioLoadingState(audio.title));

    var result = await _usecase.deleteAudio(audio.id!);
    result.fold((l) {
      emit(DeleteAudioErrorState(l.toString(), audio.title));
    }, (r) {
      emit(DeleteAudioSuccessState(r.statusCode, audio.title));
    });
  }

  Future<void> updateAudio(AudioModel audio, context) async {
    emit(EditAudioLoadingState());

    var result = await _usecase.updateAudio(audio);
    result.fold((l) {
      emit(EditAudioErrorState(l.toString()));
    }, (r) {
      log(r.body.toString());
      emit(EditAudioSuccessState(r.statusCode));
    });
  }

  final nameController = TextEditingController();
  final transcriptionController = TextEditingController();
  DataStatus dataStatus = DataStatus.readOnly;
  changeDataStatus(context) {
    if (dataStatus == DataStatus.readOnly) {
      dataStatus = DataStatus.readAndWrite;
      emit(ChangeDataStatusToReadAndWrite());
    } else {
      dataStatus = DataStatus.readOnly;
      log(nameController.text);
      dataStatus = DataStatus.readOnly;
      log(nameController.text);
      AudioModel newAudio = AudioModel(
        id: tempModel?.id,
        title: nameController.text,
        transcriptionText: transcriptionController.text,
        createdAt: tempModel!.createdAt,
        audio: tempModel!.audio,
        duration: tempModel!.duration,
        audioName: tempModel!.audioName,
      );
      emit(ChangeDataStatusToReadOnly());
      updateAudio(newAudio, context);
      Navigator.pop(context);
    }
  }

  translateText(String transcriptionText, context) async {
    emit(TranslateAudioLoadingState());
    var response = await _usecase.translateText(transcriptionText);
    response.fold((l) {
      emit(TranslateAudioErrorState(l.toString()));
    }, (r) {
      emit(TranslateAudioSuccessState(r));
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return DialogWidget(r, isTranslated: true);
        },
      );
    });

    //   try {
    //     final translator = GoogleTranslator();
    //     String text = '';
    //     translator
    //         .translate(transcriptionText, from: 'en', to: 'ar')
    //         .then((value) {
    //       text = value.text;
    //       log(text);
    //       showDialog(
    //         context: context,
    //         builder: (BuildContext context) {
    //           return TranslateDialogWidget(value.text);
    //         },
    //       );
    //       emit(TranslateAudioSuccessState(text));
    //     });
    //   } catch (e) {
    //     emit(TranslateAudioErrorState(e.toString()));
    //   }
    // }
  }

  summarizeText(String transcriptionText, context) async {
    emit(SummarizeAudioLoadingState());
    var response = await _usecase.summarizeText(transcriptionText);
    response.fold((l) {
      emit(SummarizeAudioErrorState(l.toString()));
    }, (r) {
      emit(SummarizeAudioSuccessState(r));
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return DialogWidget(r);
        },
      );
    });
  }
}
