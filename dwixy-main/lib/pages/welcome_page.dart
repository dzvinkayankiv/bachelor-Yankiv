import 'package:dwixy/consts/texts.dart';
import 'package:dwixy/consts/monserat_styles.dart';
import 'package:dwixy/pages/auth/sign_in_sign_up_page.dart';
import 'package:dwixy/reusable%20widgets/black_button.dart';
import 'package:dwixy/reusable%20widgets/custom_progress_indicator.dart';
import 'package:flutter/material.dart';

import '../consts/colors.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: AppColors.pinkLight,
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CustomProgressIndicator(totalSteps: 2, currentStep: 2, widthMultiplier: 0.06,),
              SizedBox(height: 8.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    height: MediaQuery
                        .of(context)
                        .size
                        .height * 0.05,
                    width: MediaQuery
                        .of(context)
                        .size
                        .width * 0.4,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        side: const BorderSide(color: AppColors.black, width: 1),
                      ),
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) =>
                                SignInSignUpPage(isSignUpBaseValue: false,),
                          ),
                        );
                      },
                      child: Text(
                        AppTexts.signIn,
                        style: MonseratStyles.montserrat14W500Black,
                      ),
                    ),
                  ),
                  BlackButton(
                    buttonText: AppTexts.signUp,
                    widthMultiplier: 0.4,
                    buttonColor: AppColors.black,
                    buttonFunction: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) =>
                              SignInSignUpPage(isSignUpBaseValue: true,),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              Image.asset('assets/images/logo.png'),
              Padding(
                padding: const EdgeInsets.fromLTRB(64, 48, 64, 48),
                child: Text(
                  AppTexts.welcomeDesc,
                  style: MonseratStyles.montserrat22W600Black,
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 32, 8, 64),
                child: Image.asset('assets/images/body-acceptation.png'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
