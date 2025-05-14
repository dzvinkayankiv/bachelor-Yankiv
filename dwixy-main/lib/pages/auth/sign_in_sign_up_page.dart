import 'package:dwixy/bloc/auth_bloc/auth_bloc.dart';
import 'package:dwixy/consts/colors.dart';
import 'package:dwixy/consts/monserat_styles.dart';
import 'package:dwixy/consts/texts.dart';
import 'package:dwixy/pages/home/nav_bar_page.dart';
import 'package:dwixy/pages/auth/sign_in_page.dart';
import 'package:dwixy/pages/auth/sign_up_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class SignInSignUpPage extends StatefulWidget {
  bool isSignUpBaseValue;

  SignInSignUpPage({super.key, required this.isSignUpBaseValue});

  @override
  _SignInSignUpPageState createState() => _SignInSignUpPageState();
}

class _SignInSignUpPageState extends State<SignInSignUpPage> {
  late bool isSignUp;

  @override
  void initState() {
    super.initState();
    isSignUp = widget.isSignUpBaseValue;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pinkLight,
      appBar: AppBar(
        toolbarHeight: 120,
        title: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 16, 8, 0),
              child: Center(child: Image.asset('assets/images/logo.png')),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          widget.isSignUpBaseValue = false;
                        });
                      },
                      child: Text(
                        AppTexts.signIn,
                        style: MonseratStyles.montserrat14W700CustomColor(
                          widget.isSignUpBaseValue
                              ? AppColors.grey50
                              : AppColors.blue,
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    Container(
                      height: 2,
                      width: MediaQuery.of(context).size.width * 0.2,
                      color:
                          widget.isSignUpBaseValue
                              ? Colors.transparent
                              : AppColors.blue,
                    ),
                  ],
                ),
                Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          widget.isSignUpBaseValue = true;
                        });
                      },
                      child: Text(
                        AppTexts.signUp,
                        style: MonseratStyles.montserrat14W700CustomColor(
                          widget.isSignUpBaseValue ? Colors.blue : Colors.grey,
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    Container(
                      height: 2,
                      width: MediaQuery.of(context).size.width * 0.2,
                      color:
                          widget.isSignUpBaseValue
                              ? Colors.blue
                              : Colors.transparent,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(8, 0, 8, 48),
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
          if (state is AuthError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              widget.isSignUpBaseValue
                  ? const SignUpPage()
                  : const SignInPage(),
            ],
          ),
        ),
      ),
    );
  }
}
