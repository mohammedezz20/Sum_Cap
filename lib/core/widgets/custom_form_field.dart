import 'package:flutter/material.dart';
import 'package:sum_cap/config/themes/colors.dart';

class CustomFormField extends StatelessWidget {
  var controller = TextEditingController();
  String hintText;
  String labelText;
  bool isPassword;
  TextInputType keyboardType;
  Widget? suffix;
  Widget? prefix;
  int? maxLines;
  String? Function(String?)? validator;
  Function(String?)? onChang;
  Function()? onTap;
  Function(PointerDownEvent)? onTapOutside;
  Color backgroundColor;

  FocusNode? foucusNode;

  CustomFormField({
    super.key,
    required this.controller,
    this.hintText = '',
    this.labelText = '',
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.suffix,
    this.prefix,
    this.foucusNode,
    this.maxLines = 1,
    this.validator,
    this.onChang,
    this.onTap,
    this.backgroundColor = AppColor.whiteColor,
    this.onTapOutside,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTapOutside: onTapOutside,
      validator: validator,
      maxLines: maxLines,
      onChanged: onChang,
      focusNode: foucusNode,
      controller: controller,
      onTap: onTap,
      obscureText: isPassword,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: Theme.of(context).textTheme.labelSmall,
        hintText: hintText,
        hintStyle: Theme.of(context).textTheme.labelSmall,
        fillColor: backgroundColor,
        filled: true,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColor.primaryColor),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColor.primaryColor, width: 2),
        ),
        suffixIcon: suffix,
        prefixIcon: prefix,
      ),
    );
  }
}
