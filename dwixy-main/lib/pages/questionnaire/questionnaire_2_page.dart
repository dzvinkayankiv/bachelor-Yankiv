import 'package:dwixy/consts/colors.dart';
import 'package:dwixy/consts/monserat_styles.dart';
import 'package:dwixy/consts/texts.dart';
import 'package:dwixy/models/user_model.dart';
import 'package:dwixy/pages/home/nav_bar_page.dart';
import 'package:dwixy/pages/questionnaire/questionnaire_1_page.dart';
import 'package:dwixy/pages/questionnaire/questionnaire_3_page.dart';
import 'package:dwixy/reusable%20widgets/custom_progress_indicator.dart';
import 'package:dwixy/reusable%20widgets/question_widget.dart';
import 'package:dwixy/reusable%20widgets/questionnaire_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/user_bloc/user_bloc.dart';
import '../../reusable widgets/black_button.dart';

class QuestionnaireSecondPage extends StatefulWidget {
  final UserModel user;

  const QuestionnaireSecondPage({super.key, required this.user});

  @override
  State<QuestionnaireSecondPage> createState() =>
      _QuestionnaireSecondPageState();
}

class _QuestionnaireSecondPageState extends State<QuestionnaireSecondPage> {
  bool isButtonEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pinkLight,
      appBar: QuestionnaireAppBar(
        title: AppTexts.questionnaireTitle2,
        function: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => QuestionnaireFirstPage(user: widget.user),
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
              currentStep: 3,
              widthMultiplier: 0.2,
            ),
            SizedBox(height: 8.0),
            BlackButton(
              buttonText: AppTexts.nextButton,
              widthMultiplier: 1,
              buttonFunction: () {
                if (isButtonEnabled == true) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) =>
                              QuestionnaireThirdPage(user: widget.user),
                    ),
                  );
                }
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
            question: "Як часто ви очищуєте шкіру обличчя?",
            options: ["Один раз на день", "Двічі на день", "Рідше"],
            selectedAnswers: widget.user.habbitsQuestionnaire,
            isMultiSelect: false,
          ),
          QuestionWidget(
            question: "Чи використовуєте ви зволожуючі засоби?",
            options: ["Так, регулярно", "Інколи", "Ніколи"],
            selectedAnswers: widget.user.habbitsQuestionnaire,
            isMultiSelect: false,
          ),
          QuestionWidget(
            question: 'Чи використовуєте SPF-засоби?',
            options: ['Щодня', 'Тільки влітку', 'Ніколи'],
            selectedAnswers: widget.user.habbitsQuestionnaire,
            isMultiSelect: false,
          ),
          QuestionWidget(
            question: 'Які засоби ви зараз використовуєте?',
            options: [
              'Очищувач',
              'Тонік',
              'Зволожувач',
              'Сироватка',
              'Крем',
              'Інше',
            ],
            selectedAnswers: widget.user.habbitsQuestionnaire,
            isMultiSelect: true,
          ),
        ],
      ),
    );
  }
}
