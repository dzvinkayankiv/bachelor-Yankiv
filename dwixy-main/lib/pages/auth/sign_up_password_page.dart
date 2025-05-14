import 'package:dwixy/bloc/auth_bloc/auth_bloc.dart';
import 'package:dwixy/consts/colors.dart';
import 'package:dwixy/consts/monserat_styles.dart';
import 'package:dwixy/consts/texts.dart';
import 'package:dwixy/pages/auth/sign_in_sign_up_page.dart';
import 'package:dwixy/pages/home/nav_bar_page.dart';
import 'package:dwixy/reusable%20widgets/black_button.dart';
import 'package:dwixy/reusable%20widgets/text_field_password_widget.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpPasswordPage extends StatefulWidget {
  final String email;

  const SignUpPasswordPage({super.key, required this.email});

  @override
  State<SignUpPasswordPage> createState() => _SignUpPasswordPageState();
}

class _SignUpPasswordPageState extends State<SignUpPasswordPage> {
  bool? checkBoxValue = false;
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  bool isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    passwordController.addListener(buttonRequirements);
    confirmPasswordController.addListener(buttonRequirements);
  }

  void buttonRequirements() {
    setState(() {
      isButtonEnabled =
          passwordController.text.isNotEmpty &&
          confirmPasswordController.text.isNotEmpty &&
          checkBoxValue == true &&
          passwordController.text == confirmPasswordController.text;
    });
  }

  @override
  void dispose() {
    passwordController.removeListener(buttonRequirements);
    confirmPasswordController.removeListener(buttonRequirements);
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pinkLight,
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
          child: Center(child: Image.asset('assets/images/logo.png')),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(8, 0, 8, 96),
        child: Text(
          AppTexts.termsInfo,
          style: MonseratStyles.montserrat12W400Black,
          textAlign: TextAlign.center,
        ),
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => NavBarPage()),
            );
          }
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(AppTexts.welcome, style: MonseratStyles.montserrat18W700Black),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 64, vertical: 16),
              child: Text(
                AppTexts.signUpDesc,
                style: MonseratStyles.montserrat14W400Black,
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
              child: TextFieldPasswordWidget(
                controller: passwordController,
                hintText: 'Пароль',
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
              child: TextFieldPasswordWidget(
                controller: confirmPasswordController,
                hintText: 'Підтвертдіть пароль',
              ),
            ),
            BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                if (state is AuthLoading) {
                  return CircularProgressIndicator();
                }
                return Padding(
                  padding: const EdgeInsets.fromLTRB(16, 64, 16, 32),
                  child: BlackButton(
                    buttonText: AppTexts.signUp2,
                    widthMultiplier: 1,
                    buttonFunction: () {
                      if(isButtonEnabled == true) {
                        context.read<AuthBloc>().add(
                          RegisterRequest(widget.email, passwordController.text),
                        );
                      }
                    },
                    buttonColor:
                        isButtonEnabled ? AppColors.black : AppColors.grey50,
                  ),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        checkBoxValue = !checkBoxValue!;
                        buttonRequirements();
                      });
                    },
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.black, width: 2),
                      ),
                      child:
                          checkBoxValue!
                              ? Center(
                                child: Container(
                                  width: 12,
                                  height: 12,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.blue,
                                  ),
                                ),
                              )
                              : null,
                    ),
                  ),
                  SizedBox(width: 16),
                  Flexible(
                    child: Text(
                      AppTexts.iAcceptPrivacy,
                      style: MonseratStyles.montserrat14W400Black,
                      maxLines: 2,
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.left,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Вже маю аккаунт? ',
                      style: MonseratStyles.montserrat14W400Black,
                    ),
                    TextSpan(
                      text: 'Увійти',
                      style: MonseratStyles.montserrat14W400Blue,
                      recognizer:
                          TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (_) => SignInSignUpPage(
                                        isSignUpBaseValue: false,
                                      ),
                                ),
                              );
                            },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
