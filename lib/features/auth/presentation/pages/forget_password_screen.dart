import 'dart:developer';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sum_cap/core/utils/extensions/build_context_extensions.dart';
import 'package:sum_cap/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:sum_cap/config/themes/colors.dart';
import 'package:sum_cap/core/widgets/custom_form_field.dart';
import 'package:sum_cap/features/auth/presentation/pages/reset_password_screen.dart';

import '../../../../core/utils/enums.dart';

class ForgetPasswordScreen extends StatelessWidget {
  SendCode sendCode;
  ForgetPasswordScreen({super.key, required this.sendCode});

  @override
  Widget build(BuildContext context) {
    var cubit = AuthCubit.get(context);
    return BlocConsumer<AuthCubit, AuthState>(
      builder: (context, state) {
        return PopScope(
          onPopInvoked: (_) {
            cubit.confirmPasswordController.clear();
            cubit.passwordController.clear();
            cubit.emailController.clear();
            cubit.usernameController.clear();
          },
          child: Container(
            color: const Color(0xffF3F8F4),
            child: Padding(
              padding: context.safeAreaPadding,
              child: Scaffold(
                backgroundColor: const Color(0xffF3F8F4),
                body: Padding(
                  padding: EdgeInsets.all(19.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: context.w(15)),
                        child: Text(
                          '''Forget \npassword?''',
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
                          controller: cubit.emailController,
                          labelText: 'Enter your email address',
                          prefix: const Icon(Icons.email),
                        ),
                      ),
                      SizedBox(
                        height: context.h(15),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '* ',
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium!
                                .copyWith(color: Colors.red),
                          ),
                          Text(
                            'We will send you a message to \nreset your password',
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: context.h(25),
                      ),
                      Visibility(
                        visible: (sendCode.name == SendCode.after.name)
                            ? true
                            : false,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: List.generate(6, (index) {
                            return SizedBox(
                              height: context.h(60),
                              width: context.screenWidth / 8,
                              child: TextFormField(
                                onChanged: (value) {
                                  List codetemp = cubit.code.split('');
                                  codetemp[index] = value;
                                  cubit.code = codetemp.join('');
                                  if (value.length == 1 && index != 5) {
                                    FocusScope.of(context).nextFocus();
                                  }
                                  log(cubit.code);
                                },
                                decoration: InputDecoration(
                                  labelStyle:
                                      Theme.of(context).textTheme.labelSmall,
                                  hintStyle:
                                      Theme.of(context).textTheme.labelSmall,
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(
                                        color: AppColor.primaryColor),
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
                                    .titleMedium
                                    ?.copyWith(color: Colors.black),
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(1)
                                ],
                              ),
                            );
                          }),
                        ),
                      ),
                      SizedBox(
                        height: context.h(25),
                      ),
                      (state is AuthForGetPasswordLoadingState ||
                              state is AuthVerifyCodeLoadingState)
                          ? const Center(
                              child: CircularProgressIndicator(
                                  color: AppColor.primaryColor),
                            )
                          : CupertinoButton(
                              padding: EdgeInsets.zero,
                              onPressed: () {
                                if (sendCode == SendCode.before) {
                                  cubit.forgetPassword(
                                      email: cubit.emailController.text);
                                } else {
                                  cubit.verifyCode(
                                      email: cubit.emailController.text,
                                      code: cubit.code);
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
                                  (sendCode.name == SendCode.before.name)
                                      ? 'Submit'
                                      : "Verify Code",
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
      listener: (BuildContext context, AuthState state) {
        if (state is AuthForGetPasswordSuccessState) {
          context.showAwesomeSnackbar(
              message: ' ${state.message}',
              title: '',
              contentType: ContentType.success);
          sendCode = SendCode.after;
        } else if (state is AuthForGetPasswordFailerState) {
          context.showAwesomeSnackbar(
              message: ' ${state.message}',
              title: '',
              contentType: ContentType.failure);
        } else if (state is AuthVerifyCodeSuccessState) {
          AuthCubit.get(context).code = '';
          AuthCubit.get(context).emailController.clear();
          context.jumpTo(ResetPasswordScreen(
            oldPassword: state.oldPassword,
            accessToken: state.token,
          ));
        } else if (state is AuthVerifyCodeFailerState) {
          context.showAwesomeSnackbar(
              message: ' ${state.message}',
              title: '',
              contentType: ContentType.failure);
        }
      },
    );
  }
}
