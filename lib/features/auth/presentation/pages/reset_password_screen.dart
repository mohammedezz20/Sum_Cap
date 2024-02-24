import 'dart:developer';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sum_cap/core/utils/extensions/build_context_extensions.dart';
import 'package:sum_cap/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:sum_cap/features/auth/presentation/pages/login_screen.dart';

import '../../../../config/themes/colors.dart';
import '../../../../core/widgets/custom_form_field.dart';

class ResetPasswordScreen extends StatelessWidget {
  final String accessToken;
  final String oldPassword;

  const ResetPasswordScreen(
      {super.key, required this.accessToken, required this.oldPassword});

  @override
  Widget build(BuildContext context) {
    final cubit = AuthCubit.get(context);
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthResetPasswordSuccessState) {
          context.showAwesomeSnackbar(
              message: 'Password reset successfully',
              title: '',
              contentType: ContentType.success);
          context.jumpToAndRemove(const LoginScreen());
          cubit.passwordController.clear();
          cubit.confirmPasswordController.clear();
        } else if (state is AuthResetPasswordFailerState) {
          context.showAwesomeSnackbar(
              message: state.message,
              title: '',
              contentType: ContentType.failure);
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: const Color(0xffF3F8F4),
          body: Padding(
            padding: EdgeInsets.only(
                top: context.safeAreaPadding.top + context.h(19.w),
                left: context.h(19.w),
                right: context.h(19.w),
                bottom: context.h(19.w)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: context.w(15)),
                  child: Text(
                    '''Reset \npassword?''',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                SizedBox(
                  height: context.h(20),
                ),
                SizedBox(
                  width: double.infinity,
                  height: context.h(55),
                  child: CustomFormField(
                    controller: cubit.passwordController,
                    onTapOutside: (_) {
                      FocusScope.of(context).unfocus();
                    },
                    labelText: 'New Password',
                    prefix: const Icon(Icons.password),
                    isPassword: cubit.isPassword,
                    suffix: IconButton(
                      onPressed: cubit.changePasswordIcon,
                      icon: (cubit.isPassword)
                          ? const Icon(Icons.visibility_outlined)
                          : const Icon(Icons.visibility_off_outlined),
                    ),
                  ),
                ),
                SizedBox(
                  height: context.h(15),
                ),
                SizedBox(
                  width: double.infinity,
                  height: context.h(55),
                  child: CustomFormField(
                    onTapOutside: (_) {
                      FocusScope.of(context).unfocus();
                    },
                    isPassword: cubit.isPassword,
                    controller: cubit.confirmPasswordController,
                    labelText: 'Confirm Password',
                    prefix: const Icon(Icons.password),
                    suffix: IconButton(
                      onPressed: cubit.changePasswordIcon,
                      icon: (cubit.isPassword)
                          ? const Icon(Icons.visibility_outlined)
                          : const Icon(Icons.visibility_off_outlined),
                    ),
                  ),
                ),
                SizedBox(
                  height: context.h(40),
                ),
                (state is AuthResetPasswordLoadingState)
                    ? const Center(
                        child: CircularProgressIndicator(
                            color: AppColor.primaryColor),
                      )
                    : CupertinoButton(
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          if (cubit.passwordController.text !=
                              cubit.confirmPasswordController.text) {
                            context.showAwesomeSnackbar(
                                message: 'Passwords do not match',
                                title: '',
                                contentType: ContentType.failure);
                          } else {
                            log(accessToken);
                            log(oldPassword);

                            cubit.resetPassword(
                                accessToken: accessToken,
                                oldPassword: oldPassword,
                                newPassword: cubit.passwordController.text);
                          }
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: double.infinity,
                          height: context.h(55),
                          decoration: BoxDecoration(
                            color: AppColor.primaryColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            "Reset Password",
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                      ),
              ],
            ),
          ),
        );
      },
    );
  }
}
