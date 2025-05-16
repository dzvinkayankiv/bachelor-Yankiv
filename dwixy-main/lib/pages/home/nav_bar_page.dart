import 'package:dwixy/bloc/auth_bloc/auth_bloc.dart';
import 'package:dwixy/bloc/cosmetic_bloc/cosmetic_bloc.dart';
import 'package:dwixy/bloc/user_bloc/user_bloc.dart';
import 'package:dwixy/consts/colors.dart';
import 'package:dwixy/consts/monserat_styles.dart';
import 'package:dwixy/consts/poppins_styles.dart';
import 'package:dwixy/consts/texts.dart';
import 'package:dwixy/pages/home/ai_page.dart';
import 'package:dwixy/pages/home/cosmetics_page.dart';
import 'package:dwixy/pages/home/profile_page.dart';
import 'package:dwixy/pages/home/news_page.dart';
import 'package:dwixy/pages/modals/add_new_cosmetic_modal.dart';
import 'package:dwixy/pages/onboarding_page.dart';
import 'package:dwixy/pages/questionnaire/questionnaire_1_page.dart';
import 'package:dwixy/pages/welcome_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NavBarPage extends StatefulWidget {
  const NavBarPage({super.key});

  @override
  State<NavBarPage> createState() => _NavBarPageState();
}

class _NavBarPageState extends State<NavBarPage> {
  int _selectedIndex = 0;
  final List<Widget> _pages = [
    CosmeticsPage(),
    NewsPage(),
    AiPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthAuthenticated) {
              context.read<UserBloc>().add(
                GetUserData(uid: FirebaseAuth.instance.currentUser!.uid),
              );
              context.read<CosmeticBloc>().add(GetCosmetic());
            } else if (state is AuthUnauthenticated) {
              context.read<UserBloc>().add(CleanUserInfo());
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => OnBoardingPage()),
              );
            }
          },
        ),
        BlocListener<UserBloc, UserState>(
          listener: (context, state) {
            final isLoggedIn = FirebaseAuth.instance.currentUser != null;

            if (isLoggedIn &&
                state is UserLoaded &&
                state.user!.skinQuestionnaire.isEmpty &&
                state.user!.habbitsQuestionnaire.isEmpty &&
                state.user!.externalFactorsQuestionnaire.isEmpty &&
                state.user!.isQuestionnaireSkipped == false) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => QuestionnaireFirstPage(user: state.user!),
                ),
              );
            }
          },
        ),
      ],
      child: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          if (state is UserInitial) {
            context.read<UserBloc>().add(
              GetUserData(uid: FirebaseAuth.instance.currentUser!.uid),
            );
            return Scaffold(body: Center(child: CircularProgressIndicator()));
          } else if (state is UserLoading) {
            return Scaffold(body: Center(child: CircularProgressIndicator()));
          } else if (state is UserLoaded) {
            return Scaffold(
              backgroundColor: AppColors.pinkLight,
              floatingActionButton:
              _selectedIndex == 0
                  ? SizedBox(
                height: 56,
                width: 56,
                child: ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder:
                          (BuildContext context) =>
                          AddNewCosmeticModal(),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    shape: CircleBorder(),
                    padding: EdgeInsets.all(0),
                    backgroundColor: Color.fromRGBO(254, 233, 253, 1),
                    elevation: 4,
                  ),
                  child: SvgPicture.asset(
                    'assets/icons/plus.svg',
                    colorFilter: ColorFilter.mode(
                      AppColors.purpleDark,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              )
                  : null,
              appBar: AppBar(
                backgroundColor: AppColors.pinkLight,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _selectedIndex == 0
                        ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppTexts.hello,
                          style: PoppinsStyles.poppins14W400Grey,
                        ),
                        BlocBuilder<UserBloc, UserState>(
                          builder: (context, state) {
                            if (state is UserLoaded) {
                              final user = state.user;

                              String displayName = "Користувач";
                              if (user!.displayName != null &&
                                  user.displayName!.isNotEmpty &&
                                  user.displayName != 'Користувач') {
                                displayName = user.displayName!.split(' ').first;
                              }

                              return Text(
                                displayName,
                                style: MonseratStyles.montserrat20W700Black,
                              );
                            }

                            return const Text(
                              "Користувач",
                              style: MonseratStyles.montserrat20W700Black,
                            );
                          },
                        ),
                      ],
                    )
                        : _selectedIndex == 1
                        ? Text(
                      "Рекомендації",
                      style: MonseratStyles.montserrat22W700Black,
                    )
                        : _selectedIndex == 2
                        ? Text(
                      "Персональний помічник",
                      style: MonseratStyles.montserrat22W700Black,
                    )
                        : _selectedIndex == 3
                        ? Text(
                      "Профіль",
                      style: MonseratStyles.montserrat22W700Black,
                    )
                        : SizedBox(),
                    _selectedIndex == 0
                        ? Builder(
                      builder:
                          (context) =>
                          IconButton(
                            icon: Icon(CupertinoIcons.bell),
                            onPressed: () {},
                          ),
                    )
                        : SizedBox(),
                  ],
                ),
              ),
              bottomNavigationBar: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: BottomNavigationBar(
                  type: BottomNavigationBarType.fixed,
                  showSelectedLabels: false,
                  showUnselectedLabels: false,
                  currentIndex: _selectedIndex,
                  onTap: (index) {
                    setState(() {
                      _selectedIndex = index;
                    });
                  },
                  items: [
                    BottomNavigationBarItem(
                      icon: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color:
                          _selectedIndex == 0
                              ? AppColors.pink
                              : Colors.transparent,
                        ),
                        child: SvgPicture.asset(
                          'assets/icons/cosmetics.svg',
                          colorFilter: ColorFilter.mode(
                            _selectedIndex == 0
                                ? AppColors.white
                                : AppColors.black,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                      label: '',
                    ),
                    BottomNavigationBarItem(
                      icon: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color:
                          _selectedIndex == 1
                              ? AppColors.pink
                              : Colors.transparent,
                        ),
                        child: SvgPicture.asset(
                          'assets/icons/boxes.svg',
                          colorFilter: ColorFilter.mode(
                            _selectedIndex == 1
                                ? AppColors.white
                                : AppColors.black,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                      label: '',
                    ),
                    BottomNavigationBarItem(
                      icon: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color:
                          _selectedIndex == 2
                              ? AppColors.pink
                              : Colors.transparent,
                        ),
                        child: SvgPicture.asset(
                          'assets/icons/ai.svg',
                          colorFilter: ColorFilter.mode(
                            _selectedIndex == 2
                                ? AppColors.white
                                : AppColors.black,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                      label: '',
                    ),
                    BottomNavigationBarItem(
                      icon: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color:
                          _selectedIndex == 3
                              ? AppColors.pink
                              : Colors.transparent,
                        ),
                        child: SvgPicture.asset(
                          'assets/icons/profile.svg',
                          colorFilter: ColorFilter.mode(
                            _selectedIndex == 3
                                ? AppColors.white
                                : AppColors.black,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                      label: '',
                    ),
                  ],
                ),
              ),
              body: IndexedStack(index: _selectedIndex, children: _pages),
            );
          } else if (state is UserError) {
            return Scaffold(body: Center(child: Text(state.message)));
          } else {
            print(state);
            return WelcomePage();
          }
        },
      ),
    );
  }
}