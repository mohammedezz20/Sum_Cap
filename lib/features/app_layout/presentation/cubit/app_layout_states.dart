abstract class AppLayoutStates {}

class AppInitialState extends AppLayoutStates {}

//! get user audio

class AppLayoutGetUserAudioLoadingState extends AppLayoutStates {}

class AppLayoutGetUserAudioSuccessState extends AppLayoutStates {
  final String message;
  AppLayoutGetUserAudioSuccessState(this.message);
}

class AppLayoutGetUserAudioErrorState extends AppLayoutStates {
  final String error;
  AppLayoutGetUserAudioErrorState(this.error);
}

//! Pic Audio
class PickAudioLoadingState extends AppLayoutStates {}

class PickAudioSuccessState extends AppLayoutStates {}

class PickAudioErrorState extends AppLayoutStates {
  String error;
  PickAudioErrorState(this.error);
}

//! upload audio
class UploadAudioLoadingState extends AppLayoutStates {
  String fileName;
  UploadAudioLoadingState({required this.fileName});
}

class UploadAudioSuccessState extends AppLayoutStates {
  String fileName;
  String message;
  UploadAudioSuccessState({required this.fileName, required this.message});
}

class UploadAudioErrorState extends AppLayoutStates {
  String fileName;
  String error;
  UploadAudioErrorState({required this.fileName, required this.error});
}

//! Transcription
class TranscriptionLoadingState extends AppLayoutStates {
  String fileName;
  TranscriptionLoadingState({required this.fileName});
}

class TranscriptionSuccessState extends AppLayoutStates {
  String fileName;
  String message;
  TranscriptionSuccessState({required this.fileName, required this.message});
}

class TranscriptionErrorState extends AppLayoutStates {
  String fileName;
  String error;
  TranscriptionErrorState({required this.fileName, required this.error});
}

class ChangeLangState extends AppLayoutStates {}

class CheckAudioReceivedState extends AppLayoutStates {}
