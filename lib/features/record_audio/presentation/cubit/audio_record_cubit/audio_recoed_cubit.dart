import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:sum_cap/features/record_audio/data/datasources/audio_record_helper.dart';
import 'package:path/path.dart' as path;

part 'audio_recoed_state.dart';

class AudioRecoedCubit extends Cubit<AudioRecoedState> {
  AudioRecoedCubit() : super(AudioRecoedInitial());
  static AudioRecoedCubit get(context) => BlocProvider.of(context);

  //! ***********************************
  //!         Varibales
  //! ***********************************
  final AudioRecorder _audioRecorder = AudioRecorder();
  final AudioRecordFileHelper _audioRecordFileHelper = AudioRecordFileHelper();

  Timer? _timer;
  int _recordDuration = 0;

  //! ***********************************
  //!         Controllers
  //! ***********************************
  final StreamController<int> _durationStreamController =
      StreamController<int>.broadcast()..add(0);
  //! ***********************************
  //!         Sinks
  //! ***********************************
  Sink<int> get recordDuratioInput => _durationStreamController.sink;
  //! ***********************************
  //!         Streams
  //! ***********************************

  Stream<double> get amplitudeStream => _audioRecorder
      .onAmplitudeChanged(const Duration(milliseconds: 100))
      .map((map) => map.current);

  Stream<int> get durationStreamOutput => _durationStreamController.stream;

  Stream<RecordState> get recordStateStream => _audioRecorder.onStateChanged();

  //! ***********************************
  //!         Methods
  //! ***********************************

  int get recordDuration => _recordDuration;

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      _recordDuration++;
      recordDuratioInput.add(_recordDuration);
    });
  }

  void _stopTimer() {
    _recordDuration = 0;
    recordDuratioInput.add(_recordDuration);
    _timer?.cancel();
  }

  Future<void> start() async {
    final isMicPermissionGranted = await _checkMicPermissions();

    if (!isMicPermissionGranted) {
      log('Mic permission not granted');
      return;
    }
    try {
      // final fileName = path.join(
      //     (await _audioRecordFileHelper.getRecordDirectoryPath).path,
      //     "${DateTime.now().millisecondsSinceEpoch}.mp3");
      final fileName = path.join(
          (await _audioRecordFileHelper.getRecordDirectoryPath).path,
          "${DateTime.now().millisecondsSinceEpoch}.wav");
      log(fileName);

      await _audioRecorder.start(const RecordConfig(), path: fileName);
      _startTimer();
    } catch (e) {
      log(
        e.toString(),
        name: 'start',
      );
    }
  }

  void resume() async {
    _startTimer();
    await _audioRecorder.resume();
  }

  pause() async {
    _timer?.cancel();
    await _audioRecorder.pause();
  }

  void delete(String filepath) async {
    await pause();
    try {
      await _audioRecordFileHelper.deleteRecordFile(filepath);
      _stopTimer();
    } catch (e) {
      log(
        e.toString(),
        name: 'delete',
      );
    }
  }

  Future<String?> stop() async {
    final path = await _audioRecorder.stop();

    _stopTimer();
    if (path == null) {
      return null;
    }
    log(path);
    return path;
  }

  void dispose() {
    _durationStreamController.close();
    _timer?.cancel();
    _timer = null;
    // _audioRecorder.stop();
  }

  Future<bool> _checkMicPermissions() async {
    const micPermision = Permission.microphone;
    if (await micPermision.isGranted) {
      return true;
    } else {
      final permissionStatus = await micPermision.request();
      if (permissionStatus.isGranted || permissionStatus.isLimited) {
        return true;
      } else {
        return false;
      }
    }
  }
}
