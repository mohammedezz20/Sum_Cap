import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sum_cap/config/themes/colors.dart';
import 'package:sum_cap/core/utils/extensions/build_context_extensions.dart';
import 'package:sum_cap/core/utils/extensions/sized_box_extensions.dart';
import 'package:sum_cap/core/widgets/custom_button.dart';
import 'package:sum_cap/core/widgets/custom_form_field.dart';
import 'package:sum_cap/features/auth/presentation/pages/login_screen.dart';

import '../cubit/user_profile_cubit.dart';

class UserScreen extends StatelessWidget {
  const UserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var cubit = UserProfileCubit.get(context);
    return BlocBuilder<UserProfileCubit, UserProfileState>(
      builder: (BuildContext context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.w),
              child: Text(
                'Profile Data',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(color: AppColor.blackColor, fontSize: 18.sp),
              ),
            ),
            CustomFormField(
              controller: cubit.nameController,
              labelText: 'Name',
              backgroundColor: AppColor.offWhiteColor,
            ),
            20.h.sizedBoxHeight,
            CustomFormField(
              controller: cubit.emailController,
              labelText: 'Username or Email',
              backgroundColor: AppColor.offWhiteColor,
            ),
            20.h.sizedBoxHeight,
            CustomButton(
              widget: Text(
                'Save Changes',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(color: AppColor.primaryColor, fontSize: 18.sp),
              ),
              height: 45.h,
              width: double.infinity,
              onTap: () {},
            ),
            20.h.sizedBoxHeight,
            CustomButton(
              widget: Text(
                'Change Password',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(color: AppColor.primaryColor, fontSize: 18.sp),
              ),
              height: 45.h,
              width: double.infinity,
              onTap: () {},
            ),
            20.h.sizedBoxHeight,
            CustomButton(
                widget: Text(
                  'Delete Account',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(color: AppColor.redColor, fontSize: 18.sp),
                ),
                height: 45.h,
                width: double.infinity,
                colorBorder: AppColor.redColor,
                onTap: () {}),
            20.h.sizedBoxHeight,
            CustomButton(
              widget: Text(
                'LogOut',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(color: AppColor.redColor, fontSize: 18.sp),
              ),
              height: 45.h,
              width: double.infinity,
              colorBorder: AppColor.redColor,
              onTap: () {
                context.jumpToAndRemove(const LoginScreen());
              },
            ),
          ],
        );
      },
    );
  }
}
