import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sum_cap/config/themes/colors.dart';
import 'package:sum_cap/core/utils/extensions/sized_box_extensions.dart';
import 'package:sum_cap/core/widgets/custom_button.dart';
import 'package:sum_cap/features/app_layout/presentation/cubit/app_layout_cubit.dart';
import 'package:sum_cap/features/app_layout/presentation/cubit/app_layout_states.dart';
import 'package:sum_cap/features/app_layout/presentation/widgets/add_youtube_dialog_widget.dart';
import 'package:sum_cap/features/record_audio/presentation/pages/record_audio_screen.dart';

class AddBottomSheet extends StatelessWidget {
  const AddBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = AppLayoutCubit.get(context);
    return BlocConsumer<AppLayoutCubit, AppLayoutStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          alignment: Alignment.center,
          height: 220.h,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10.w),
                child: Container(
                  width: 100.w,
                  height: 8,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppColor.greyColor,
                  ),
                ),
              ),
              10.h.sizedBoxHeight,
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomButton(
                    widget: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.mic_none_outlined,
                          color: AppColor.primaryColor,
                          size: 30,
                        ),
                        2.w.sizedBoxWidth,
                        Text(
                          'Record Audio',
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(
                                  color: AppColor.primaryColor,
                                  fontSize: 18.sp),
                        ),
                      ],
                    ),
                    height: 45.h,
                    width: double.infinity,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RecordAudioScreen(),
                        ),
                      );
                    },
                  ),
                  15.h.sizedBoxHeight,
                  CustomButton(
                    widget: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          FontAwesomeIcons.youtube,
                          color: AppColor.primaryColor,
                          size: 25,
                        ),
                        10.w.sizedBoxWidth,
                        Text(
                          'Transcript Youtube Video',
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(
                                  color: AppColor.primaryColor,
                                  fontSize: 18.sp),
                        ),
                      ],
                    ),
                    height: 45.h,
                    width: double.infinity,
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return const YoutubeDialog();
                        },
                      );
                      //Todo Transcript Youtube  Video Function
                    },
                  ),
                  15.h.sizedBoxHeight,
                  CustomButton(
                      widget: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.file_upload_outlined,
                            color: AppColor.primaryColor,
                            size: 30,
                          ),
                          2.w.sizedBoxWidth,
                          Text(
                            'Upload Audio',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(
                                    color: AppColor.primaryColor,
                                    fontSize: 18.sp),
                          ),
                        ],
                      ),
                      height: 45.h,
                      width: double.infinity,
                      onTap: () {
                        cubit.pickFile(context);
                      }),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
