import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_audio/just_audio.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:sum_cap/config/themes/colors.dart';
import 'package:sum_cap/core/utils/extensions/sized_box_extensions.dart';
import 'package:sum_cap/core/widgets/custom_button.dart';
import 'package:sum_cap/features/app_layout/presentation/cubit/app_layout_cubit.dart';
import 'package:sum_cap/features/app_layout/presentation/cubit/app_layout_states.dart';
import 'package:sum_cap/features/app_layout/presentation/widgets/add_youtube_dialog_widget.dart';
import 'package:sum_cap/features/app_layout/presentation/widgets/dialog_widget.dart';
import 'package:sum_cap/features/app_layout/presentation/widgets/file_shimmer_widget.dart';
import 'package:sum_cap/features/app_layout/presentation/widgets/file_widget.dart';
import 'package:sum_cap/features/record_audio/presentation/cubit/audio_cubit.dart';

import '../../../../core/shared_pref_helper.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late StreamSubscription _intentSub;
  final _sharedFiles = <SharedMediaFile>[];

  @override
  void initState() {
    checkAudioReceived(context);
    super.initState();
  }

  // void checkAudioReceived(BuildContext context) {
  //   _intentSub =
  //       ReceiveSharingIntent.instance.getMediaStream().listen((value) async {
  //     await handleSharedFiles(value, context);
  //   }, onError: (err) {
  //     print("getIntentDataStream error: $err");
  //   });

  //   // Get the media sharing coming from outside the app while the app is closed.
  //   ReceiveSharingIntent.instance.getInitialMedia().then((value) {
  //     handleSharedFiles(value, context);
  //   });
  // }

  // Future<void> handleSharedFiles(
  //     List<SharedMediaFile> value, BuildContext context) async {
  //   _sharedFiles.clear();
  //   if (value.isNotEmpty) {
  //     _sharedFiles.addAll(value);

  //     for (var file in _sharedFiles) {
  //       log("file path : ${file.path}");
  //       final player = AudioPlayer();
  //       await player.setAudioSource(AudioSource.uri(Uri.parse(file.path)));
  //       final duration = await player.durationStream.first;
  //       await player.dispose();
  //       if (context.mounted) {
  //         AppLayoutCubit.get(context).audioDuration =
  //             duration.toString().substring(2, 7);
  //         log(AppLayoutCubit.get(context).audioDuration!);
  //         _handleSharedAudio(file.path, context);
  //       }
  //     }
  //   } else {
  //     log('No shared files received');
  //   }
  // }

  // void _handleSharedAudio(String audioPath, context) {
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     showDialog(
  //       context: context,
  //       builder: (context) => CustomDialogWidget(audioPath: audioPath),
  //     );
  //   });
  // }

  void checkAudioReceived(BuildContext context) {
    _intentSub =
        ReceiveSharingIntent.instance.getMediaStream().listen((value) async {
      await handleSharedFiles(value, context);
    }, onError: (err) {
      print("getIntentDataStream error: $err");
    });

    // Get the media sharing coming from outside the app while the app is closed.
    ReceiveSharingIntent.instance.getInitialMedia().then((value) {
      handleSharedFiles(value, context);
    });
  }

  Future<void> handleSharedFiles(
      List<SharedMediaFile> value, BuildContext context) async {
    _sharedFiles.clear();
    if (value.isNotEmpty) {
      _sharedFiles.addAll(value);

      for (var file in _sharedFiles) {
        log("file path : ${file.path}");

        // Check if the shared file is a YouTube video
        if (isYouTubeVideo(file.path)) {
          return; // _handleSharedAudio(file.path, context, isyoutube: true);
        } else {
          final player = AudioPlayer();
          await player.setAudioSource(AudioSource.uri(Uri.parse(file.path)));
          final duration = await player.durationStream.first;
          await player.dispose();
          if (context.mounted) {
            AppLayoutCubit.get(context).audioDuration =
                duration.toString().substring(2, 7);
            log(AppLayoutCubit.get(context).audioDuration!);
            _handleSharedAudio(file.path, context);
          }
        }
      }
    } else {
      log('No shared files received');
    }
  }

  bool isYouTubeVideo(String url) {
    final youtubeRegex =
        RegExp(r'^(https?:\/\/)?(www\.)?(youtube\.com|youtu\.?be)\/.+$');
    return youtubeRegex.hasMatch(url);
  }

  void _handleSharedAudio(String audioPath, context, {bool isyoutube = false}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
        context: context,
        builder: (context) {
          if (isyoutube) {
            return YoutubeDialog(url: audioPath);
          } else {
            return CustomDialogWidget(audioPath: audioPath);
          }
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    var cubit = AppLayoutCubit.get(context);
    return BlocListener<AudioCubit, AudioState>(
      listener: (context, state) {
        if (state is DeleteAudioSuccessState) {
          cubit.getAudios();
        } else if (state is EditAudioSuccessState) {
          cubit.getAudios();
        }
      },
      child: BlocBuilder<AppLayoutCubit, AppLayoutStates>(
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.w),
                child: Text(
                  cubit.isMorning
                      ? 'Good Morning 👋  \n${SharedPrefHelper.getData(key: 'username')}'
                      : 'Good Afternoon 👋 \n${SharedPrefHelper.getData(key: 'username')}',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(fontSize: 18.sp),
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: Container(
                  padding: EdgeInsets.only(left: 20.w),
                  width: double.infinity,
                  height: 45.h,
                  decoration: BoxDecoration(
                    color: const Color(0xffDFF0E3),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'All Files',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(fontSize: 16.sp, color: AppColor.blackColor),
                  ),
                ),
              ),
              (state is AppLayoutGetUserAudioLoadingState)
                  ? Expanded(
                      child: ListView.separated(
                      itemBuilder: (context, index) => const ShimerFileWidget(),
                      separatorBuilder: (context, index) => 20.h.sizedBoxHeight,
                      itemCount: 10,
                    ))
                  : (cubit.audios.isNotEmpty)
                      ? Expanded(
                          child: RefreshIndicator(
                            onRefresh: () => cubit.getAudios(),
                            child: ListView.separated(
                                itemBuilder: (context, index) =>
                                    FileWidget(audio: cubit.audios[index]),
                                separatorBuilder: (context, index) =>
                                    20.h.sizedBoxHeight,
                                itemCount: cubit.audios.length),
                          ),
                        )
                      : Expanded(
                          child: Center(
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "No Files Found",
                                    style: TextStyle(
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  20.h.sizedBoxHeight,
                                  CustomButton(
                                      widget: Text("Reload",
                                          style: TextStyle(
                                              color: AppColor.primaryColor,
                                              fontSize: 16.sp)),
                                      height: 40.h,
                                      width: 300.w,
                                      onTap: () {
                                        cubit.getAudios();
                                      })
                                ]),
                          ),
                        ),
            ],
          );
        },
      ),
    );
  }
}
