import 'package:dwixy/consts/colors.dart';
import 'package:dwixy/consts/monserat_styles.dart';
import 'package:dwixy/consts/texts.dart';
import 'package:dwixy/pages/welcome_page.dart';
import 'package:dwixy/reusable%20widgets/black_button.dart';
import 'package:flutter/material.dart';

class ConfirmEmailPage extends StatelessWidget {
  const ConfirmEmailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pinkLight,
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 64, 8, 8),
              child: Text(
                AppTexts.welocomeToDwixy,
                style: MonseratStyles.montserrat22W600Black,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 32),
              child: Text(
                "Нам важливо щоб ви підвердили свою пошту",
                style: MonseratStyles.montserrat16W400Black,
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: BlackButton(
                buttonText: "Надіслати запит підтвердження пошти",
                widthMultiplier: 1,
                buttonColor: AppColors.black,
                buttonFunction: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => WelcomePage(),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: BlackButton(
                buttonText: "Вийти з аккаунта",
                widthMultiplier: 1,
                buttonColor: AppColors.black,
                buttonFunction: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => WelcomePage(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
