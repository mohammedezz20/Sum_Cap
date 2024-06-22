import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sum_cap/core/utils/enums.dart';
import 'package:sum_cap/core/utils/extensions/sized_box_extensions.dart';
import 'package:sum_cap/core/widgets/custom_button.dart';
import 'package:sum_cap/features/app_layout/data/models/audio_model.dart';
import 'package:sum_cap/features/app_layout/presentation/cubit/app_layout_cubit.dart';
import 'package:sum_cap/features/app_layout/presentation/cubit/app_layout_states.dart';

import '../../../../config/themes/colors.dart';

class YoutubeDialog extends StatelessWidget {
  const YoutubeDialog({super.key});

  @override
  Widget build(BuildContext context) {
    var cubit = AppLayoutCubit.get(context);
    var key = GlobalKey<FormState>();
    var namecontroller = TextEditingController();
    var urlController = TextEditingController();
    return BlocConsumer<AppLayoutCubit, AppLayoutStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return AlertDialog(
          backgroundColor: AppColor.offWhiteColor,
          // title: const Center(child: Text('File Name')),
          content: Form(
            key: key,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  child: TextFormField(
                    controller: namecontroller,
                    onChanged: (value) {},
                    validator: (val) {
                      if (val!.isEmpty) {
                        return 'Please enter file name';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: 'File Name',
                      labelStyle: Theme.of(context).textTheme.labelSmall,
                      hintStyle: Theme.of(context).textTheme.labelSmall,
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:
                            const BorderSide(color: AppColor.primaryColor),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                            color: AppColor.primaryColor, width: 2),
                      ),
                    ),
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall
                        ?.copyWith(color: Colors.black),
                  ),
                ),
                10.h.sizedBoxHeight,
                SizedBox(
                  child: TextFormField(
                    controller: urlController,
                    validator: (val) {
                      if (val!.isEmpty) {
                        return 'Please enter youtube Url';
                      } else {
                        //check if is valid url or not
                        var regExp = RegExp(
                          r"^(?:http(s)?:\/\/)?[\w.-]+(?:\.[\w\.-]+)+[\w\-\._~:/?#[\]@!\$&'\(\)\*\+,;=.]+$",
                        );
                        if (!regExp.hasMatch(val)) {
                          return 'Please enter valid youtube Url';
                        }
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: 'URL',
                      labelStyle: Theme.of(context).textTheme.labelSmall,
                      hintStyle: Theme.of(context).textTheme.labelSmall,
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:
                            const BorderSide(color: AppColor.primaryColor),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                            color: AppColor.primaryColor, width: 2),
                      ),
                    ),
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall
                        ?.copyWith(color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            CustomButton(
                widget: Text(
                  'Upload File',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(color: AppColor.primaryColor, fontSize: 18.sp),
                ),
                height: 50.h,
                width: double.infinity,
                onTap: () async {
                  if (key.currentState?.validate() == true) {
                    cubit
                        .download(urlController.text, context)
                        .whenComplete(() async {
                      AudioModel audioModel = AudioModel(
                        audioUrl: cubit.filePath ?? '',
                        title: namecontroller.text,
                        transcriptionText: '',
                        createdAt: DateTime.now(),
                        duration: cubit.audioDuration!,
                        audioName: namecontroller.text +
                            DateTime.now().millisecondsSinceEpoch.toString(),
                        status: FileStatus.trancripting,
                      );
                      cubit.audios.add(audioModel);
                      Navigator.pop(context);
                      Navigator.pop(context);

                      await cubit
                          .transcriptFile(cubit.filePath, audioModel.audioName)
                          .whenComplete(() {
                        audioModel.transcriptionText =
                            cubit.transcriptionText ?? '';
                        audioModel.paragraphs = cubit.paragraphs;
                        audioModel.topics = cubit.topics;
                        log(audioModel.topics!.length.toString());
                        log(audioModel.paragraphs!.length.toString());
                        cubit.uploadFile(audioModel: audioModel);
                        namecontroller.clear();
                        cubit.filePath = '';
                        cubit.transcriptionText = '';
                        cubit.audioDuration = '';
                      });
                    });
                  }
                }),
            10.h.sizedBoxHeight,
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '* ',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(color: AppColor.redColor),
                  ),
                  Text(
                    'Audio must not be exceed 2 minutes.',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
