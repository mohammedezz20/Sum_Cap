import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sum_cap/config/themes/colors.dart';
import 'package:sum_cap/core/utils/extensions/sized_box_extensions.dart';

import '../../../../core/widgets/custom_button.dart';

class OptionButton extends StatelessWidget {
  final String buttonText;
  final IconData icon;
  final VoidCallback onTap;
  double width;
  double height;
  OptionButton({
    Key? key,
    required this.buttonText,
    required this.icon,
    required this.onTap,
    required this.width,
    required this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      widget: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: AppColor.primaryColor,
            size: 18.w,
          ),
          5.w.sizedBoxWidth,
          Text(
            buttonText,
            style: Theme.of(context)
                .textTheme
                .titleSmall!
                .copyWith(color: AppColor.primaryColor, fontSize: 14.sp),
          ),
        ],
      ),
      height: height,
      width: width,
      onTap: onTap,
    );
  }
}
