import 'dart:async';
import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sum_cap/features/app_layout/data/models/audio_model.dart';
import 'package:sum_cap/features/record_audio/domain/usecases/audio_usecase.dart';
import 'package:sum_cap/features/record_audio/presentation/pages/record_details.dart';
import 'package:sum_cap/features/record_audio/presentation/pages/summarization.dart';
import 'package:sum_cap/features/record_audio/presentation/widgets/translate_text.dart';

import '../../../../dependcy_injection.dart';

part 'audio_state.dart';

class AudioCubit extends Cubit<AudioState> {
  AudioCubit() : super(AudioInitial());
  static AudioCubit get(context) => BlocProvider.of(context);
  final _useCase = sl<AudioUseCase>();

  AudioModel? tempModel;

  Future<void> deleteAudio(AudioModel audio, context) async {
    emit(DeleteAudioLoadingState(audio.title));

    var result = await _useCase.deleteAudio(audio.audioId ?? '');
    result.fold((l) {
      emit(DeleteAudioErrorState(l.toString(), audio.title));
    }, (r) {
      emit(DeleteAudioSuccessState(r.statusCode, audio.title));
    });
  }

  Future<void> updateAudio(AudioModel audio, context) async {
    emit(EditAudioLoadingState());

    var result = await _useCase.updateAudio(audio);
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
        audioId: tempModel?.audioId,
        title: nameController.text,
        transcriptionText: transcriptionController.text,
        createdAt: tempModel!.createdAt,
        audioUrl: tempModel!.audioUrl,
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
    var response = await _useCase.translateText(transcriptionText);
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
    var response = await _useCase.summarizeText(
        transcriptionText, !isEnglish(transcriptionText));
    response.fold((l) {
      emit(SummarizeAudioErrorState(l.toString()));
    }, (r) {
      emit(SummarizeAudioSuccessState(r));
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SummarizationScreens(
            SummaryText: r,
            isArabic: !isEnglish(r),
          ),
        ),
      );
      // showDialog(
      //   context: context,
      //   builder: (BuildContext context) {
      //     return DialogWidget(r);
      //   },
      // );
    });
  }

  Duration _duration = const Duration();
  Duration _position = const Duration();

  Duration get duration => _duration;
  Duration get position => _position;
  changeDuration(newDuration) {
    _duration = newDuration;

    emit(ChangeDuration());
  }

  changePosition(newPosition) {
    _position = newPosition;

    emit(ChangePosition());
  }

  bool isEnglish(String text) {
    final englishRegExp = RegExp(r'[A-Za-z]');
    return englishRegExp.hasMatch(text);
  }
}
