import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dwixy/bloc/auth_bloc/auth_bloc.dart';
import 'package:dwixy/bloc/notification_bloc/notification_bloc.dart';
import 'package:dwixy/bloc/user_bloc/user_bloc.dart';
import 'package:dwixy/consts/colors.dart';
import 'package:dwixy/consts/monserat_styles.dart';
import 'package:dwixy/pages/questionnaire/tell_us_about_yourself_page.dart';
import 'package:dwixy/reusable%20widgets/notification_setting_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  XFile? pickedImage;

  @override
  Widget build(BuildContext context) {
    String getDisplayName(AuthState authState, UserState userState) {
      String? authName =
          authState is AuthAuthenticated
              ? authState.user.providerData.first.displayName
              : null;
      String? userName =
          userState is UserLoaded ? userState.user!.displayName : null;

      if (userName != null && userName.isNotEmpty && userName != 'Користувач') {
        return userName.split(' ').first;
      } else if (authName != null && authName.isNotEmpty) {
        return authName.split(' ').first;
      }
      return "Користувач";
    }

    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        if (authState is AuthLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (authState is AuthAuthenticated) {
          return BlocBuilder<UserBloc, UserState>(
            builder: (context, state) {
              if (state is UserLoaded) {
                final endCountOfProduct = state.user!.endCountOfProductValue;
                final endDateOfProduct = state.user!.endDateOfProductValue;
                final news = state.user!.newsValue;

                return SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(90),
                              child: GestureDetector(
                                onTap: () async {
                                  final pickedFile = await ImagePicker()
                                      .pickImage(source: ImageSource.gallery);

                                  if (pickedFile != null) {
                                    final file = File(pickedFile.path);

                                    setState(() {
                                      pickedImage = pickedFile;
                                    });

                                    context.read<UserBloc>().add(
                                      UpdateUserPhoto(file),
                                    );
                                  }
                                },
                                child:
                                (state.user?.imageUrl != null && state.user!.imageUrl!.isNotEmpty)
                                    ? CachedNetworkImage(
                                  imageUrl: state.user!.imageUrl!,
                                  width: 90,
                                  height: 90,
                                  fit: BoxFit.cover,
                                  errorWidget: (context, url, error) {
                                    return Container(
                                      width: 90,
                                      height: 90,
                                      color: AppColors.pink2,
                                      child: Center(
                                        child: Text(
                                          getDisplayName(authState, state)[0].isNotEmpty
                                              ? getDisplayName(authState, state)[0]
                                              : 'К',
                                          style: MonseratStyles.montserrat40W700CustomColor(
                                            AppColors.purpleDark,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                )
                                    : (authState.user.photoURL != null && authState.user.photoURL!.isNotEmpty)
                                    ? CachedNetworkImage(
                                  imageUrl: authState.user.photoURL!,
                                  width: 90,
                                  height: 90,
                                  fit: BoxFit.cover,
                                  errorWidget: (context, url, error) {
                                    return Container(
                                      width: 90,
                                      height: 90,
                                      color: AppColors.pink2,
                                      child: Center(
                                        child: Text(
                                          getDisplayName(authState, state)[0].isNotEmpty
                                              ? getDisplayName(authState, state)[0]
                                              : 'К',
                                          style: MonseratStyles.montserrat40W700CustomColor(
                                            AppColors.purpleDark,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                )
                                    : Container(
                                  width: 90,
                                  height: 90,
                                  color: AppColors.pink2,
                                  child: Center(
                                    child: Text(
                                      getDisplayName(authState, state)[0].isNotEmpty
                                          ? getDisplayName(authState, state)[0]
                                          : 'К',
                                      style: MonseratStyles.montserrat40W700CustomColor(
                                        AppColors.purpleDark,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 24),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(getDisplayName(authState, state)),
                                Text(authState.user.providerData.first.email!),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(8),
                              topLeft: Radius.circular(8),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Ваш догляд",
                                      style:
                                          MonseratStyles.montserrat16W700Black,
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder:
                                                (context) =>
                                                    TellUsAboutYourselfPage(
                                                      user: authState.user,
                                                      userModel: state.user!,
                                                      userName: getDisplayName(
                                                        authState,
                                                        state,
                                                      ),
                                                    ),
                                          ),
                                        );
                                      },
                                      icon: SvgPicture.asset(
                                        'assets/icons/edit.svg',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Divider(),
                              ExpansionTile(
                                collapsedShape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.zero,
                                  side: BorderSide.none,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.zero,
                                  side: BorderSide.none,
                                ),
                                title: Text(
                                  'Тип шкіри',
                                  style: MonseratStyles.montserrat14W500Black,
                                ),
                                children:
                                    state
                                            .user!
                                            .skinQuestionnaire
                                            .entries
                                            .isEmpty
                                        ? [
                                          Text(
                                            'Заповніть анкету для підбору рекомендацій',
                                            style:
                                                MonseratStyles
                                                    .montserrat14W500Black,
                                          ),
                                        ]
                                        : state.user!.skinQuestionnaire.entries
                                            .map(
                                              (entry) => ListTile(
                                                title: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      entry.key,
                                                      style:
                                                          MonseratStyles
                                                              .montserrat14W500Grey80,
                                                    ),
                                                    Text(
                                                      (entry.value
                                                          .toString()
                                                          .replaceAll('[', '')
                                                          .replaceAll(']', '')),
                                                      style:
                                                          MonseratStyles
                                                              .montserrat14W500Black,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            )
                                            .toList(),
                              ),
                              Divider(),
                              ExpansionTile(
                                collapsedShape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.zero,
                                  side: BorderSide.none,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.zero,
                                  side: BorderSide.none,
                                ),
                                title: Text(
                                  'Звички у догляді',
                                  style: MonseratStyles.montserrat14W500Black,
                                ),
                                children:
                                    state
                                            .user!
                                            .habbitsQuestionnaire
                                            .entries
                                            .isEmpty
                                        ? [
                                          Text(
                                            'Заповніть анкету для підбору рекомендацій',
                                            style:
                                                MonseratStyles
                                                    .montserrat14W500Black,
                                          ),
                                        ]
                                        : state
                                            .user!
                                            .habbitsQuestionnaire
                                            .entries
                                            .map(
                                              (entry) => ListTile(
                                                title: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      entry.key,
                                                      style:
                                                          MonseratStyles
                                                              .montserrat14W500Grey80,
                                                    ),
                                                    Text(
                                                      (entry.value
                                                          .toString()
                                                          .replaceAll('[', '')
                                                          .replaceAll(']', '')),
                                                      style:
                                                          MonseratStyles
                                                              .montserrat14W500Black,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            )
                                            .toList(),
                              ),
                              Divider(),
                              ExpansionTile(
                                collapsedShape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.zero,
                                  side: BorderSide.none,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.zero,
                                  side: BorderSide.none,
                                ),
                                title: Text(
                                  'Зовнішні фактори',
                                  style: MonseratStyles.montserrat14W500Black,
                                ),
                                children:
                                    state
                                            .user!
                                            .externalFactorsQuestionnaire
                                            .entries
                                            .isEmpty
                                        ? [
                                          Text(
                                            'Заповніть анкету для підбору рекомендацій',
                                            style:
                                                MonseratStyles
                                                    .montserrat14W500Black,
                                          ),
                                        ]
                                        : state
                                            .user!
                                            .externalFactorsQuestionnaire
                                            .entries
                                            .map(
                                              (entry) => ListTile(
                                                title: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      entry.key,
                                                      style:
                                                          MonseratStyles
                                                              .montserrat14W500Grey80,
                                                    ),
                                                    Text(
                                                      (entry.value
                                                          .toString()
                                                          .replaceAll('[', '')
                                                          .replaceAll(']', '')),
                                                      style:
                                                          MonseratStyles
                                                              .montserrat14W500Black,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            )
                                            .toList(),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(8),
                              topLeft: Radius.circular(8),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Налаштування сповіщень",
                                  style: MonseratStyles.montserrat16W700Black,
                                ),
                              ),
                              Divider(),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0,
                                ),
                                child: NotificationSettingWidget(
                                  text: 'Закінчення продукту',
                                  value: endCountOfProduct,
                                  function: (value) {
                                    if (state.user!.fcwToken == null) {
                                      context.read<NotificationBloc>().add(
                                        SetupFCWToken(),
                                      );
                                    }
                                    context.read<UserBloc>().add(
                                      NotificationValueChange(
                                        'endCountOfProductValue',
                                        value,
                                      ),
                                    );
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0,
                                ),
                                child: NotificationSettingWidget(
                                  text: 'Термін придатності',
                                  value: endDateOfProduct,
                                  function: (value) {
                                    if (state.user!.fcwToken == null) {
                                      context.read<NotificationBloc>().add(
                                        SetupFCWToken(),
                                      );
                                    }
                                    context.read<UserBloc>().add(
                                      NotificationValueChange(
                                        'endDateOfProductValue',
                                        value,
                                      ),
                                    );
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0,
                                ),
                                child: NotificationSettingWidget(
                                  text: 'Статті та рекомендації',
                                  value: news,
                                  function: (value) {
                                    if (state.user!.fcwToken == null) {
                                      context.read<NotificationBloc>().add(
                                        SetupFCWToken(),
                                      );
                                    }
                                    context.read<UserBloc>().add(
                                      NotificationValueChange(
                                        'newsValue',
                                        value,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              context.read<UserBloc>().add(CleanUserInfo());
                              context.read<AuthBloc>().add(ClearAuthData());
                              context.read<AuthBloc>().add(LogoutRequest());},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(0),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SvgPicture.asset('assets/icons/log-out.svg'),
                                SizedBox(width: 8),
                                Text(
                                  'Вийти',
                                  style:
                                      MonseratStyles.montserrat14W600CustomColor(
                                        AppColors.black,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }
              return SizedBox();
            },
          );
        } else {
          return SizedBox();
        }
      },
    );
  }
}
