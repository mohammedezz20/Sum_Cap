import 'package:flutter/material.dart';
import 'package:sum_cap/config/themes/colors.dart';

class DialogUtils {
  static showLoading(context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(
              color: AppColor.primaryColor,
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              'Loading...',
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ],
        ),
      ),
    );
  }

  static hideLoading(context) {
    Navigator.pop(context);
  }

  static showMessage(context, String? message, VoidCallback onPressed) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: Text(
                message!,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              actions: [
                TextButton(
                  onPressed: onPressed,
                  child: const Text('ok'),
                ),
              ],
            ));
  }
}
