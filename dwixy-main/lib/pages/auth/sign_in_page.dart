import 'package:dwixy/bloc/auth_bloc/auth_bloc.dart';
import 'package:dwixy/consts/colors.dart';
import 'package:dwixy/consts/texts.dart';
import 'package:dwixy/consts/monserat_styles.dart';
import 'package:dwixy/reusable%20widgets/black_button.dart';
import 'package:dwixy/reusable%20widgets/text_field_password_widget.dart';
import 'package:dwixy/reusable%20widgets/text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    emailController.addListener(checkTextField);
    passwordController.addListener(checkTextField);
  }

  void checkTextField() {
    setState(() {
      isButtonEnabled = emailController.text.isNotEmpty &&
          emailController.text.contains("@") &&
          emailController.text.contains('.') &&
          passwordController.text.isNotEmpty;
    });
  }

  @override
  void dispose() {
    emailController.removeListener(checkTextField);
    passwordController.removeListener(checkTextField);
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
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
          padding: const EdgeInsets.all(8.0),
          child: TextFieldWidget(
            controller: emailController,
            hintText: 'Email',
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFieldPasswordWidget(
            controller: passwordController,
            hintText: 'Пароль',
          ),
        ),
        BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is AuthLoading) {
              return CircularProgressIndicator();
            }
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 32),
              child: BlackButton(
                buttonText: AppTexts.signIn,
                widthMultiplier: 1,
                buttonColor:
                    isButtonEnabled ? AppColors.black : AppColors.grey50,
                buttonFunction: () {
                  context.read<AuthBloc>().add(
                    LoginRequest(emailController.text, passwordController.text),
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }
}
