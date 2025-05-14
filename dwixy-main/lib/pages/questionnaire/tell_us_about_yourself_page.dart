import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dwixy/bloc/auth_bloc/auth_bloc.dart';
import 'package:dwixy/bloc/user_bloc/user_bloc.dart';
import 'package:dwixy/consts/colors.dart';
import 'package:dwixy/consts/maleFamaleIcons.dart';
import 'package:dwixy/consts/monserat_styles.dart';
import 'package:dwixy/models/user_model.dart';
import 'package:dwixy/pages/questionnaire/questionnaire_1_page.dart';
import 'package:dwixy/pages/welcome_page.dart';
import 'package:dwixy/reusable%20widgets/black_button.dart';
import 'package:dwixy/reusable%20widgets/custom_progress_indicator.dart';
import 'package:dwixy/reusable%20widgets/date_picker_widget.dart';
import 'package:dwixy/reusable%20widgets/text_field_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../consts/texts.dart';
import '../../reusable widgets/gender_select_button.dart';
import '../home/nav_bar_page.dart';

class TellUsAboutYourselfPage extends StatefulWidget {
  final User user;
  final UserModel userModel;
  final String userName;

  const TellUsAboutYourselfPage({
    super.key,
    required this.user,
    required this.userModel,
    required this.userName,
  });

  @override
  State<TellUsAboutYourselfPage> createState() =>
      _TellUsAboutYourselfPageState();
}

class _TellUsAboutYourselfPageState extends State<TellUsAboutYourselfPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  bool isFamale = true;
  bool isButtonEnabled = false;
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    nameController.addListener(checkTextField);
    dateController.addListener(checkTextField);
    nameController.text = widget.userName;
    selectedDate = widget.userModel.birthday.toDate();
    dateController.text = DateFormat(
      'dd/MM/yyyy',
    ).format(widget.userModel.birthday.toDate());
    isFamale = widget.userModel.gender == "Male" ? false : true;
  }

  void checkTextField() {
    setState(() {
      isButtonEnabled =
          nameController.text.isNotEmpty && dateController.text.isNotEmpty;
    });
  }

  @override
  void dispose() {
    nameController.removeListener(checkTextField);
    dateController.removeListener(checkTextField);
    nameController.dispose();
    dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBar(
          leading: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              if (state is AuthAuthenticated) {
                return IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(MaleFamaleIcons.dagger, size: 12),
                );
              } else {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => WelcomePage()),
                );
              }
              return SizedBox();
            },
          ),
        ),
        backgroundColor: AppColors.pinkLight,
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(8.0),
          child: BlocBuilder<UserBloc, UserState>(
            builder: (context, state) {
              if (state is UserLoading) {
                return Center(child: CircularProgressIndicator());
              } else {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    CustomProgressIndicator(
                      totalSteps: 4,
                      currentStep: 1,
                      widthMultiplier: 0.2,
                    ),
                    SizedBox(height: 8.0),
                    BlackButton(
                      buttonText: AppTexts.nextButton,
                      widthMultiplier: 1,
                      buttonFunction: () {
                        if (isButtonEnabled == true) {
                          context.read<UserBloc>().add(
                            UpdateUserData(
                              displayName: nameController.text,
                              gender: isFamale ? "Famale" : "Male",
                              birthdday: Timestamp.fromDate(selectedDate!),
                            ),
                          );

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => QuestionnaireFirstPage(
                                    user: UserModel(
                                      birthday: Timestamp.fromDate(
                                        selectedDate!,
                                      ),
                                      gender: isFamale ? "Famale" : "Male",
                                      displayName: nameController.text,
                                      skinQuestionnaire: {},
                                      externalFactorsQuestionnaire: {},
                                      habbitsQuestionnaire: {},
                                      endDateOfProductValue:
                                          widget
                                              .userModel
                                              .endDateOfProductValue,
                                      endCountOfProductValue:
                                          widget
                                              .userModel
                                              .endCountOfProductValue,
                                      newsValue: widget.userModel.newsValue,
                                    ),
                                  ),
                            ),
                          );
                        }
                      },
                      buttonColor:
                          isButtonEnabled ? AppColors.black : AppColors.grey50,
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        AppTexts.skipForNow,
                        style: MonseratStyles.montserrat14W400Grey80undersocred,
                      ),
                    ),
                  ],
                );
              }
            },
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
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                AppTexts.tellUsAboutYourself,
                style: MonseratStyles.montserrat22W700Black,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(64, 16, 64, 48),
                child: Text(
                  AppTexts.tellUsAboutYourselfDesc,
                  style: MonseratStyles.montserrat14W400Black,
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFieldWidget(
                  controller: nameController,
                  hintText: AppTexts.name,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DatePickerWidget(
                  hintText: AppTexts.dateOfBirth,
                  function: () async {
                    final DateTime? pickedDate = await showDatePicker(
                      context: context,
                      firstDate: DateTime.utc(1900),
                      lastDate: DateTime.now(),
                    );

                    if (pickedDate != null) {
                      setState(() {
                        selectedDate = pickedDate;
                        dateController.text = DateFormat(
                          'dd/MM/yyyy',
                        ).format(pickedDate);
                      });
                    }
                  },
                  textController: dateController,
                  showSufixIcon: true,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GenderSelectButton(
                    text: 'Male',
                    textColor: isFamale ? AppColors.black : AppColors.white,
                    icon: MaleFamaleIcons.male,
                    iconColor: isFamale ? AppColors.black : AppColors.white,
                    backgroundColor:
                        isFamale ? Colors.transparent : AppColors.blue,
                    buttonFunction: () {
                      setState(() {
                        isFamale = false;
                      });
                    },
                  ),
                  GenderSelectButton(
                    text: 'Famale',
                    textColor: isFamale ? AppColors.white : AppColors.black,
                    icon: MaleFamaleIcons.famale,
                    iconColor: isFamale ? AppColors.white : AppColors.black,
                    backgroundColor:
                        isFamale ? AppColors.pink : Colors.transparent,
                    buttonFunction: () {
                      setState(() {
                        isFamale = true;
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
