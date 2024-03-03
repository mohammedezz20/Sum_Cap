import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sum_cap/config/themes/colors.dart';
import 'package:sum_cap/core/utils/assets_manager.dart';
import 'package:sum_cap/features/record_audio/presentation/cubit/audio_cubit.dart';
import 'package:sum_cap/features/record_audio/presentation/widgets/audio_player.dart';

class RecordAudioScreen extends StatefulWidget {
  const RecordAudioScreen({super.key});

  @override
  State<RecordAudioScreen> createState() => _RecordAudioScreenState();
}

class _RecordAudioScreenState extends State<RecordAudioScreen> {
  var cubit;
  @override
  void initState() {
    super.initState();
    cubit = AudioCubit.get(context);

    cubit.usernameController.text = 'New Recording';
  }

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
          body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.w),
                  child: TextFormField(
                    cursorColor: AppColor.blackColor,
                    style: const TextStyle(
                      color: AppColor.blackColor,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                    onTapOutside: (_) {
                      FocusScope.of(context).unfocus();
                    },
                    controller: cubit.usernameController,
                    decoration: const InputDecoration(
                      hintText: 'New Recording',
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: AppColor.primaryColor,
                        ),
                      ),
                      disabledBorder: OutlineInputBorder(),
                      errorBorder: OutlineInputBorder(),
                      focusedErrorBorder: OutlineInputBorder(),
                      contentPadding: EdgeInsets.all(10),
                      hintStyle: TextStyle(
                        color: AppColor.blackColor,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 480.h,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: Text(
                          'For a high-quality transcription, please \n \t\t\t\t\t\t\t\t speak slowly and clearly',
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(
                                  color: AppColor.blackColor, fontSize: 18.sp),
                        ),
                      ),
                      Image.asset(Assets.recordScreen),
                    ],
                  ),
                ),
                SizedBox(
                    width: MediaQuery.sizeOf(context).width,
                    child: const AudioPlayerView())
              ],
            ),
          ),
        ),
      ),
    );
  }
}
