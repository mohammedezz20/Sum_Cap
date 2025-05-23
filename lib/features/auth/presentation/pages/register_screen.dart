import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sum_cap/config/themes/colors.dart';
import 'package:sum_cap/core/shared_pref_helper.dart';
import 'package:sum_cap/core/utils/extensions/build_context_extensions.dart';
import 'package:sum_cap/core/widgets/custom_form_field.dart';
import 'package:sum_cap/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:sum_cap/features/auth/presentation/pages/login_screen.dart';

import '../../../app_layout/presentation/pages/app_layout.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

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
                  padding: const EdgeInsets.all(19),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: context.w(15)),
                          child: Text(
                            '''Create an \naccount''',
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
                            controller: cubit.usernameController,
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
                            controller: cubit.emailController,
                            labelText: 'Email',
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
                            onChang: (val) {
                              cubit.checkPasswordStrength(val ?? '');
                            },
                            onTapOutside: (p0) {},
                            labelText: 'Password',
                            suffix: IconButton(
                              onPressed: cubit.changePasswordIcon,
                              icon: cubit.isPassword
                                  ? const Icon(
                                      Icons.visibility_outlined,
                                    )
                                  : const Icon(
                                      Icons.visibility_off_outlined,
                                    ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: context.h(30),
                        ),
                        SizedBox(
                          width: double.infinity,
                          height: context.h(55),
                          child: CustomFormField(
                            controller: cubit.confirmPasswordController,
                            isPassword: cubit.isPassword,
                            onTapOutside: (p0) {},
                            onChang: (val) {
                              cubit.checkPasswordsMatchs(
                                  cubit.passwordController.text,
                                  cubit.confirmPasswordController.text);
                            },
                            labelText: 'ConfirmPassword',
                            onTap: () {},
                            suffix: IconButton(
                              onPressed: cubit.changePasswordIcon,
                              icon: cubit.isPassword
                                  ? const Icon(
                                      Icons.visibility_outlined,
                                    )
                                  : const Icon(
                                      Icons.visibility_off_outlined,
                                    ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: context.h(5),
                        ),
                        PasswordCriteria(
                          label: 'Passwords match',
                          isValid: cubit.isMatch,
                        ),
                        const SizedBox(height: 15),
                        PasswordCriteria(
                          label: '8-20 Characters',
                          isValid: cubit.hasMinLength,
                        ),
                        PasswordCriteria(
                          label: 'At least one capital letter',
                          isValid: cubit.hasUpperCase,
                        ),
                        PasswordCriteria(
                          label: 'At least one number',
                          isValid: cubit.hasNumber,
                        ),
                        PasswordCriteria(
                          label: 'No spaces',
                          isValid: cubit.hasNoSpaces,
                        ),
                        SizedBox(
                          height: context.h(15),
                        ),
                        Text(
                          'By clicking the Register button, you agree \nto the public offer',
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                        SizedBox(
                          height: context.h(50),
                        ),
                        (state is AuthRegisterLoadingState)
                            ? const Center(
                                child: CircularProgressIndicator(
                                  color: AppColor.primaryColor,
                                ),
                              )
                            : CupertinoButton(
                                padding: EdgeInsets.zero,
                                onPressed: () {
                                  if (cubit.usernameController.text.isEmpty ||
                                      cubit.emailController.text.isEmpty ||
                                      cubit.passwordController.text.isEmpty ||
                                      cubit.confirmPasswordController.text
                                          .isEmpty) {
                                    context.showAwesomeSnackbar(
                                        message: 'Please fill all fields',
                                        title: '',
                                        contentType: ContentType.failure);
                                  } else if (cubit.hasMinLength == false ||
                                      cubit.hasUpperCase == false ||
                                      cubit.hasNumber == false ||
                                      cubit.hasNoSpaces == false ||
                                      cubit.isMatch == false) {
                                    context.showAwesomeSnackbar(
                                        message:
                                            "please check password criteria",
                                        title: '',
                                        contentType: ContentType.failure);
                                  } else {
                                    cubit.register(
                                      userName: cubit.usernameController.text,
                                      email: cubit.emailController.text,
                                      password: cubit.passwordController.text,
                                      confirmPassword:
                                          cubit.confirmPasswordController.text,
                                    );
                                    if (state is AuthRegisterSuccessState) {
                                      cubit.confirmPasswordController.clear();
                                      cubit.usernameController.clear();
                                      cubit.emailController.clear();
                                      cubit.passwordController.clear();
                                      SharedPrefHelper.saveData(
                                          key: 'token',
                                          value: '${state.user.token}');
                                      SharedPrefHelper.saveData(
                                          key: 'username',
                                          value: state.user.username);
                                      SharedPrefHelper.saveData(
                                          key: 'email',
                                          value: state.user.email);
                                      SharedPrefHelper.saveData(
                                          key: 'password',
                                          value: state.user.password);
                                    }
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
                                    'Register',
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  ),
                                ),
                              ),
                        SizedBox(
                          height: context.h(15),
                        ),
                        Row(
                          children: [
                            Text(
                              'I already have an Account ',
                              style: Theme.of(context).textTheme.labelMedium,
                              textAlign: TextAlign.end,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => const LoginScreen()));
                              },
                              child: Text(
                                ' Login',
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
          ),
        );
      },
      listener: (BuildContext context, AuthState state) {
        if (state is AuthRegisterErrorState) {
          context.showAwesomeSnackbar(
              message: state.message,
              title: '',
              contentType: ContentType.failure);
        }
        if (state is AuthRegisterSuccessState) {
          context.showAwesomeSnackbar(
              message: 'Welcome ${state.user.username}',
              title: 'Account Created Successfly',
              contentType: ContentType.success);
          context.jumpToWithReplacement(const AppLayout());
        }
      },
    );
  }

  Color getColorForStrength(double strengthValue) {
    if (strengthValue < 0.4) {
      return Colors.red;
    } else if (strengthValue < 0.7) {
      return Colors.yellow;
    } else {
      return Colors.green;
    }
  }
}

class PasswordCriteria extends StatelessWidget {
  final String label;
  final bool isValid;

  const PasswordCriteria(
      {super.key, required this.label, required this.isValid});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          isValid ? Icons.check_box : Icons.close,
          color: isValid ? Colors.green : Colors.red,
        ),
        const SizedBox(width: 10),
        Text(label),
      ],
    );
  }
}
