import 'package:dwixy/consts/roboto_styles.dart';
import 'package:flutter/material.dart';

class TextInputInvisibleWidget extends StatelessWidget {
  final bool isEnabled;
  final double multiple;
  final TextEditingController controller;
  final TextStyle style;

  const TextInputInvisibleWidget({
    super.key,
    required this.multiple,
    required this.controller,
    required this.isEnabled,
    required this.style,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * multiple,
      child: TextFormField(
        controller: controller,
        style: style,
        decoration: InputDecoration(
          enabled: isEnabled,
          isDense: true,
          contentPadding: EdgeInsets.zero,
          labelStyle: RobotoStyles.roboto14W400White,
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
      ),
    );
  }
}
