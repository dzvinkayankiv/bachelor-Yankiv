import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dwixy/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:meta/meta.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(UserInitial()) {
    final db = FirebaseFirestore.instance;
    final FirebaseAuth auth = FirebaseAuth.instance;
    final FirebaseStorage image = FirebaseStorage.instance;

    on<GetUserData>((event, emit) async {
      emit(UserLoading(user: state.user));
      try {
        final docRef = db.collection('users').doc(event.uid);
        DocumentSnapshot docForUser = await docRef.get();

        if (!docForUser.exists) {
          UserModel defaultUser = UserModel(
            birthday: Timestamp.now(),
            gender: "Не вказаний",
            displayName: 'Користувач',
            skinQuestionnaire: {},
            habbitsQuestionnaire: {},
            externalFactorsQuestionnaire: {},
            endCountOfProductValue: false,
            endDateOfProductValue: false,
            newsValue: false,
            imageUrl: null,
          );
          emit(UserLoaded(user: defaultUser));
          return;
        }

        final jsonData = docForUser.data() as Map<String, dynamic>?;
        if (jsonData == null) {
          UserModel defaultUser = UserModel(
            birthday: Timestamp.now(),
            gender: "невідомо",
            displayName: 'Користувач',
            skinQuestionnaire: {},
            habbitsQuestionnaire: {},
            externalFactorsQuestionnaire: {},
            endCountOfProductValue: false,
            endDateOfProductValue: false,
            newsValue: false,
            imageUrl: null,
          );
          emit(UserLoaded(user: defaultUser));
          return;
        }

        UserModel user = UserModel.fromJson(jsonData);
        emit(UserLoaded(user: user));
      } catch (e) {
        emit(UserError("Помилка при отриманні даних: $e", user: state.user));
      }
    });
    on<PushUserData>((event, emit) async {
      emit(UserLoading(user: state.user));
      try {
        final docRef = db.collection('users').doc(auth.currentUser?.uid);
        await docRef.set(event.user.toJson());
        emit(UserSaved(user: event.user));
        emit(UserLoaded(user: event.user));
      } catch (e) {
        emit(UserError("Error $e", user: state.user));
      }
    });
    on<UpdateUserData>((event, emit) async {
      try {
        final docRef = db.collection('users').doc(auth.currentUser?.uid);
        await docRef.update(({
          'displayName': event.displayName,
          'gender': event.gender,
          'birthday': event.birthdday,
        }));

        final snapshot =
            await FirebaseFirestore.instance
                .collection('users')
                .doc(auth.currentUser?.uid)
                .get();
        final jsonData = snapshot.data();
        UserModel user = UserModel.fromJson(jsonData!);
        emit(UserLoaded(user: user));
      } catch (e) {
        emit(UserError("Error $e"));
      }
    });
    on<NotificationValueChange>((event, emit) async {
      try {
        final docRef = db.collection('users').doc(auth.currentUser?.uid);
        await docRef.update(({event.changType: event.newValue}));

        final snapshot =
            await FirebaseFirestore.instance
                .collection('users')
                .doc(auth.currentUser?.uid)
                .get();
        final jsonData = snapshot.data();
        UserModel user = UserModel.fromJson(jsonData!);
        emit(UserLoaded(user: user));
      } catch (e) {
        emit(UserError("Error $e"));
      }
    });
    on<UpdateUserPhoto>((event, emit) async {
      emit(UserLoading(user: state.user));
      try {
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('profile_photos')
            .child('${auth.currentUser?.uid}.jpg');

        final compressedImage = await FlutterImageCompress.compressWithFile(
          event.imageFile.absolute.path,
          quality: 75,
          minWidth: 800,
          minHeight: 800,
        );

        if (compressedImage == null) {
          throw Exception("Не вдалося стиснути зображення");
        }

        await storageRef.putData(compressedImage);

        final photoUrl = await storageRef.getDownloadURL();

        final docRef = db.collection('users').doc(auth.currentUser?.uid);
        await docRef.update({'imageUrl': photoUrl});

        final snapshot = await docRef.get();
        final jsonData = snapshot.data();
        UserModel user = UserModel.fromJson(jsonData!);

        emit(UserLoaded(user: user));
      } catch (e) {
        emit(UserError('Помилка при оновленні фото: $e', user: state.user));
      }
    });
    on<CleanUserInfo>((event, emit) async {
      emit(UserInitial());
      await Future.delayed(Duration(milliseconds: 1));
    });
    on<UpdateQuestionnaireValue>((event, emit) {
      if (state is UserLoaded) {
        final currentState = state as UserLoaded;

        final updatedUser = currentState.user!.copyWith(
          isQuestionnaireSkipped: true,
        );

        emit(UserLoaded(user: updatedUser));
      }
    });
  }
}
