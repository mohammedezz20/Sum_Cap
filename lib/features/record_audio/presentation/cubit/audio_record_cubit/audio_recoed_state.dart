part of 'audio_recoed_cubit.dart';

sealed class AudioRecoedState extends Equatable {
  const AudioRecoedState();

  @override
  List<Object> get props => [];
}

final class AudioRecoedInitial extends AudioRecoedState {}
