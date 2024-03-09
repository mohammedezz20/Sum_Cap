import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sum_cap/config/themes/colors.dart';
import 'package:sum_cap/core/utils/extensions/build_context_extensions.dart';

class MediaPlayerButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final IconData iconData;
  final Color buttonColor;
  final Color iconColor;
  final double buttonSize;
  final double iconSize;
  bool isForward = false;

  MediaPlayerButton({
    Key? key,
    required this.onPressed,
    required this.iconData,
    this.buttonColor = AppColor.primaryColor,
    this.iconColor = AppColor.whiteColor,
    this.buttonSize = 50,
    this.iconSize = 30,
    this.isForward = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      onPressed: onPressed,
      child: Stack(
        alignment: Alignment.center,
        children: [
          (isForward)
              ? Icon(
                  iconData,
                  color: iconColor,
                  size: context.w(iconSize),
                )
              : Container(
                  alignment: Alignment.center,
                  height: context.h(buttonSize),
                  width: context.h(buttonSize),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: buttonColor,
                  ),
                  child: Icon(
                    iconData,
                    color: iconColor,
                    size: context.w(iconSize),
                  ),
                ),
          if (isForward) ...[
            const Text("5", style: TextStyle(color: AppColor.primaryColor))
          ]
        ],
      ),
    );
  }
}
