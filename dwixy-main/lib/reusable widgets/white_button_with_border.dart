import 'package:dwixy/consts/colors.dart';
import 'package:dwixy/consts/monserat_styles.dart';
import 'package:flutter/material.dart';

class WhiteButtonWithBorder extends StatelessWidget {
  final VoidCallback function;
  final String buttonText;

  const WhiteButtonWithBorder({
    super.key,
    required this.function,
    required this.buttonText,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        side: const BorderSide(color: AppColors.black, width: 1),
      ),
      onPressed: function,
      child: Text(buttonText, style: MonseratStyles.montserrat14W500Black),
    );
  }
}
