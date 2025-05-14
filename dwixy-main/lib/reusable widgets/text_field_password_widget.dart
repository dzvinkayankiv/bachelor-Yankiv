import 'package:dwixy/consts/colors.dart';
import 'package:dwixy/consts/monserat_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TextFieldPasswordWidget extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;

  const TextFieldPasswordWidget({
    super.key,
    required this.controller,
    required this.hintText,
  });

  @override
  State<TextFieldPasswordWidget> createState() =>
      _TextFieldPasswordWidgetState();
}

class _TextFieldPasswordWidgetState extends State<TextFieldPasswordWidget> {
  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      style: MonseratStyles.montserrat14W400Black,
      obscureText: _isObscure,
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: MonseratStyles.montserrat14W400Grey50,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.grey30, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.grey30, width: 1),
        ),
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              _isObscure = !_isObscure;
            });
          },
          icon: SvgPicture.asset(
            'assets/icons/eye.svg',
            colorFilter: ColorFilter.mode(AppColors.grey50, BlendMode.srcIn),
          ),
        ),
      ),
    );
  }
}
