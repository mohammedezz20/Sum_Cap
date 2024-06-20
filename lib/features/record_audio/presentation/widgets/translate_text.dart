import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sum_cap/core/utils/extensions/build_context_extensions.dart';
import 'package:sum_cap/core/widgets/custom_button.dart';
import 'package:sum_cap/features/app_layout/presentation/cubit/app_layout_cubit.dart';
import 'package:sum_cap/features/record_audio/presentation/cubit/audio_cubit.dart';

import '../../../../config/themes/colors.dart';

class DialogWidget extends StatelessWidget {
  String? translatedText;
  bool isTranslated;

  DialogWidget(this.translatedText, {super.key, this.isTranslated = false});

  @override
  Widget build(BuildContext context) {
    var cubit = AppLayoutCubit.get(context);

    return BlocConsumer<AudioCubit, AudioState>(
      listener: (context, state) {},
      builder: (context, state) {
        return AlertDialog(
          backgroundColor: AppColor.offWhiteColor,
          title: Center(
              child: isTranslated
                  ? const Text('Translated  Text')
                  : const Text("Summary")),
          content: Form(
            key: key,
            child: SingleChildScrollView(
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(color: AppColor.primaryColor)),
                child: Padding(
                    padding: EdgeInsets.all(8.0.r),
                    child: Text(
                      translatedText ?? 'No Text',
                      style: const TextStyle(color: AppColor.blackColor),
                    )),
              ),
            ),
          ),
          actions: [
            CustomButton(
                widget: Text(
                  'Copy Text',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(color: AppColor.primaryColor, fontSize: 18.sp),
                ),
                height: 50.h,
                width: double.infinity,
                onTap: () async {
                  await Clipboard.setData(ClipboardData(text: translatedText!));
                  context.showAwesomeSnackbar(
                      message: 'Copied To Clipboard',
                      title: '',
                      contentType: ContentType.success);
                  Navigator.pop(context);
                })
          ],
        );
      },
    );
  }
}
