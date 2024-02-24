import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:sum_cap/config/themes/colors.dart';
import 'package:sum_cap/core/utils/extensions/sized_box_extensions.dart';
import 'package:sum_cap/core/widgets/custom_button.dart';
import 'package:sum_cap/features/app_layout/data/models/audio_model.dart';

class RecordDetails extends StatelessWidget {
  RecordDetails({Key? key, required this.audio}) : super(key: key);
  AudioModel audio;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColor.whiteColor,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            actions: [
              const Icon(Icons.search),
              20.w.sizedBoxWidth,
              const Icon(Icons.menu),
              20.w.sizedBoxWidth,
            ],
          ),
          backgroundColor: AppColor.offWhiteColor,
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.w),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        audio.title,
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            color: AppColor.blackColor, fontSize: 18.sp),
                      ),
                      5.w.sizedBoxWidth,
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.edit_outlined,
                          size: 24,
                          color: AppColor.primaryColor,
                        ),
                      ),
                    ],
                  ),
                  5.h.sizedBoxHeight,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_month,
                            color: AppColor.greyColor,
                            size: 14.w,
                          ),
                          Text(
                            "${audio.createdAt.day}/${audio.createdAt.month}/${audio.createdAt.year}",
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(
                                    color: AppColor.greyColor, fontSize: 14.sp),
                          ),
                          20.w.sizedBoxWidth,
                          Text(
                            DateFormat('hh:mm a').format(
                              audio.createdAt.toUtc().add(
                                    const Duration(hours: 2),
                                  ),
                            ),
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(
                                    color: AppColor.greyColor, fontSize: 14.sp),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.watch_later_outlined,
                            size: 14.w,
                            color: AppColor.primaryColor,
                          ),
                          5.w.sizedBoxWidth,
                          Text(
                            audio.duration,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.text_fields_outlined,
                            size: 15.w,
                            color: AppColor.primaryColor,
                          ),
                          5.w.sizedBoxWidth,
                          Text(
                            '${audio.transcriptionText.length}',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(
                                    fontSize: 14.sp, color: AppColor.greyColor),
                          ),
                          Text(
                            ' letters',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(
                                    fontSize: 14.sp, color: AppColor.greyColor),
                          ),
                        ],
                      ),
                    ],
                  ),
                  20.h.sizedBoxHeight,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        children: [
                          CustomButton(
                              widget: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.edit,
                                    color: AppColor.primaryColor,
                                    size: 18.w,
                                  ),
                                  5.w.sizedBoxWidth,
                                  Text(
                                    'Edit',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall!
                                        .copyWith(
                                            color: AppColor.primaryColor,
                                            fontSize: 14.sp),
                                  ),
                                ],
                              ),
                              height: 36.h,
                              width: 65.w,
                              onTap: () {}),
                        ],
                      ),
                      Row(
                        children: [
                          CustomButton(
                              widget: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    FontAwesomeIcons.wandMagicSparkles,
                                    color: AppColor.primaryColor,
                                    size: 18.w,
                                  ),
                                  5.w.sizedBoxWidth,
                                  Text(
                                    'Summary',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall!
                                        .copyWith(
                                            color: AppColor.primaryColor,
                                            fontSize: 14.sp),
                                  ),
                                ],
                              ),
                              height: 36.h,
                              width: 93.w,
                              onTap: () {}),
                        ],
                      ),
                      Row(
                        children: [
                          CustomButton(
                              widget: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.g_translate_outlined,
                                    color: AppColor.primaryColor,
                                    size: 18.w,
                                  ),
                                  5.w.sizedBoxWidth,
                                  Text(
                                    'Translate',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall!
                                        .copyWith(
                                            color: AppColor.primaryColor,
                                            fontSize: 14.sp),
                                  ),
                                ],
                              ),
                              height: 36.h,
                              width: 87.w,
                              onTap: () {}),
                        ],
                      ),
                      Row(
                        children: [
                          CustomButton(
                              widget: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.copy,
                                    color: AppColor.primaryColor,
                                    size: 18.w,
                                  ),
                                  5.w.sizedBoxWidth,
                                  Text(
                                    'copy',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall!
                                        .copyWith(
                                            color: AppColor.primaryColor,
                                            fontSize: 14.sp),
                                  ),
                                ],
                              ),
                              height: 36.h,
                              width: 65.w,
                              onTap: () {}),
                        ],
                      ),
                    ],
                  ),
                  20.h.sizedBoxHeight,
                  Container(
                    padding: EdgeInsets.all(10.w),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColor.primaryColor),
                      color: AppColor.whiteColor,
                    ),
                    child: Text(
                      audio.transcriptionText,
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall!
                          .copyWith(fontSize: 15.sp),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
