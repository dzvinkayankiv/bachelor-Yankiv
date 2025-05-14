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

class QuestionnaireFirstPage extends StatefulWidget {
  final UserModel user;

  const QuestionnaireFirstPage({super.key, required this.user});

  @override
  State<QuestionnaireFirstPage> createState() => _QuestionnaireFirstPageState();
}

class _QuestionnaireFirstPageState extends State<QuestionnaireFirstPage> {
  bool isButtonEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pinkLight,
      appBar: QuestionnaireAppBar(
        title: AppTexts.questionnaireTitle1,
        function: () {
          context.read<UserBloc>().add(UpdateQuestionnaireValue());
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => NavBarPage()),
            (route) => false,
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
              currentStep: 2,
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
                              QuestionnaireSecondPage(user: widget.user),
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
            question: "Як виглядає ваша шкіра протягом дня?",
            options: [
              "Завжди матова",
              "Ледь блищить",
              "Сильно блищить (особливо T-зона)",
            ],
            selectedAnswers: widget.user.skinQuestionnaire,
            isMultiSelect: false,
          ),
          QuestionWidget(
            question: "Чи відчуваєте сухість або стягнутість після вмивання?",
            options: ["Так", "Ні"],
            selectedAnswers: widget.user.skinQuestionnaire,
            isMultiSelect: false,
          ),
          QuestionWidget(
            question:
                'Чи відчуваєте подразнення, почервоніння або алергічні реакції після використання косметики?',
            options: ['Часто', 'Рідко', 'Ніколи'],
            selectedAnswers: widget.user.skinQuestionnaire,
            isMultiSelect: false,
          ),
          QuestionWidget(
            question: 'Які основні проблеми вас турбують?',
            options: [
              'Висипання(акне)',
              'Пігментація',
              'Зморшки',
              'Тьмяніст шкіри',
              'Жирний блиск',
              'Розширені пори',
              'Інше',
            ],
            selectedAnswers: widget.user.skinQuestionnaire,
            isMultiSelect: true,
          ),
        ],
      ),
    );
  }
}
