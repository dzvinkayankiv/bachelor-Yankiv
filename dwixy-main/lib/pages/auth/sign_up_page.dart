import 'package:dwixy/bloc/auth_bloc/auth_bloc.dart';
import 'package:dwixy/consts/colors.dart';
import 'package:dwixy/consts/monserat_styles.dart';
import 'package:dwixy/pages/auth/sign_up_password_page.dart';
import 'package:dwixy/reusable%20widgets/social_media_sign_in_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../consts/texts.dart';
import '../../reusable widgets/black_button.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController emailController = TextEditingController();
  bool isButtonActive = false;
  bool isPasswordPage = false;

  @override
  void initState() {
    super.initState();
    emailController.addListener(() {
      setState(() {
        isButtonActive =
            emailController.text.contains("@") &&
            emailController.text.contains('.');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 24, 8, 0),
          child: Text(
            AppTexts.enterEmail,
            style: MonseratStyles.montserrat18W600Black,
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(64, 16, 64, 32),
          child: Text(
            AppTexts.emailDescrition,
            style: MonseratStyles.montserrat14W400Black,
            textAlign: TextAlign.center,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            controller: emailController,
            decoration: InputDecoration(
              hintText: 'Email',
              hintStyle: MonseratStyles.montserrat14W400Grey50,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: AppColors.grey30, width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: AppColors.grey30, width: 1),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 64),
          child: BlackButton(
            buttonText: AppTexts.confirm,
            widthMultiplier: 1,
            buttonColor: isButtonActive ? AppColors.black : AppColors.grey50,
            buttonFunction: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder:
                      (BuildContext context) =>
                          SignUpPasswordPage(email: emailController.text),
                ),
              );
            },
          ),
        ),
        Row(
          children: [
            Expanded(
              child: Divider(
                color: AppColors.grey50,
                thickness: 1,
                indent: 20,
                endIndent: 10,
              ),
            ),
            Text(AppTexts.orWith, style: MonseratStyles.montserrat14W400Black),
            Expanded(
              child: Divider(
                color: AppColors.grey50,
                thickness: 1,
                indent: 10,
                endIndent: 20,
              ),
            ),
          ],
        ),
        BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
          if(state is AuthLoading) {
            return CircularProgressIndicator();
          } return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 32, 8, 0),
                child: SocialMediaSignInButton(
                  buttonText: AppTexts.continueWithGoogle,
                  widthMultiplier: 0.8,
                  icon: 'assets/icons/logo-google.png',
                  voidCallback: () {
                    context.read<AuthBloc>().add(LoginViaGoogle());
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SocialMediaSignInButton(
                  buttonText: AppTexts.continueWithFacebook,
                  widthMultiplier: 0.8,
                  icon: 'assets/icons/logo-facebook.png',
                  voidCallback: () {
                    context.read<AuthBloc>().add(LoginViaFacebook());
                  },
                ),
              ),
            ],
          );
        }),
      ],
    );
  }
}
