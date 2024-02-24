import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sum_cap/features/app_layout/presentation/cubit/app_layout_cubit.dart';
import 'package:sum_cap/features/app_layout/presentation/cubit/app_layout_states.dart';
import 'package:sum_cap/features/app_layout/presentation/pages/add_bottom_sheet.dart';
import 'package:sum_cap/config/themes/colors.dart';
import 'package:sum_cap/core/utils/extensions/build_context_extensions.dart';

class AppLayout extends StatelessWidget {
  const AppLayout({super.key});

  @override
  Widget build(BuildContext context) {
    var cubit = AppLayoutCubit.get(context);
    return BlocBuilder<AppLayoutCubit, AppLayoutStates>(
      builder: (context, state) => Container(
        color: AppColor.offWhiteColor,
        child: Padding(
          padding: context.safeAreaPadding,
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
    );
  }
}
