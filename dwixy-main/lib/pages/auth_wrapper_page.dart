import 'package:dwixy/bloc/auth_bloc/auth_bloc.dart';
import 'package:dwixy/bloc/user_bloc/user_bloc.dart';
import 'package:dwixy/pages/home/nav_bar_page.dart';
import 'package:dwixy/pages/onboarding_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthWrapperPage extends StatelessWidget {
  const AuthWrapperPage({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = FirebaseAuth.instance;
    return BlocListener<AuthBloc, AuthState>(
      listenWhen: (previous, current) => current is AuthAuthenticated,
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          context.read<UserBloc>().add(GetUserData(uid: auth.currentUser!.uid));
        }
      },
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is AuthAuthenticated) {
            return NavBarPage();
          } else if (state is AuthUnauthenticated || state is AuthInitial) {
            return OnBoardingPage();
          } else if (state is AuthLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is AuthError) {
            return OnBoardingPage();
          }
          return OnBoardingPage();
        },
      ),
    );
  }
}
