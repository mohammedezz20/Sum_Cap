import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sum_cap/config/themes/colors.dart';
import 'package:sum_cap/core/utils/assets_manager.dart';
import 'package:sum_cap/core/utils/extensions/sized_box_extensions.dart';
import 'package:sum_cap/features/record_audio/presentation/widgets/audio_player.dart';

class RecordAudioScreen extends StatelessWidget {
  const RecordAudioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColor.whiteColor,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back_ios),
            ),
          ),
          backgroundColor: AppColor.offWhiteColor,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.w),
                child: Row(
                  children: [
                    Text(
                      'New Recording',
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
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Text(
                      'For a high-quality transcription, please \n \t\t\t\t\t\t\t\t speak slowly and clearly',
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: AppColor.blackColor, fontSize: 18.sp),
                    ),
                  ),
                  Image.asset(Assets.recordScreen),
                ],
              ),
              AudioPlayerWidget()
            ],
          ),
        ),
      ),
    );
  }
}
