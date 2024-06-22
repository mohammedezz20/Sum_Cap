import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sum_cap/config/routes/app_routes.dart';
import 'package:sum_cap/config/themes/theme.dart';
import 'package:sum_cap/features/app_layout/presentation/cubit/app_layout_cubit.dart';
import 'package:sum_cap/features/app_layout/presentation/pages/app_layout.dart';
import 'package:sum_cap/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:sum_cap/features/auth/presentation/pages/login_screen.dart';
import 'package:sum_cap/features/live_transcript/presentation/cubit/live_transcript_cubit.dart';
import 'package:sum_cap/features/live_transcript/presentation/pages/live_transcript.dart';
import 'package:sum_cap/features/record_audio/presentation/cubit/audio_cubit.dart';
import 'package:sum_cap/features/record_audio/presentation/cubit/audio_record_cubit/audio_recoed_cubit.dart';
import 'package:sum_cap/features/record_audio/presentation/cubit/chatbot_cubit/chatbot_cubit.dart';
import 'package:sum_cap/features/user_profile/presentation/cubit/user_profile_cubit.dart';

class MainApp extends StatelessWidget {
  bool isLogin;
  MainApp({Key? key, required this.isLogin}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      splitScreenMode: true,
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => AuthCubit()),
          BlocProvider(create: (_) {
            return AppLayoutCubit()
              ..getdata()
              ..getAudios();
          }),
          BlocProvider(create: (_) => UserProfileCubit()),
          BlocProvider(create: (_) => AudioCubit()),
          BlocProvider(create: (_) => AudioRecoedCubit()),
          BlocProvider(create: (_) => ChatBotCubit()),
          BlocProvider(create: (_) => LiveTranscriptCubit()),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          onGenerateRoute: AppRoutes.onGenerateRoute,
          themeMode: ThemeMode.light,
          theme: AppTheme.lightTheme,
          home: isLogin ? const AppLayout() : const LoginScreen(),
        ),
      ),
    );
  }
}
