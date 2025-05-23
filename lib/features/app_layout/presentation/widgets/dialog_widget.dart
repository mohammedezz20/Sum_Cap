// import 'dart:developer';

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:sum_cap/core/utils/enums.dart';
// import 'package:sum_cap/core/utils/extensions/sized_box_extensions.dart';
// import 'package:sum_cap/core/widgets/custom_button.dart';
// import 'package:sum_cap/features/app_layout/data/models/audio_model.dart';
// import 'package:sum_cap/features/app_layout/presentation/cubit/app_layout_cubit.dart';
// import 'package:sum_cap/features/app_layout/presentation/cubit/app_layout_states.dart';

// import '../../../../config/themes/colors.dart';

// class CustomDialogWidget extends StatelessWidget {
//   const CustomDialogWidget({super.key});

//   @override
//   Widget build(BuildContext context) {
//     var cubit = AppLayoutCubit.get(context);
//     var key = GlobalKey<FormState>();
//     var namecontroller = TextEditingController();

//     return BlocConsumer<AppLayoutCubit, AppLayoutStates>(
//       listener: (context, state) {},
//       builder: (context, state) {
//         return PopScope(
//           canPop: false,
//           child: AlertDialog(
//             backgroundColor: AppColor.offWhiteColor,
//             title: const Center(child: Text('Audio Name')),
//             content: Form(
//               key: key,
//               child: SizedBox(
//                 child: TextFormField(
//                   controller: namecontroller,
//                   onChanged: (value) {},
//                   validator: (val) {
//                     if (val!.isEmpty) {
//                       return 'Please enter audio name';
//                     }
//                     return null;
//                   },
//                   decoration: InputDecoration(
//                     labelStyle: Theme.of(context).textTheme.labelSmall,
//                     hintStyle: Theme.of(context).textTheme.labelSmall,
//                     focusedBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(10),
//                       borderSide:
//                           const BorderSide(color: AppColor.primaryColor),
//                     ),
//                     errorBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(10),
//                       borderSide: const BorderSide(
//                           color: AppColor.primaryColor, width: 2),
//                     ),
//                   ),
//                   textAlign: TextAlign.center,
//                   style: Theme.of(context)
//                       .textTheme
//                       .titleSmall
//                       ?.copyWith(color: Colors.black),
//                 ),
//               ),
//             ),
//             actions: [
//               CustomButton(
//                 widget: Text(
//                   'Upload Audio',
//                   style: Theme.of(context)
//                       .textTheme
//                       .titleLarge!
//                       .copyWith(color: AppColor.primaryColor, fontSize: 18.sp),
//                 ),
//                 height: 50.h,
//                 width: double.infinity,
//                 onTap: () async {
//                   if (key.currentState?.validate() == true) {
//                     AudioModel audioModel = AudioModel(
//                       audioUrl: cubit.filePath!,
//                       title: namecontroller.text,
//                       transcriptionText: '',
//                       createdAt: DateTime.now(),
//                       duration: cubit.audioDuration!,
//                       audioName: namecontroller.text +
//                           DateTime.now().millisecondsSinceEpoch.toString(),
//                       status: FileStatus.trancripting,
//                     );
//                     cubit.audios.add(audioModel);
//                     Navigator.pop(context); // Close the dialog
//                     Navigator.pop(
//                         context); // Close the previous screen if needed

//                     await cubit
//                         .transcriptFile(cubit.filePath, audioModel.audioName,
//                             isArabic: cubit.isArabic)
//                         .whenComplete(() {
//                       audioModel.transcriptionText =
//                           cubit.transcriptionText ?? '';
//                       audioModel.paragraphs = cubit.paragraphs;
//                       audioModel.topics = cubit.topics;
//                       log("====================================================================================");
//                       log(audioModel.topics!.length.toString());
//                       log(audioModel.paragraphs!.length.toString());
//                       cubit.uploadFile(audioModel: audioModel);

