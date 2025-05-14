import 'package:flutter/material.dart';

import '../consts/monserat_styles.dart';

class BlackButton extends StatelessWidget {
  final String buttonText;
  final double widthMultiplier;
  final VoidCallback buttonFunction;
  final Color buttonColor;
  const BlackButton({
    super.key,
    required this.buttonText,
    required this.widthMultiplier,
    required this.buttonFunction,
    required this.buttonColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * widthMultiplier,
      height: MediaQuery.of(context).size.height * 0.05,
      child: ElevatedButton(
        onPressed: buttonFunction,
        style: ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(buttonColor),
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
        child: Text(buttonText, style: MonseratStyles.montserrat14W500White),
      ),
    );
  }
}
