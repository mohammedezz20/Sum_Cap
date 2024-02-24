import 'package:flutter/material.dart';
import 'package:sum_cap/core/utils/enums.dart';
import 'package:sum_cap/features/auth/presentation/pages/forget_password_screen.dart';

import '../../features/auth/presentation/pages/login_screen.dart';
import '../../features/auth/presentation/pages/register_screen.dart';

class Routes {
  static const String home = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String resetPassword = '/reset-password';
}

class AppRoutes {
  static Route? onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case Routes.home:
        return MaterialPageRoute(builder: (_) => Container());
      case Routes.login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case Routes.register:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
      case Routes.forgotPassword:
        return MaterialPageRoute(
            builder: (_) => ForgetPasswordScreen(
                  sendCode: SendCode.before,
                ));
    }
    return null;
  }
}
