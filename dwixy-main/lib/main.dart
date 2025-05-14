import 'package:dwixy/bloc/auth_bloc/auth_bloc.dart';
import 'package:dwixy/bloc/cosmetic_bloc/cosmetic_bloc.dart';
import 'package:dwixy/bloc/news_bloc/news_bloc.dart';
import 'package:dwixy/bloc/notification_bloc/notification_bloc.dart';
import 'package:dwixy/bloc/user_bloc/user_bloc.dart';
import 'package:dwixy/pages/auth_wrapper_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  const AndroidInitializationSettings initializationSettingsAndroid =
  AndroidInitializationSettings('@mipmap/ic_launcher');

  const DarwinInitializationSettings initializationSettingsIOS =
  DarwinInitializationSettings();

  const InitializationSettings initializationSettings =
  InitializationSettings(
    android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
  );

  await FlutterLocalNotificationsPlugin().initialize(initializationSettings);

  await FirebaseMessaging.instance.requestPermission();

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;

    if (notification != null && android != null) {
      FlutterLocalNotificationsPlugin().show(
        notification.hashCode,
        notification.title,
        notification.body,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'your_channel_id',
            'your_channel_name',
            channelDescription: 'Опис каналу для пушів',
            importance: Importance.max,
            priority: Priority.high,
            icon: '@mipmap/ic_launcher',
          ),
        ),
      );
    }
  });

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc()..add(CheckUserAuthStatus()),
        ),
        BlocProvider<UserBloc>(create: (context) => UserBloc()),
        BlocProvider<CosmeticBloc>(
          create: (context) => CosmeticBloc(),
        ),
        BlocProvider<NotificationBloc>(
          create: (context) => NotificationBloc(),
        ),
        BlocProvider<NewsBloc>(
          create: (context) => NewsBloc(),

        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AuthWrapperPage(),
    );
  }
}
