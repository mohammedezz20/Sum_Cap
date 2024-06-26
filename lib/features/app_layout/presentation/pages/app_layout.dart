import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sum_cap/features/app_layout/presentation/cubit/app_layout_cubit.dart';
import 'package:sum_cap/features/app_layout/presentation/cubit/app_layout_states.dart';
import 'package:sum_cap/features/app_layout/presentation/pages/add_bottom_sheet.dart';
import 'package:sum_cap/config/themes/colors.dart';
import 'package:sum_cap/core/utils/extensions/build_context_extensions.dart';
import 'package:sum_cap/features/app_layout/presentation/widgets/dialog_widget.dart';

class AppLayout extends StatefulWidget {
  const AppLayout({super.key});

  @override
  State<AppLayout> createState() => _AppLayoutState();
}

class _AppLayoutState extends State<AppLayout> {
  static const platform = MethodChannel("com.example.sum_cap/intent");

  @override
  void initState() {
    super.initState();
    platform.setMethodCallHandler((call) async {
      if (call.method == 'receiveAudio') {
        log(call.arguments);
        final String audioPath = call.arguments;
        _handleSharedAudio(audioPath);
      }
    });
  }

  void _handleSharedAudio(String audioPath) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
        context: context,
        builder: (context) => CustomDialogWidget(audioPath: audioPath),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    var cubit = AppLayoutCubit.get(context);
    return BlocBuilder<AppLayoutCubit, AppLayoutStates>(
      builder: (context, state) => Container(
        color: AppColor.offWhiteColor,
        child: Padding(
          padding: context.safeAreaPadding,
          child: PopScope(
            canPop: false,
            onPopInvoked: (didPop) {
              log("$didPop");

              if (state is UploadAudioLoadingState ||
                  state is TranscriptionLoadingState) {
                _showExitDialog(context, isUploading: true);
              } else {
                _showExitDialog(context);
              }
            },
            child: Scaffold(
              bottomNavigationBar: BottomNavigationBar(
                onTap: (index) => cubit.changeNavBar(index),
                items: [
                  BottomNavigationBarItem(
                      icon: Icon(
                        Icons.home,
                        size: 28.w,
                      ),
                      label: 'Home'),
                  BottomNavigationBarItem(
                      icon: Icon(
                        Icons.person_outline_rounded,
                        size: 28.w,
                      ),
                      label: 'User'),
                ],
                currentIndex: cubit.selectedIndex,
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) => const AddBottomSheet(),
                  );
                },
                child: const Icon(
                  FontAwesomeIcons.plus,
                  color: AppColor.whiteColor,
                  size: 30,
                ),
              ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerDocked,
              backgroundColor: AppColor.offWhiteColor,
              body: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10),
                  child: cubit.screens[cubit.selectedIndex]),
            ),
          ),
        ),
      ),
    );
  }
}

Future<void> _showExitDialog(BuildContext context,
    {bool isUploading = false}) async {
  return showDialog(
    context: context,
    barrierDismissible: false, // user must tap button to dismiss
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Exit App'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              (isUploading)
                  ? const Text('SomeFile is uploading please wait ...')
                  : const Text('Do you really want to exit the app?'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text('Exit'),
            onPressed: () {
              SystemNavigator.pop(animated: true);
            },
          ),
        ],
      );
    },
  );
}
