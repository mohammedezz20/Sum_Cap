import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sum_cap/core/utils/enums.dart';
import 'package:sum_cap/core/widgets/custom_button.dart';
import 'package:sum_cap/features/app_layout/data/models/audio_model.dart';
import 'package:sum_cap/features/app_layout/presentation/cubit/app_layout_cubit.dart';
import 'package:sum_cap/features/app_layout/presentation/cubit/app_layout_states.dart';

import '../../../../config/themes/colors.dart';

class CustomDialogWidget extends StatelessWidget {
  const CustomDialogWidget({super.key});

  @override
  Widget build(BuildContext context) {
    var cubit = AppLayoutCubit.get(context);
    var key = GlobalKey<FormState>();
    var namecontroller = TextEditingController();
    return BlocConsumer<AppLayoutCubit, AppLayoutStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return AlertDialog(
          backgroundColor: AppColor.offWhiteColor,
          title: const Center(child: Text('Audio Name')),
          content: Form(
            key: key,
            child: SizedBox(
              child: TextFormField(
                controller: namecontroller,
                onChanged: (value) {},
                validator: (val) {
                  if (val!.isEmpty) {
                    return 'Please enter audio name';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelStyle: Theme.of(context).textTheme.labelSmall,
                  hintStyle: Theme.of(context).textTheme.labelSmall,
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: AppColor.primaryColor),
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
          ),
          actions: [
            CustomButton(
                widget: Text(
                  'Upload Audio',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(color: AppColor.primaryColor, fontSize: 18.sp),
                ),
                height: 50.h,
                width: double.infinity,
                onTap: () async {
                  if (key.currentState?.validate() == true) {
                    AudioModel audioModel = AudioModel(
                        audio: cubit.filePath!,
                        title: namecontroller.text,
                        transcriptionText: '',
                        createdAt: DateTime.now(),
                        duration: cubit.audioDuration!,
                        audioName: namecontroller.text,
                        status: FileStatus.trancripting);
                    cubit.audios.add(audioModel);
                    Navigator.pop(context);
                    Navigator.pop(context);

                    await cubit
                        .transcripeFile(cubit.filePath, namecontroller.text)
                        .whenComplete(() {
                      audioModel.transcriptionText = cubit.transcriptionText!;
                      cubit.uploadFile(audioModel: audioModel);

                      namecontroller.clear();
                      cubit.filePath = '';
                      cubit.transcriptionText = '';
                      cubit.audioDuration = '';
                    });
                  }
                })
          ],
        );
      },
    );
  }
}
