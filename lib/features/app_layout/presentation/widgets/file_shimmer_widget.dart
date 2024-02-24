import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:sum_cap/config/themes/colors.dart';
import 'package:sum_cap/core/utils/extensions/sized_box_extensions.dart';
import 'package:sum_cap/features/app_layout/data/models/audio_model.dart';

class ShimerFileWidget extends StatefulWidget {
  const ShimerFileWidget({
    super.key,
  });

  @override
  State<ShimerFileWidget> createState() => _ShimerFileWidgetState();
}

class _ShimerFileWidgetState extends State<ShimerFileWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _shimmerController;

  @override
  void initState() {
    super.initState();
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(microseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _shimmerController,
        builder: (context, child) {
          return ShaderMask(
            blendMode: BlendMode.srcATop,
            shaderCallback: (bounds) {
              return LinearGradient(
                tileMode: TileMode.mirror,
                transform: const GradientRotation(pi / 10),
                colors: [
                  Colors.black45,
                  Colors.grey.shade300,
                  Colors.black45,
                ],
                stops: [
                  _shimmerController.value - 0.2,
                  _shimmerController.value,
                  _shimmerController.value + 0.2,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ).createShader(bounds);
            },
            child: child,
          );
        },
        child: Container(
            padding: EdgeInsets.all(15.w),
            decoration: BoxDecoration(
              color: AppColor.primaryColor.withOpacity(0.13),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              children: [
                const Icon(
                  FontAwesomeIcons.solidFile,
                  color: AppColor.whiteColor,
                  // color: AppColor.primaryColor,
                  size: 35,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            height: 15.h,
                            width: 110.w,
                            decoration: BoxDecoration(
                              color: AppColor.whiteColor,
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                          ),
                          15.w.sizedBoxWidth,
                          Container(
                            height: 15.h,
                            width: 80.w,
                            decoration: BoxDecoration(
                              color: AppColor.whiteColor,
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                          ),
                        ],
                      ),
                      10.h.sizedBoxHeight,
                      Container(
                        height: 15.h,
                        width: 150.w,
                        decoration: BoxDecoration(
                          color: AppColor.whiteColor,
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                      ),
                      10.h.sizedBoxHeight,
                      Row(
                        children: [
                          Container(
                            height: 15.h,
                            width: 80.w,
                            decoration: BoxDecoration(
                              color: AppColor.whiteColor,
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                          ),
                          40.w.sizedBoxWidth,
                          Container(
                            height: 15.h,
                            width: 80.w,
                            decoration: BoxDecoration(
                              color: AppColor.whiteColor,
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            )));
  }
}
