import 'package:dwixy/consts/colors.dart';
import 'package:dwixy/pages/modals/add_new_cosmetic_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CircularAddButton extends StatelessWidget {
  const CircularAddButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.pink2,
        shape: BoxShape.circle,
      ),
      child: IconButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AddNewCosmeticModal();
            },
          );
        },
        icon: SvgPicture.asset(
          'assets/icons/plus.svg',
          colorFilter: ColorFilter.mode(
            AppColors.purpleDark,
            BlendMode.srcIn,
          ),
        ),
      ),
    );
  }
}
