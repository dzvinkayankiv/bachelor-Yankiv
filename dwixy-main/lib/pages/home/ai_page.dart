import 'package:dwixy/bloc/user_bloc/user_bloc.dart';
import 'package:dwixy/consts/colors.dart';
import 'package:dwixy/consts/maleFamaleIcons.dart';
import 'package:dwixy/consts/roboto_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ai_toolkit/flutter_ai_toolkit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class AiPage extends StatelessWidget {
  const AiPage({super.key});

  @override
  Widget build(BuildContext context) {
    String apikey = "AIzaSyCUaFiSsHCYSwK1B5GnSUvH_yv1Fr9DzZo";
    String model = "gemini-2.0-flash";

    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        if (state is UserLoaded && state.user != null) {
          return LlmChatView(
            welcomeMessage:
                state.user!.skinQuestionnaire.isNotEmpty
                    ? 'Вітаю! Дякую, що заповнили опитування. Задавайте ваші питання.'
                    : 'Вітаю! Ви ще не заповнили опитування але я готовий вам допомогти.',
            style: LlmChatViewStyle(
              backgroundColor: AppColors.pinkLight,
              chatInputStyle: ChatInputStyle(
                backgroundColor: AppColors.pinkLight,
                hintText: "Запитайте у мене щось...",
              ),
              userMessageStyle: UserMessageStyle(
                textStyle: RobotoStyles.roboto14W400White,
                decoration: BoxDecoration(
                  color: AppColors.pink,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(90),
                    topRight: Radius.circular(0),
                    bottomLeft: Radius.circular(90),
                    bottomRight: Radius.circular(90),
                  ),
                ),
              ),
              llmMessageStyle: LlmMessageStyle(icon: MaleFamaleIcons.robot),
            ),
            provider: GeminiProvider(
              model: GenerativeModel(
                model: model,
                apiKey: apikey,
                systemInstruction: Content.text(
                  'Ти - експерт з догляду за шкірою. Відповідай тільки на запитання, що стосуються догляду за шкірою. '
                  '${state.user!.skinQuestionnaire.isNotEmpty || state.user!.externalFactorsQuestionnaire.isNotEmpty || state.user!.habbitsQuestionnaire.isNotEmpty ? "Допомагай на основі опитування: ${state.user!.skinQuestionnaire.entries.map((e) => '${e.key}: ${e.value}').join(', ')} ${state.user!.habbitsQuestionnaire.entries.map((e) => '${e.key}: ${e.value}').join(', ')}, ${state.user!.externalFactorsQuestionnaire.entries.map((e) => '${e.key}: ${e.value}').join(', ')}" : "Опитування порожнє, допомагай загальними порадами."} '
                  'Якщо користувач запитає щось не по темі, скажи: "Вибач, я можу відповідати лише на питання про догляд за шкірою".',
                ),
                // generationConfig: GenerationConfig(maxOutputTokens: 200),
              ),
            ),
          );
        } else if (state is UserLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (state is UserError) {
          return Text(state.message);
        }
        return Center(child: Text('Невідомий стан. Спробуйте ще раз.'));
      },
    );
  }
}
