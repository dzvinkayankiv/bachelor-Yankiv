import 'package:dwixy/bloc/user_bloc/user_bloc.dart';
import 'package:dwixy/consts/colors.dart';
import 'package:dwixy/consts/monserat_styles.dart';
import 'package:dwixy/consts/texts.dart';
import 'package:dwixy/models/user_model.dart';
import 'package:dwixy/pages/home/nav_bar_page.dart';
import 'package:dwixy/pages/questionnaire/questionnaire_2_page.dart';
import 'package:dwixy/reusable%20widgets/custom_progress_indicator.dart';
import 'package:dwixy/reusable%20widgets/question_widget.dart';
import 'package:dwixy/reusable%20widgets/questionnaire_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../reusable widgets/black_button.dart';

class QuestionnaireThirdPage extends StatefulWidget {
  final UserModel user;

  const QuestionnaireThirdPage({super.key, required this.user});

  @override
  State<QuestionnaireThirdPage> createState() => _QuestionnaireThirdPageState();
}

class _QuestionnaireThirdPageState extends State<QuestionnaireThirdPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pinkLight,
      appBar: QuestionnaireAppBar(
        title: AppTexts.questionnaireTitle3,
        function: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => QuestionnaireSecondPage(user: widget.user),
            ),
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CustomProgressIndicator(
              totalSteps: 4,
              currentStep: 4,
              widthMultiplier: 0.2,
            ),
            SizedBox(height: 8.0),
            BlackButton(
              buttonText: AppTexts.nextButton,
              widthMultiplier: 1,
              buttonFunction: () {
                context.read<UserBloc>().add(PushUserData(widget.user));
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => NavBarPage()),
                  (route) => false,
                );
              },
              buttonColor: AppColors.black,
            ),
            TextButton(
              onPressed: () {
                context.read<UserBloc>().add(UpdateQuestionnaireValue());
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => NavBarPage()),
                      (route) => false,
                );
              },
              child: Text(
                AppTexts.skipForNow,
                style: MonseratStyles.montserrat14W400Grey80undersocred,
              ),
            ),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          QuestionWidget(
            question: "Який клімат переважає у вашій місцевості?",
            options: ["Сухий", "Вологий", "Помірний"],
            selectedAnswers: widget.user.externalFactorsQuestionnaire,
            isMultiSelect: false,
          ),
          QuestionWidget(
            question: "Як часто ви перебуваєте на відкритому сонці?",
            options: ["Щодня", "Рідко"],
            selectedAnswers: widget.user.externalFactorsQuestionnaire,
            isMultiSelect: false,
          ),
          QuestionWidget(
            question: 'Чи є у вас алергія або інші обмеження?',
            options: ['Так', 'Ні'],
            selectedAnswers: widget.user.externalFactorsQuestionnaire,
            isMultiSelect: false,
          ),
        ],
      ),
    );
  }
}
