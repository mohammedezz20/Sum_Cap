import 'dart:async';
import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sum_cap/core/widgets/custom_button.dart';
import 'package:sum_cap/features/app_layout/presentation/cubit/app_layout_cubit.dart';
import 'package:sum_cap/features/app_layout/presentation/cubit/app_layout_states.dart';
import 'package:sum_cap/features/app_layout/presentation/pages/add_bottom_sheet.dart';
import 'package:sum_cap/config/themes/colors.dart';
import 'package:sum_cap/core/utils/extensions/build_context_extensions.dart';
import 'package:sum_cap/features/app_layout/presentation/widgets/dialog_widget.dart';
import 'dart:developer' as developer;

class AppLayout extends StatefulWidget {
  const AppLayout({super.key});

  @override
  State<AppLayout> createState() => _AppLayoutState();
}

class _AppLayoutState extends State<AppLayout> {
  List<ConnectivityResult> _connectionStatus = [ConnectivityResult.none];
  ConnectivityResult lastConnectionState = ConnectivityResult.wifi;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    initConnectivity();

    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initConnectivity() async {
    late List<ConnectivityResult> result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      log('Couldn\'t check connectivity status');
      return;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(List<ConnectivityResult> result) async {
    setState(() {
      _connectionStatus = result;
    });
    if (_connectionStatus[0] == ConnectivityResult.none) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.r),
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.redAccent,
          content: const Text(
            'No Internet Connection',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
      lastConnectionState = _connectionStatus[0];
    }
    if (_connectionStatus[0] != ConnectivityResult.none &&
        lastConnectionState == ConnectivityResult.none) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.r),
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.green,
          action: SnackBarAction(
              label: "Reload Audio",
              textColor: Colors.white,
              onPressed: () {
                AppLayoutCubit.get(context).getAudios();
              }),
          content: const Text(
            'Connection Restored',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }
    lastConnectionState = _connectionStatus[0];
    log('Connectivity changed: $_connectionStatus');
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
        backgroundColor: AppColor.offWhiteColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.r),
        ),
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
        actionsAlignment: MainAxisAlignment.center,
        actions: <Widget>[
          CustomButton(
            widget: const Text(
              'Cancel',
              style: TextStyle(color: AppColor.primaryColor),
            ),
            colorBorder: AppColor.primaryColor,
            onTap: () {
              Navigator.of(context).pop();
            },
            height: 40.h,
            width: context.screenWidth * 0.2,
          ),
          CustomButton(
            widget: const Text(
              'Exit',
              style: TextStyle(color: AppColor.redColor),
            ),
            colorBorder: AppColor.redColor,
            onTap: () {
              SystemNavigator.pop(animated: true);
            },
            height: 40.h,
            width: context.screenWidth * 0.2,
          ),
        ],
      );
    },
  );
}