//                       namecontroller.clear();
//                       cubit.filePath = '';
//                       cubit.transcriptionText = '';
//                       cubit.audioDuration = '';
//                     });
//                   }
//                 },
//               ),
//               10.h.sizedBoxHeight,
//               CustomButton(
//                 colorBorder: AppColor.redColor,
//                 widget: Text(
//                   'Discard Audio',
//                   style: Theme.of(context)
//                       .textTheme
//                       .titleLarge!
//                       .copyWith(color: AppColor.redColor, fontSize: 18.sp),
//                 ),
//                 height: 50.h,
//                 width: double.infinity,
//                 onTap: () {
//                   Navigator.pop(context);
//                 },
//               ),
//               ListTile(
//                 title: Text(
//                   'Transcript Language (${cubit.isArabic ? 'Arabic' : 'English'})',
//                   style: Theme.of(context).textTheme.bodyMedium,
//                 ),
//                 trailing: Switch(
//                   inactiveThumbColor: const Color(0xffffffff),
//                   activeTrackColor: const Color(0xff335ef7),
//                   inactiveTrackColor: const Color(0xffeeeeee),
//                   value: cubit.isArabic,
//                   onChanged: (value) {
//                     cubit.changeLang(value);
//                     print(cubit.isArabic);
//                   },
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }

// void showCustomDialog(BuildContext context) {
//   showDialog(
//     context: context,
//     barrierDismissible: false, // Prevents closing on tapping outside
//     builder: (BuildContext context) {
//       return const CustomDialogWidget();
//     },
//   );
// }

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

class CustomDialogWidget extends StatelessWidget {
  final String audioPath;

  const CustomDialogWidget({super.key, required this.audioPath});

  @override
  Widget build(BuildContext context) {
    var cubit = AppLayoutCubit.get(context);
    var key = GlobalKey<FormState>();
    var namecontroller = TextEditingController();

    return BlocConsumer<AppLayoutCubit, AppLayoutStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
            backgroundColor: AppColor.offWhiteColor,
            title: const Center(child: Text('Audio Name')),
            content: Form(
              key: key,
              child: SizedBox(
                child: TextFormField(
                  controller: namecontroller,
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
                    if (audioPath.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('No audio file selected.'),
                      ));
                      return;
                    }

                    AudioModel audioModel = AudioModel(
                      audioUrl: audioPath,
                      title: namecontroller.text,
                      transcriptionText: '',
                      createdAt: DateTime.now(),
                      duration: cubit.audioDuration!,
                      audioName: namecontroller.text +
                          DateTime.now().millisecondsSinceEpoch.toString(),
                      status: FileStatus.trancripting,
                    );
                    cubit.audios.add(audioModel);
                    Navigator.pop(context); // Close the dialog
                    // Navigator.pop(
                    //     context); // Close the previous screen if needed

                    await cubit
                        .transcriptFile(audioPath, audioModel.audioName,
                            isArabic: cubit.isArabic)
                        .whenComplete(() {
                      audioModel.transcriptionText =
                          cubit.transcriptionText ?? '';
                      audioModel.paragraphs = cubit.paragraphs;
                      audioModel.topics = cubit.topics;
                      log("====================================================================================");
                      log(audioModel.topics!.length.toString());
                      log(audioModel.paragraphs!.length.toString());
                      cubit.uploadFile(audioModel: audioModel);

                      namecontroller.clear();
                      cubit.filePath = '';
                      cubit.transcriptionText = '';
                      cubit.audioDuration = '';
                    });
                  }
                },
              ),
              10.h.sizedBoxHeight,
              CustomButton(
                colorBorder: AppColor.redColor,
                widget: Text(
                  'Discard Audio',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(color: AppColor.redColor, fontSize: 18.sp),
                ),
                height: 50.h,
                width: double.infinity,
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text(
                  'Transcript Language (${cubit.isArabic ? 'Arabic' : 'English'})',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                trailing: Switch(
                  inactiveThumbColor: const Color(0xffffffff),
                  activeTrackColor: const Color(0xff335ef7),
                  inactiveTrackColor: const Color(0xffeeeeee),
                  value: cubit.isArabic,
                  onChanged: (value) {
                    cubit.changeLang(value);
                    log(cubit.isArabic.toString());
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

void showCustomDialog(BuildContext context, String audioPath) {
  showDialog(
    context: context,
    barrierDismissible: false, // Prevents closing on tapping outside
    builder: (BuildContext context) {
      return CustomDialogWidget(audioPath: audioPath);
    },
  );
}
