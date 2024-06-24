import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:record/record.dart';
import 'package:sum_cap/config/themes/colors.dart';
import 'package:sum_cap/core/utils/extensions/sized_box_extensions.dart';
import 'package:sum_cap/core/widgets/custom_button.dart';
import 'package:sum_cap/features/app_layout/data/models/audio_model.dart';
import 'package:sum_cap/features/app_layout/presentation/cubit/app_layout_cubit.dart';
import 'package:sum_cap/features/record_audio/presentation/cubit/audio_cubit.dart';
import 'package:sum_cap/features/record_audio/presentation/cubit/audio_record_cubit/audio_recoed_cubit.dart';
import 'package:sum_cap/features/record_audio/presentation/widgets/audio_wave_widget.dart';

import '../../../../core/utils/enums.dart';

class AudioPlayerView extends StatelessWidget {
  const AudioPlayerView({super.key});

  @override
  Widget build(BuildContext context) {
    return const AudioPlayerWidget();
  }
}

class AudioPlayerWidget extends StatefulWidget {
  const AudioPlayerWidget({super.key});

  @override
  State<AudioPlayerWidget> createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  @override
  Widget build(BuildContext context) {
    AudioRecoedCubit audioRecorderController = AudioRecoedCubit.get(context);

    final cubit = AppLayoutCubit.get(context);
    final audioCubit = AudioCubit.get(context);
    return StreamBuilder<Object>(
        stream: audioRecorderController.recordStateStream,
        builder: (context, snapshot) {
          return Container(
            alignment: Alignment.center,
            height: 220.h,
            color: AppColor.whiteColor,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const AudioWaveWidgte(),
                5.h.sizedBoxHeight,
                const _timer(),
                5.h.sizedBoxHeight,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CustomButton(
                      widget: Text('Discard Audio',
                          style: TextStyle(
                            color: AppColor.redColor,
                            fontSize: 15.sp,
                          )),
                      height: 40.h,
                      width: 100.w,
                      colorBorder: AppColor.redColor,
                      onTap: () async {
                        final String? path =
                            await audioRecorderController.stop();

//ToDo: Don't forget delete audio file from devise
                        // audioRecorderController.delete(path!);
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                    ),
                    CupertinoButton(
                      onPressed: () {
                        if (snapshot.data == RecordState.record) {
                          audioRecorderController.pause();
                        } else if (snapshot.data == RecordState.pause) {
                          audioRecorderController.resume();
                        } else {
                          audioRecorderController.start();
                        }
                      },
                      padding: EdgeInsets.zero,
                      child: Container(
                        height: 55.h,
                        width: 55.w,
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColor.primaryColor,
                        ),
                        child: Icon(
                          (snapshot.data == RecordState.record)
                              ? FontAwesomeIcons.pause
                              : FontAwesomeIcons.play,
                          color: const Color(0xffD9D9D9),
                        ),
                      ),
                    ),
                    CustomButton(
                      widget: Text('Add Audio',
                          style: TextStyle(
                            color: AppColor.primaryColor,
                            fontSize: 15.sp,
                          )),
                      height: 40.h,
                      width: 100.w,
                      onTap: () async {
                        final int durationInSeconds =
                            audioRecorderController.recordDuration;
                        final String? path =
                            await audioRecorderController.stop();

                        final int minutes = durationInSeconds ~/ 60;
                        final int seconds = durationInSeconds % 60;

                        AudioModel audioModel = AudioModel(
                            audioUrl: path!,
                            title: audioCubit.nameController.text,
                            transcriptionText: '',
                            createdAt: DateTime.now(),
                            duration:
                                '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
                            audioName: audioCubit.nameController.text +
                                DateTime.now()
                                    .millisecondsSinceEpoch
                                    .toString(),
                            status: FileStatus.trancripting);
                        cubit.audios.add(audioModel);
                        Navigator.pop(context);
                        Navigator.pop(context);

                        await cubit
                            .transcriptFile(path, audioModel.audioName,
                                isArabic: cubit.isArabic)
                            .whenComplete(() {
                          audioModel.transcriptionText =
                              cubit.transcriptionText ?? '';
                          audioModel.topics = cubit.topics;
                          audioModel.paragraphs = cubit.paragraphs;
                          cubit
                              .uploadFile(audioModel: audioModel)
                              .whenComplete(() {
                            // audioRecorderController.delete(audioModel.audio);
                          });
                          audioCubit.nameController.clear();
                          cubit.filePath = '';
                          cubit.transcriptionText = '';
                          cubit.audioDuration = '';
                        });
                      },
                    ),
                  ],
                ),
                ListTile(
                  title: Text(
                    'Transcript Language',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  trailing: Switch(
                    inactiveThumbColor: const Color(0xffffffff),
                    activeTrackColor: const Color(0xff335ef7),
                    inactiveTrackColor: const Color(0xffeeeeee),
                    value: cubit.isArabic,
                    onChanged: (value) {
                      cubit.isArabic = value;
                      print(cubit.isArabic);
                      setState(() {});
                    },
                  ),
                ),
              ],
            ),
          );
        });
  }
}

class _timer extends StatelessWidget {
  const _timer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(10.h),
        child: StreamBuilder(
          stream: AudioRecoedCubit.get(context).durationStreamOutput,
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            final int durationInSeconds = snapshot.data ?? 0;
            final int minutes = durationInSeconds ~/ 60;
            final int seconds = durationInSeconds % 60;
            return Text(
                '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
                style: const TextStyle(
                  color: AppColor.blackColor,
                  fontSize: 20,
                ));
          },
        ));
  }
}
