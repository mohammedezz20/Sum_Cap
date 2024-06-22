import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sum_cap/config/themes/colors.dart';
import 'package:sum_cap/core/widgets/custom_button.dart';
import 'package:sum_cap/features/live_transcript/presentation/cubit/live_transcript_cubit.dart';
import 'package:sum_cap/features/live_transcript/presentation/cubit/live_transcript_state.dart';

class LiveTranscriptView extends StatelessWidget {
  const LiveTranscriptView({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    //todo: add audio to database
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: BlocBuilder<LiveTranscriptCubit, TranscriptionState>(
          builder: (context, state) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: SizedBox(
                          width: 150,
                          child: Text(
                            state.transcript,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 50,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        width: 70.w,
                        child: CustomButton(
                          widget: Text(
                            'Start',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(
                                    color: AppColor.primaryColor,
                                    fontSize: 18.sp),
                          ),
                          height: 45.h,
                          width: double.infinity,
                          onTap: () {
                            context
                                .read<LiveTranscriptCubit>()
                                .startRecording();
                          },
                        ),
                      ),
                      const SizedBox(width: 5),
                      SizedBox(
                        width: 70.w,
                        child: CustomButton(
                          colorBorder: AppColor.redColor,
                          widget: Text(
                            'Stop',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(
                                    color: AppColor.redColor, fontSize: 18.sp),
                          ),
                          height: 45.h,
                          width: double.infinity,
                          onTap: () {
                            context.read<LiveTranscriptCubit>().stopRecording();
                          },
                        ),
                      ),
                      const SizedBox(width: 5),
                      SizedBox(
                        width: 100.w,
                        child: CustomButton(
                          colorBorder: AppColor.redColor,
                          widget: Text(
                            'Reset Text',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(
                                    color: AppColor.redColor, fontSize: 18.sp),
                          ),
                          height: 45.h,
                          width: double.infinity,
                          onTap: () {
                            context.read<LiveTranscriptCubit>().resetText();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
            );
          },
        ),
      ),
    );
  }
}
