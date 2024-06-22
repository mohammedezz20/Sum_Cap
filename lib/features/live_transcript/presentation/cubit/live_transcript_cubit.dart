import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:deepgram_speech_to_text/deepgram_speech_to_text.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:sound_stream/sound_stream.dart';
import 'package:sum_cap/core/utils/api_constants.dart';
import 'package:sum_cap/features/live_transcript/presentation/cubit/live_transcript_state.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/status.dart' as status;

class LiveTranscriptCubit extends Cubit<TranscriptionState> {
  LiveTranscriptCubit() : super(const TranscriptionInitial());
  static LiveTranscriptCubit get(context) => BlocProvider.of(context);
  final RecorderStream _recorder = RecorderStream();
  late StreamSubscription _recorderStatus;
  late StreamSubscription _audioStream;
  late IOWebSocketChannel channel;

  Future<void> initStream() async {
    channel = IOWebSocketChannel.connect(
      Uri.parse(
          "wss://api.deepgram.com/v1/listen?encoding=linear16&sample_rate=16000&language=en-US"),
      headers: {'Authorization': 'Token ${ApiModelConstatnts.deepGramApiKey}'},
    );

    channel.stream.listen((event) async {
      final parsedJson = jsonDecode(event);
      log(parsedJson.toString());

      updateText(parsedJson['channel']['alternatives'][0]['transcript']);
    });

    _audioStream = _recorder.audioStream.listen((data) {
      channel.sink.add(data);
    });

    _recorderStatus = _recorder.status.listen((status) {
      // Handle recorder status if needed
    });

    await _recorder.initialize();
  }

  void startRecording() async {
    await Permission.microphone.request();
    resetText();
    await initStream();

    await _recorder.start();
    emit(TranscriptionStarted(state.transcript));
  }

  void stopRecording() async {
    await _recorder.stop();
    channel.sink.close(status.goingAway);
    resetText(newText: "  speak slowly and clearly");
    emit(TranscriptionStopped(state.transcript));
  }

  void updateText(String newText) {
    final updatedText = '${state.transcript} $newText';
    emit(TranscriptionUpdated(updatedText));
  }

  void resetText({String newText = ''}) {
    emit(TranscriptionUpdated(newText));
  }

  @override
  Future<void> close() {
    channel.sink.close(status.goingAway);
    _recorderStatus.cancel();
    _audioStream.cancel();
    channel.sink.close();
    return super.close();
  }
}
