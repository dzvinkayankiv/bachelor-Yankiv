import 'package:dwixy/consts/monserat_styles.dart';
import 'package:flutter/cupertino.dart';

class GenderSelectButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final Color backgroundColor;
  final Color iconColor;
  final VoidCallback buttonFunction;
  final Color textColor;

  const GenderSelectButton({
    super.key,
    required this.text,
    required this.icon,
    required this.backgroundColor,
    required this.buttonFunction,
    required this.iconColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: buttonFunction,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.4,
        height: MediaQuery.of(context).size.height * 0.04,
        decoration: BoxDecoration(
          color: backgroundColor,
          border: Border.all(),
          borderRadius: BorderRadius.all(Radius.circular(14)),
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            Text(
              text,
              style: MonseratStyles.montserrat14W600CustomColor(textColor),
            ),
          ],
        ),
      ),
    );
  }
}
