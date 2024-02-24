import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sum_cap/config/themes/colors.dart';

class CustomButton extends StatelessWidget {
  Widget widget;
  Color colorBorder;
  double height;
  double width;
  void Function()? onTap;

  CustomButton({
    super.key,
    required this.widget,
    required this.height,
    required this.width,
    required this.onTap,
    this.colorBorder = AppColor.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: onTap,
      child: Container(
        alignment: Alignment.center,
        height: height,
        width: width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: colorBorder),
        ),
        child: widget,
      ),
    );
  }
}
