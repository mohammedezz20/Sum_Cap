import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sum_cap/config/themes/colors.dart';
import 'package:sum_cap/core/utils/enums.dart';
import 'package:sum_cap/core/utils/extensions/build_context_extensions.dart';
import 'package:sum_cap/core/widgets/custom_form_field.dart';
import 'package:sum_cap/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:sum_cap/features/auth/presentation/pages/forget_password_screen.dart';
import 'package:sum_cap/features/auth/presentation/pages/register_screen.dart';

import '../../../app_layout/presentation/pages/app_layout.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var cubit = AuthCubit.get(context);
    return BlocConsumer<AuthCubit, AuthState>(
      builder: (context, state) {
        return Container(
          color: const Color(0xffF3F8F4),
          child: Padding(
            padding: context.safeAreaPadding,
            child: Scaffold(
              backgroundColor: const Color(0xffF3F8F4),
              body: Padding(
                padding: const EdgeInsets.all(19),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: context.w(15)),
                        child: Text(
                          '''Welcome \nBack!''',
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
                          labelText: 'Username',
                        ),
                      ),
                      SizedBox(
                        height: context.h(30),
                      ),
                      SizedBox(
                        width: double.infinity,
                        height: context.h(55),
                        child: CustomFormField(
                          controller: cubit.passwordController,
                          isPassword: cubit.isPassword,
                          keyboardType: TextInputType.number,
                          labelText: 'Password',
                          suffix: IconButton(
                            onPressed: cubit.changePasswordIcon,
                            icon: (cubit.isPassword)
                                ? const Icon(Icons.visibility_outlined)
                                : const Icon(Icons.visibility_off_outlined),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => ForgetPasswordScreen(
                                        sendCode: SendCode.before,
                                      )));
                        },
                        child: Text(
                          'Forget password?',
                          style: Theme.of(context).textTheme.labelMedium,
                          textAlign: TextAlign.end,
                        ),
                      ),
                      SizedBox(
                        height: context.h(50),
                      ),
                      (state is AuthLoginLoadingState)
                          ? const Center(
                              child: CircularProgressIndicator(
                              color: AppColor.primaryColor,
                            ))
                          : CupertinoButton(
                              padding: EdgeInsets.zero,
                              onPressed: () {
                                if (cubit.emailController.text.isNotEmpty &&
                                    cubit.passwordController.text.isNotEmpty) {
                                  AuthCubit.get(context).login(
                                    email: cubit.emailController.text,
                                    password: cubit.passwordController.text,
                                  );
                                  if (state is AuthLoginSuccessState) {
                                    cubit.emailController.clear();
                                    cubit.passwordController.clear();
                                  }
                                } else {
                                  context.showAwesomeSnackbar(
                                      message: 'Please fill all field',
                                      title: '',
                                      contentType: ContentType.failure);
                                }
                              },
                              child: Container(
                                alignment: Alignment.center,
                                width: double.infinity,
                                height: 55.h,
                                decoration: BoxDecoration(
                                  color: AppColor.primaryColor,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  'Login',
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                              ),
                            ),
                      SizedBox(
                        height: 15.h,
                      ),
                      Row(
                        children: [
                          Text(
                            'Create an account ',
                            style: Theme.of(context).textTheme.labelMedium,
                            textAlign: TextAlign.end,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => const RegisterScreen()));
                            },
                            child: Text(
                              ' Sign up',
                              selectionColor: AppColor.primaryColor,
                              style: Theme.of(context)
                                  .textTheme
                                  .labelMedium!
                                  .copyWith(color: AppColor.primaryColor),
                              textAlign: TextAlign.end,
                            ),
                          ),
                        ],
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
        if (state is AuthLoginErrorState) {
          context.showAwesomeSnackbar(
              message: state.message,
              title: '',
              contentType: ContentType.failure);
        }
        if (state is AuthLoginSuccessState) {
          context.showAwesomeSnackbar(
              message: 'Welcome ${state.user.username}',
              title: 'Login Success',
              contentType: ContentType.success);
          context.jumpToWithReplacement(const AppLayout());
        }
      },
    );
  }
}
