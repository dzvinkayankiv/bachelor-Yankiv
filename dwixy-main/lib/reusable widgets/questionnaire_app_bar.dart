import 'package:dwixy/consts/colors.dart';
import 'package:dwixy/consts/monserat_styles.dart';
import 'package:flutter/material.dart';


class QuestionnaireAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final String title;
  final VoidCallback function;

  const QuestionnaireAppBar({
    super.key,
    required this.title,
    required this.function,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.pinkLight,
      elevation: 0,
      leading: IconButton(
        onPressed: function,
        icon: Icon(Icons.close, size: 24, color: Colors.black),
      ),
      title: Align(
        alignment: Alignment.center,
        child: Text(
          title,
          style: MonseratStyles.montserrat22W700Black,
          softWrap: true,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      titleSpacing: 0,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56);
}
