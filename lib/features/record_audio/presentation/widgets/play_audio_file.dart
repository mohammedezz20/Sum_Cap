import 'dart:developer';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sum_cap/config/themes/colors.dart';
import 'package:sum_cap/core/utils/extensions/build_context_extensions.dart';
import 'package:sum_cap/core/utils/extensions/string_extensions.dart';
import 'package:sum_cap/features/app_layout/data/models/audio_model.dart';
import 'package:sum_cap/features/app_layout/presentation/pages/app_layout.dart';
import 'package:sum_cap/features/record_audio/presentation/cubit/audio_cubit.dart';
import 'package:sum_cap/features/record_audio/presentation/widgets/media_player_button.dart';

class AdvancedAudioPlayer extends StatefulWidget {
  final AudioModel audioModel;
  const AdvancedAudioPlayer({
    Key? key,
    required this.audioModel,
  }) : super(key: key);

  @override
  State<AdvancedAudioPlayer> createState() => _AdvancedAudioPlayerState();
}

class _AdvancedAudioPlayerState extends State<AdvancedAudioPlayer>
    with WidgetsBindingObserver {
  late AudioCubit cubit;

  Duration _duration = const Duration();
  Duration _position = const Duration();
  AudioState audioState = AudioState.none;
  double playRate = 1;
  bool isplaying = false;
  bool ispause = false;
  bool isloop = false;
  final AudioPlayer advancedPlayer = AudioPlayer();
  final List<IconData> _icons = [
    FontAwesomeIcons.play,
    FontAwesomeIcons.pause,
    FontAwesomeIcons.stop,
    FontAwesomeIcons.repeat,
    FontAwesomeIcons.rotateLeft,
    FontAwesomeIcons.rotateRight,
  ];
  getDuration() async {
    cubit.changeDuration(Duration(seconds: widget.audioModel.duration.toInt()));
    _duration = Duration(seconds: widget.audioModel.duration.toInt());
    log("from getDuration function => duration:${_duration.inSeconds}");
    List<String> timeParts = widget.audioModel.duration.split(':');

    int minutes = int.parse(timeParts[0]);
    int seconds = int.parse(timeParts[1]);

    _duration = Duration(minutes: minutes, seconds: seconds);
    cubit.changeDuration(Duration(minutes: minutes, seconds: seconds));

    if (widget.audioModel.audioUrl.contains('http')) {
      await advancedPlayer.setSourceUrl(widget.audioModel.audioUrl);
    } else {
      await advancedPlayer.setSourceDeviceFile(widget.audioModel.audioUrl);
    }
  }

  AppLifecycleState _appState = AppLifecycleState.inactive;

  @override
  void initState() {
    cubit = AudioCubit.get(context);
    WidgetsBinding.instance.addObserver(this);
    List<String> timeParts = widget.audioModel.duration.split(':');

    int minutes = int.parse(timeParts[0]);
    int seconds = int.parse(timeParts[1]);

    cubit.changeDuration(Duration(minutes: minutes, seconds: seconds));
    _duration = Duration(minutes: minutes, seconds: seconds);

    advancedPlayer.onPositionChanged.listen((p) {
      setState(() {
        _position = p;
        cubit.changePosition(p);
      });
    });
    advancedPlayer.onPlayerComplete.listen((event) {
      _position = Duration.zero;
      cubit.changePosition(Duration.zero);

      setState(() {
        audioState = AudioState.none;
      });
    });
    if (widget.audioModel.audioUrl.contains('http')) {
      advancedPlayer.setSourceUrl(widget.audioModel.audioUrl);
    } else {
      advancedPlayer.setSourceDeviceFile(widget.audioModel.audioUrl);
    }
    super.initState();
  }

  @override
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _appState = state;
    if (state == AppLifecycleState.inactive) {
      advancedPlayer.pause();
      log("App is in background");
    } else if (state == AppLifecycleState.resumed) {
      context.jumpToAndRemove(const AppLayout());

      log("App is resumed");
    } else if (state == AppLifecycleState.paused) {
      advancedPlayer.dispose();
      log("App is paused");
    } else if (state == AppLifecycleState.detached) {
      advancedPlayer.dispose();
      log("App is detached");
    }
  }

  @override
  void dispose() {
    advancedPlayer.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: context.w(10), vertical: context.h(10)),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColor.primaryColor, width: context.w(2)),
        color: Colors.white,
      ),
      child: Column(
        children: [
          Slider(
            activeColor: AppColor.primaryColor,
            inactiveColor: Colors.grey,
            min: 0.0,
            max: _duration.inSeconds.toDouble(),
            value: _position.inSeconds.toDouble(),
            onChanged: (value) async {
              await advancedPlayer.seek(Duration(seconds: value.toInt()));
              value = value;
            },
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: context.w(15)),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${(_position.inHours).toString().padLeft(2, '0')}:${(_position.inMinutes).toString().padLeft(2, '0')}:${_position.inSeconds.remainder(60).toString().padLeft(2, '0')}",
                    style: const TextStyle(
                        color: AppColor.primaryColor, fontSize: 15),
                  ),
                  Text(
                    "${(_duration.inHours).toString().padLeft(2, '0')}:${(_duration.inMinutes).toString().padLeft(2, '0')}:${_duration.inSeconds.remainder(60).toString().padLeft(2, '0')}",
                    style: const TextStyle(
                      color: AppColor.primaryColor,
                      fontSize: 15,
                    ),
                  ),
                ]),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              MediaPlayerButton(
                onPressed: () {
                  // if (playRate > 0.5) {
                  //   playRate = playRate - 0.5;
                  // }
                  // advancedPlayer.setPlaybackRate(playRate);
                  if (_position.inSeconds >= 5) {
                    var newPosition = _position.inSeconds - 5;
                    advancedPlayer.seek(Duration(seconds: newPosition));
                  }
                },
                iconData: _icons[4],
                iconSize: 40,
                iconColor: AppColor.primaryColor,
                buttonColor: Colors.white,
                isForward: true,
              ),
              MediaPlayerButton(
                onPressed: () {
                  log("old state:${audioState.name}");
                  if (audioState == AudioState.none) {
                    if (widget.audioModel.audioUrl.contains('http')) {
                      advancedPlayer
                          .play(UrlSource(widget.audioModel.audioUrl));
                    } else {
                      advancedPlayer
                          .play(DeviceFileSource(widget.audioModel.audioUrl));
                    }

                    setState(() {
                      audioState = AudioState.play;
                    });
                  } else if (audioState == AudioState.play) {
                    advancedPlayer.pause();
                    setState(() {
                      audioState = AudioState.pause;
                    });
                  } else if (audioState == AudioState.pause) {
                    advancedPlayer.resume();
                    setState(() {
                      audioState = AudioState.play;
                    });
                  }
                  log("new state:${audioState.name}");
                },
                iconData: (audioState == AudioState.pause ||
                        audioState == AudioState.none)
                    ? _icons[0]
                    : _icons[1],
                iconSize: 22,
              ),
              MediaPlayerButton(
                iconColor: AppColor.primaryColor,
                buttonColor: Colors.white,
                onPressed: () {
                  if (_duration.inSeconds - _position.inSeconds >= 5) {
                    var newPosition = _position.inSeconds + 5;

                    advancedPlayer.seek(Duration(seconds: newPosition));
                  }
                },
                iconData: _icons[5],
                iconSize: 40,
                isForward: true,
              ),
            ],
          )
        ],
      ),
    );
  }
}

enum AudioState { play, pause, stop, loop, forward, rewind, none }
