import 'package:equatable/equatable.dart';

abstract class TranscriptionState extends Equatable {
  final String transcript;

  const TranscriptionState(this.transcript);

  @override
  List<Object> get props => [transcript];
}

class TranscriptionInitial extends TranscriptionState {
  const TranscriptionInitial()
      : super(
            'For a high-quality transcription, please \n \t\t\t\t\t\t\t\t speak slowly and clearly');
}

class TranscriptionStarted extends TranscriptionState {
  const TranscriptionStarted(String transcript) : super(transcript);
}

class TranscriptionUpdated extends TranscriptionState {
  const TranscriptionUpdated(String transcript) : super(transcript);
}

class TranscriptionStopped extends TranscriptionState {
  const TranscriptionStopped(String transcript) : super(transcript);
}
