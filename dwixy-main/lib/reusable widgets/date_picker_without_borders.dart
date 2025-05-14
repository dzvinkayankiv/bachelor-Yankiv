import 'package:dwixy/consts/colors.dart';
import 'package:dwixy/consts/monserat_styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DatePickerWithoutBordersWidget extends StatelessWidget {
  final VoidCallback function;
  final TextEditingController textController;
  final String hintText;
  final bool showSufixIcon;
  final TextStyle textStyle;

  const DatePickerWithoutBordersWidget({
    super.key,
    required this.function,
    required this.textController,
    required this.hintText,
    required this.showSufixIcon,
    required this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: textController,
      style: textStyle,
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
        isDense: true,
        contentPadding: EdgeInsets.zero,
        disabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent),
        ),
      ),
    );
  }
}
