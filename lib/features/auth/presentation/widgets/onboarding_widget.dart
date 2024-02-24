import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sum_cap/config/routes/app_routes.dart';
import 'package:sum_cap/config/themes/colors.dart';
import 'package:sum_cap/core/utils/extensions/sized_box_extensions.dart';
import 'package:sum_cap/features/auth/presentation/pages/onboarding.dart';

class OnBoardingItem extends StatelessWidget {
  String imagePath;
  String title;
  String subTitle;

  OnBoardingItem({
    super.key,
    required this.imagePath,
    required this.title,
    required this.subTitle,
  });
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              CupertinoButton(
                child: const Text(
                  "Skip",
                  style: TextStyle(color: AppColor.primaryColor),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, Routes.login);
                },
              )
            ],
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(image: AssetImage(imagePath)),
            (30.h).sizedBoxHeight,
            Padding(
              padding: EdgeInsets.all(15.w),
              child: Column(
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 25.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  (15.h).sizedBoxHeight,
                  Text(
                    subTitle,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
