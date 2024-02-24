import 'package:flutter/material.dart';
import 'package:sum_cap/config/themes/colors.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: AppColor.whiteColor,
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      selectedItemColor: AppColor.primaryColor,
      unselectedItemColor: AppColor.primaryColor.withOpacity(.5),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColor.primaryColor,
      shape: StadiumBorder(),
      iconSize: 28,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColor.whiteColor,
      iconTheme: IconThemeData(color: AppColor.primaryColor),
      centerTitle: true,
    ),
    textTheme: const TextTheme(
      titleLarge: TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: 36,
        color: AppColor.blackColor,
      ),
      titleMedium: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 20,
        color: AppColor.whiteColor,
      ),
      titleSmall: TextStyle(
        fontWeight: FontWeight.w400,
        fontSize: 18,
        color: AppColor.blackColor,
      ),
      labelMedium: TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 18,
        color: AppColor.greyColor,
      ),
      labelSmall: TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 16,
        color: AppColor.greyColor,
      ),
    ),
  );
}
