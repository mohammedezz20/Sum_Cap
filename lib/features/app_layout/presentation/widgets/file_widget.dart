import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:sum_cap/config/themes/colors.dart';
import 'package:sum_cap/core/utils/enums.dart';
import 'package:sum_cap/core/utils/extensions/sized_box_extensions.dart';
import 'package:sum_cap/features/app_layout/data/models/audio_model.dart';
import 'package:sum_cap/features/app_layout/presentation/cubit/app_layout_cubit.dart';
import 'package:sum_cap/features/app_layout/presentation/cubit/app_layout_states.dart';
import 'package:sum_cap/features/record_audio/presentation/pages/record_details.dart';

class FileWidget extends StatelessWidget {
  AudioModel audio;
  FileWidget({super.key, required this.audio});

  @override
  Widget build(BuildContext context) {
    String targetTimeZone = "Africa/Cairo";

    var time =
        "${audio.createdAt.hour}:${audio.createdAt.minute}:${audio.createdAt.second}";
    DateTime dateTime = DateTime.parse(audio.createdAt.toString());
    print(dateTime);
    return BlocConsumer<AppLayoutCubit, AppLayoutStates>(
      listener: (context, state) {
        if (state is TranscriptionLoadingState) {
          if (state.fileName == audio.title) {
            audio.status = FileStatus.trancripting;
          }
        } else if (state is TranscriptionErrorState) {
          if (state.fileName == audio.title) {
            audio.status = FileStatus.error;
          }
        } else if (state is UploadAudioLoadingState) {
          if (state.fileName == audio.title) {
            audio.status = FileStatus.uploading;
          }
        } else if (state is UploadAudioErrorState) {
          if (state.fileName == audio.title) {
            audio.status = FileStatus.error;
          }
        } else if (state is UploadAudioSuccessState) {
          if (state.fileName == audio.title) {
            audio.status = FileStatus.done;
          }
        } else if (state is TranscriptionSuccessState) {
          if (state.fileName == audio.title) {
            audio.status = FileStatus.done;
          }
        }
      },
      builder: (context, state) {
        return CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () {
            if (audio.status == FileStatus.done) {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return RecordDetails(audio: audio);
              }));
            }
          },
          child: Container(
              padding: EdgeInsets.all(15.w),
              decoration: BoxDecoration(
                color: AppColor.whiteColor,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                children: [
                  const Icon(
                    FontAwesomeIcons.solidFile,
                    color: AppColor.primaryColor,
                    size: 35,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              "${audio.createdAt.year}-${audio.createdAt.month}-${audio.createdAt.day}",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall!
                                  .copyWith(
                                      color: AppColor.greyColor,
                                      fontSize: 18.sp),
                            ),
                            (20.w).sizedBoxWidth,
                            Text(
                              DateFormat('hh:mm a').format(dateTime
                                  .toUtc()
                                  .add(const Duration(hours: 2))),
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall!
                                  .copyWith(
                                      color: AppColor.greyColor,
                                      fontSize: 18.sp),
                            ),
                          ],
                        ),
                        10.h.sizedBoxHeight,
                        Text(
                          audio.title,
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(fontSize: 20.sp),
                        ),
                        10.h.sizedBoxHeight,
                        Row(
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.watch_later_outlined,
                                  color: AppColor.primaryColor,
                                  size: 20,
                                ),
                                10.w.sizedBoxWidth,
                                Text(
                                  audio.duration,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall!
                                      .copyWith(
                                          color: AppColor.greyColor,
                                          fontSize: 18.sp),
                                ),
                              ],
                            ),
                            90.w.sizedBoxWidth,
                            if (audio.status == FileStatus.trancripting) ...[
                              const Icon(
                                FontAwesomeIcons.closedCaptioning,
                                color: AppColor.primaryColor,
                                size: 14,
                              ),
                              5.w.sizedBoxWidth,
                            ],
                            if (audio.status == FileStatus.uploading) ...[
                              const Icon(
                                FontAwesomeIcons.cloudArrowUp,
                                color: AppColor.redColor,
                                size: 14,
                              ),
                              5.w.sizedBoxWidth,
                            ],
                            if (audio.status == FileStatus.error) ...[
                              const Icon(
                                FontAwesomeIcons.triangleExclamation,
                                color: AppColor.redColor,
                                size: 14,
                              ),
                              5.w.sizedBoxWidth,
                            ],
                            if (audio.status == FileStatus.done) ...[
                              const Icon(
                                FontAwesomeIcons.circleCheck,
                                color: AppColor.primaryColor,
                                size: 14,
                              ),
                              5.w.sizedBoxWidth,
                            ],
                            Text(
                              audio.status != FileStatus.done
                                  ? audio.status.name
                                  : 'Completed',
                              style: TextStyle(
                                color: audio.status == FileStatus.error
                                    ? AppColor.redColor
                                    : AppColor.primaryColor,
                                fontSize: 12.sp,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              )),
        );
      },
    );
  }
}
