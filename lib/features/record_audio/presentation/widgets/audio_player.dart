import 'package:flutter/material.dart';
import 'package:flutter_audio_waveforms/flutter_audio_waveforms.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sum_cap/config/themes/colors.dart';
import 'package:sum_cap/core/utils/extensions/sized_box_extensions.dart';

class AudioPlayerWidget extends StatelessWidget {
  AudioPlayerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: 156.h,
      color: AppColor.whiteColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          PolygonWaveform(
            maxDuration: const Duration(seconds: 100),
            elapsedDuration: const Duration(seconds: 100),
            height: 300,
            width: MediaQuery.of(context).size.width,
            samples: [],
          ),
          10.h.sizedBoxHeight,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                height: 50.h,
                width: 50.w,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColor.redColor,
                ),
                child: const Icon(
                  Icons.stop_rounded,
                  color: Color(0xffD9D9D9),
                  size: 32,
                ),
              ),
              Container(
                height: 50.h,
                width: 50.w,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColor.primaryColor,
                ),
                child: const Icon(
                  Icons.play_arrow_rounded,
                  color: Color(0xffD9D9D9),
                  size: 32,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
