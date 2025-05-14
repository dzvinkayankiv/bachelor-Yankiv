import 'package:dwixy/consts/colors.dart';
import 'package:dwixy/consts/monserat_styles.dart';
import 'package:dwixy/consts/roboto_styles.dart';
import 'package:flutter/material.dart';

class TextFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;

  const TextFieldWidget({
    super.key,
    required this.controller,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      style: RobotoStyles.roboto14W400Black,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: MonseratStyles.montserrat14W400Grey50,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.grey30, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.grey30, width: 1),
        ),
      ),
    );
  }
}
