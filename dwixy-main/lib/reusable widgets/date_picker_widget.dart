import 'package:dwixy/consts/colors.dart';
import 'package:dwixy/consts/monserat_styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DatePickerWidget extends StatelessWidget {
  final VoidCallback function;
  final TextEditingController textController;
  final String hintText;
  final bool showSufixIcon;

  const DatePickerWidget({
    super.key,
    required this.function,
    required this.textController,
    required this.hintText,
    required this.showSufixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: textController,
      style: MonseratStyles.montserrat14W400Black,
      readOnly: true,
      onTap: function,
      decoration: InputDecoration(
        suffixIcon:
            showSufixIcon == true
                ? Icon(CupertinoIcons.calendar, color: AppColors.grey50)
                : null,
        hintText: hintText,
        hintStyle: MonseratStyles.montserrat14W400Grey50,
        labelStyle: MonseratStyles.montserrat14W400Black,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.grey30),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.grey30),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.grey30),
        ),
      ),
    );
  }
}
