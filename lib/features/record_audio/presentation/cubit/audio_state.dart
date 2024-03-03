part of 'audio_cubit.dart';

sealed class AudioState extends Equatable {
  const AudioState();

  @override
  List<Object> get props => [];
}

final class AudioInitial extends AudioState {}

class EditAudioLoadingState extends AudioState {}

class EditAudioSuccessState extends AudioState {
  final int statuscode;
  const EditAudioSuccessState(this.statuscode);
}

class EditAudioErrorState extends AudioState {
  final String message;

  const EditAudioErrorState(this.message);

  @override
  List<Object> get props => [message];
}

class DeleteAudioLoadingState extends AudioState {
  String fileName;
  DeleteAudioLoadingState(this.fileName);
}

class DeleteAudioSuccessState extends AudioState {
  String fileName;
  int statuscode;
  DeleteAudioSuccessState(this.statuscode, this.fileName);
}

class DeleteAudioErrorState extends AudioState {
  String message;
  String fileName;
  DeleteAudioErrorState(this.message, this.fileName);

  @override
  List<Object> get props => [message];
}

class ChangeDataStatusToReadOnly extends AudioState {}

class ChangeDataStatusToReadAndWrite extends AudioState {}

class TranslateAudioLoadingState extends AudioState {}

class TranslateAudioSuccessState extends AudioState {
  final String translatedText;
  const TranslateAudioSuccessState(this.translatedText);
}

class TranslateAudioErrorState extends AudioState {
  final String message;
  const TranslateAudioErrorState(this.message);
}

class SummarizeAudioLoadingState extends AudioState {}

class SummarizeAudioSuccessState extends AudioState {
  final String summarizedText;
  const SummarizeAudioSuccessState(this.summarizedText);
}

class SummarizeAudioErrorState extends AudioState {
  final String message;
  const SummarizeAudioErrorState(this.message);
}
