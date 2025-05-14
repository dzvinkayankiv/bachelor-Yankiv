import 'package:dwixy/consts/colors.dart';
import 'package:dwixy/consts/monserat_styles.dart';
import 'package:flutter/material.dart';

class DropDownPeriodicWidget extends StatefulWidget {
  final bool isEnabled;
  final TextEditingController controller;
  const DropDownPeriodicWidget({
    super.key,
    required this.isEnabled,
    required this.controller,
  });

  @override
  State<DropDownPeriodicWidget> createState() => _DropDownPeriodicWidgetState();
}

class _DropDownPeriodicWidgetState extends State<DropDownPeriodicWidget> {
  static const List<String> _listPeriodOfUse = <String>[
    'Ранок',
    'Вечір',
    'Обід',
    'Ранок/Вечір',
  ];

  @override
  Widget build(BuildContext context) {
    return DropdownMenu<String>(
      width: double.infinity,
      label: Text('Частота використання', style: MonseratStyles.montserrat14W500Grey80.copyWith(height: 3),),
      enabled: widget.isEnabled,
      trailingIcon: SizedBox.shrink(),
      textStyle: widget.isEnabled ? MonseratStyles.montserrat14W400Black : MonseratStyles.montserrat14W400Grey80,
      inputDecorationTheme: InputDecorationTheme(
        isDense: true,
        contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        focusedErrorBorder: InputBorder.none,
        disabledBorder: InputBorder.none,
      ),
      menuStyle: MenuStyle(
        backgroundColor: WidgetStateProperty.all(AppColors.pinkLight),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        elevation: WidgetStateProperty.all(0),
      ),
      initialSelection: widget.controller.text,
      onSelected: (String? value) {
        setState(() {
          widget.controller.text = value!;
        });
      },
      dropdownMenuEntries: _listPeriodOfUse
          .map(
            (value) => DropdownMenuEntry<String>(value: value, label: value),
      )
          .toList(),
    );
  }
}