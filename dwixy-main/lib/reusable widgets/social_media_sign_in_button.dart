import 'package:flutter/material.dart';

import '../consts/monserat_styles.dart';

class SocialMediaSignInButton extends StatelessWidget {
  final String buttonText;
  final double widthMultiplier;
  final String icon;
  final VoidCallback voidCallback;

  const SocialMediaSignInButton({
    super.key,
    required this.buttonText,
    required this.widthMultiplier,
    required this.icon,
    required this.voidCallback,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * widthMultiplier,
      height: MediaQuery.of(context).size.height * 0.05,
      child: OutlinedButton.icon(
        icon: Image.asset(icon),
        onPressed: voidCallback,
        style: ButtonStyle(
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
        label: Text(buttonText, style: MonseratStyles.montserrat14W400Black),
      ),
    );
  }
}
