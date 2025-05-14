import 'package:dwixy/consts/colors.dart';
import 'package:dwixy/consts/roboto_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NotificationSettingWidget extends StatelessWidget {
  final String text;
  final bool value;
  final ValueChanged<bool> function;

  const NotificationSettingWidget({
    super.key,
    required this.text,
    required this.value,
    required this.function,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            SvgPicture.asset('assets/icons/bell.svg', width: 20, height: 20),
            SizedBox(width: 8),
            Text(text, style: RobotoStyles.roboto14W400Black),
          ],
        ),
        Switch(activeColor: AppColors.white, activeTrackColor: AppColors.pink ,value: value, onChanged: function),
      ],
    );
  }
}
