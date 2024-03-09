import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sum_cap/config/themes/colors.dart';
import 'package:sum_cap/core/cach_helper.dart';
import 'package:sum_cap/core/utils/extensions/build_context_extensions.dart';
import 'package:sum_cap/core/utils/extensions/sized_box_extensions.dart';
import 'package:sum_cap/core/widgets/custom_button.dart';
import 'package:sum_cap/core/widgets/custom_form_field.dart';
import 'package:sum_cap/core/widgets/dialog_utils.dart';
import 'package:sum_cap/features/auth/presentation/pages/login_screen.dart';
import 'package:sum_cap/features/auth/presentation/pages/reset_password_screen.dart';

import '../cubit/user_profile_cubit.dart';

class UserScreen extends StatelessWidget {
  const UserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var cubit = UserProfileCubit.get(context);
    return BlocConsumer<UserProfileCubit, UserProfileState>(
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
              controller: cubit.usernameController,
              labelText: 'Username',
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
              onTap: () {
                cubit.editUser(CachHelper.getData(key: 'token'),
                    cubit.usernameController.text);
              },
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
              onTap: () {
                context.jumpToAndRemove(
                  ResetPasswordScreen(
                    accessToken: CachHelper.getData(key: 'token'),
                    oldPassword: CachHelper.getData(key: 'password'),
                  ),
                );
              },
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
                onTap: () {
                  cubit.deleteUser(CachHelper.getData(key: 'token'));
                  if (state is UserDeleteUserSuccessState) {
                    context.jumpToAndRemove(const LoginScreen());
                  }
                }),
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
                cubit.logout();
                context.jumpToAndRemove(const LoginScreen());
              },
            ),
          ],
        );
      },
      listener: (BuildContext context, UserProfileState state) {
        if (state is UserLoadingState) {
          DialogUtils.showLoading(context);
        } else if (state is UserDeleteUserSuccessState) {
          DialogUtils.hideLoading(context);
          context.showAwesomeSnackbar(
              message: state.message,
              title: '',
              contentType: ContentType.success);
        } else if (state is UserEditUserFailureState) {
          DialogUtils.hideLoading(context);
          context.showAwesomeSnackbar(
              message: state.message,
              title: '',
              contentType: ContentType.failure);
        } else if (state is UserDeleteUserSuccessState) {
          DialogUtils.hideLoading(context);
          context.showAwesomeSnackbar(
              message: state.message,
              title: '',
              contentType: ContentType.success);
        } else if (state is UserDeleteUserFailureState) {
          DialogUtils.hideLoading(context);
          context.showAwesomeSnackbar(
              message: state.message,
              title: '',
              contentType: ContentType.failure);
        } else if (state is UserLogoutState) {
          DialogUtils.hideLoading(context);
          context.showAwesomeSnackbar(
              message: 'Goodbye 👋👋',
              title: '',
              contentType: ContentType.success);
        }
      },
    );
  }
}
