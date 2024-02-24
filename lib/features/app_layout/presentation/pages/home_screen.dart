import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sum_cap/config/themes/colors.dart';
import 'package:sum_cap/core/utils/extensions/sized_box_extensions.dart';
import 'package:sum_cap/core/widgets/custom_button.dart';
import 'package:sum_cap/features/app_layout/presentation/cubit/app_layout_cubit.dart';
import 'package:sum_cap/features/app_layout/presentation/cubit/app_layout_states.dart';
import 'package:sum_cap/features/app_layout/presentation/widgets/file_shimmer_widget.dart';
import 'package:sum_cap/features/app_layout/presentation/widgets/file_widget.dart';

import '../../../../core/cach_helper.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var cubit = AppLayoutCubit.get(context);
    return BlocConsumer<AppLayoutCubit, AppLayoutStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.w),
              child: Text(
                cubit.isMorning
                    ? 'Good Morning 👋  \n${CachHelper.getData(key: 'username')}'
                    : 'Good Afternoon 👋 \n${CachHelper.getData(key: 'username')}',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(fontSize: 18.sp),
              ),
            ),
            GestureDetector(
              onTap: () {},
              child: Container(
                padding: EdgeInsets.only(left: 20.w),
                width: double.infinity,
                height: 45.h,
                decoration: BoxDecoration(
                  color: const Color(0xffDFF0E3),
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.centerLeft,
                child: Text(
                  'All Files',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(fontSize: 16.sp, color: AppColor.blackColor),
                ),
              ),
            ),
            (state is AppLayoutGetUserAudioLoadingState)
                ? Expanded(
                    child: ListView.separated(
                    itemBuilder: (context, index) => const ShimerFileWidget(),
                    separatorBuilder: (context, index) => 20.h.sizedBoxHeight,
                    itemCount: 10,
                  ))
                : (state is AppLayoutGetUserAudioSuccessState &&
                        cubit.audios.isNotEmpty)
                    ? Expanded(
                        child: RefreshIndicator(
                          onRefresh: () => cubit.getAudios(),
                          child: ListView.separated(
                              itemBuilder: (context, index) =>
                                  FileWidget(audio: cubit.audios[index]),
                              separatorBuilder: (context, index) =>
                                  20.h.sizedBoxHeight,
                              itemCount: cubit.audios.length),
                        ),
                      )
                    : Expanded(
                        child: Center(
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "No Files Found",
                                  style: TextStyle(
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                20.h.sizedBoxHeight,
                                CustomButton(
                                    widget: Text("Reload",
                                        style: TextStyle(
                                            color: AppColor.primaryColor,
                                            fontSize: 16.sp)),
                                    height: 40.h,
                                    width: 300.w,
                                    onTap: () {
                                      cubit.getAudios();
                                    })
                              ]),
                        ),
                      ),
          ],
        );
      },
    );
  }
}
