import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sum_cap/config/themes/colors.dart';
import 'package:sum_cap/features/record_audio/presentation/cubit/audio_recorder_controller.dart';
import 'package:sum_cap/features/record_audio/presentation/cubit/audio_cubit.dart';
import 'package:sum_cap/features/record_audio/presentation/cubit/audio_record_cubit/audio_recoed_cubit.dart';

class AudioWaveWidgte extends StatefulWidget {
  const AudioWaveWidgte({super.key});

  @override
  State<AudioWaveWidgte> createState() => _AudioWaveWidgteState();
}

class _AudioWaveWidgteState extends State<AudioWaveWidgte> {
  final ScrollController scrollController = ScrollController();
  List<double> amplitudes = [];
  late StreamSubscription<double> _amplitudeSubscription;

  var height = 40.h;
  double wavMaxHeight = 50;
  double minampl = -67;

  @override
  void initState() {
    _amplitudeSubscription =
        context.read<AudioRecoedCubit>().amplitudeStream.listen((double ampl) {
      setState(() {
        amplitudes.add(ampl);
        if (scrollController.positions.isNotEmpty) {
          scrollController.animateTo(
            scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 1),
            curve: Curves.linear,
          );
        }
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    _amplitudeSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: wavMaxHeight,
      child: ListView.builder(
        controller: scrollController,
        scrollDirection: Axis.horizontal,
        itemCount: amplitudes.length,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          double ampl = amplitudes[index].clamp(minampl + 1, 0);
          double amplPercent = 1 - (ampl / minampl).abs();
          double waveHeight = amplPercent * wavMaxHeight;
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 2.w),
            child: Center(
              child: TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: 0, end: waveHeight),
                duration: const Duration(milliseconds: 100),
                builder: (context, value, child) =>
                    SizedBox(height: value, width: 4.w, child: child),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: AppColor.primaryColor,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
