import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dwixy/models/cosmetic_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:meta/meta.dart';

part 'cosmetic_event.dart';

part 'cosmetic_state.dart';

class CosmeticBloc extends Bloc<CosmeticEvent, CosmeticState> {
  CosmeticBloc() : super(CosmeticInitial()) {
    final db = FirebaseFirestore.instance;
    final FirebaseAuth auth = FirebaseAuth.instance;
    final FirebaseStorage image = FirebaseStorage.instance;

    on<PushCosmetic>((event, emit) async {
      emit(CosmeticLoading());
      try {
        final imageName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
        final storageRef = image
            .ref()
            .child(auth.currentUser!.uid)
            .child(imageName);

        final compressedImage = await FlutterImageCompress.compressWithFile(
          event.image.absolute.path,
          quality: 75,
          minWidth: 800,
          minHeight: 800,
        );

        if (await event.image.exists()) {
          await storageRef.putData(compressedImage!);
        }

        final downloadUrl = await storageRef.getDownloadURL();

        final docRef =
            db
                .collection('users')
                .doc(auth.currentUser?.uid)
                .collection('cosmetics')
                .doc();

        final cosmetic = CosmeticModel(
          id: docRef.id,
          type: event.type,
          name: event.name,
          size: event.size,
          expirationDate: event.expirationDate,
          openDate: event.openDate,
          remains: event.remains,
          periodOfUse: event.periodOfUse,
          imageUrl: downloadUrl,
        );

        await docRef.set(cosmetic.toJson());
        emit(CosmeticSuccess());
      } catch (e) {
        emit(CosmeticError("Error $e"));
      }
    });

    on<GetCosmetic>((event, emit) async {
      emit(CosmeticLoading());
      try {
        final snapshot =
            await FirebaseFirestore.instance
                .collection('users')
                .doc(auth.currentUser?.uid)
                .collection('cosmetics')
                .get();

        final cosmetics = <CosmeticModel>[];
        for (final doc in snapshot.docs) {
          try {
            final cosmetic = CosmeticModel.fromDocument(doc);
            try {
              if (cosmetic.imageUrl.isNotEmpty) {
                final url =
                    await image.refFromURL(cosmetic.imageUrl).getDownloadURL();
                cosmetics.add(cosmetic.copyWith(imageUrl: url));
              } else {
                cosmetics.add(cosmetic);
              }
            } catch (_) {
              cosmetics.add(cosmetic);
            }
          } catch (e) {
            print('Помилка при обробці документа ${doc.id}: $e');
          }
        }
        emit(CosmeticLoaded(cosmetics));
      } catch (e) {
        emit(CosmeticError("Error $e"));
      }
    });
    on<DeleteCosmetic>((event, emit) async {
      emit(CosmeticLoading());
      try {
        final docRef = db
            .collection('users')
            .doc(auth.currentUser?.uid)
            .collection('cosmetics')
            .doc(event.id);
        await docRef.delete();
      } catch (e) {
        emit(CosmeticError("Error $e"));
      }
    });
    on<PutCosmetic>((event, emit) async {
      emit(CosmeticLoading());
      try {
        String downloadUrl = event.imageUrl;

        if (event.image.existsSync()) {
          final compressedImage = await FlutterImageCompress.compressWithFile(
            event.image.absolute.path,
            quality: 75,
            minWidth: 800,
            minHeight: 800,
          );

          if (compressedImage != null) {
            final imageName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
            final storageRef = image
                .ref()
                .child(auth.currentUser!.uid)
                .child(imageName);
            await storageRef.putData(compressedImage);
            await Future.delayed(const Duration(milliseconds: 300));
            downloadUrl = await storageRef.getDownloadURL();
          }
        }

        final docRef = db
            .collection('users')
            .doc(auth.currentUser?.uid)
            .collection('cosmetics')
            .doc(event.id);
        await docRef.update(
          CosmeticModel(
            id: event.id,
            type: event.type,
            name: event.name,
            size: event.size,
            expirationDate: event.expirationDate,
            openDate: event.openDate,
            remains: event.remains,
            periodOfUse: event.periodOfUse,
            imageUrl: downloadUrl,
          ).toJson()
        );
        emit(CosmeticSuccess());
      } catch (e) {
        emit(CosmeticError("Error $e"));
      }
    });
    on<TodayUsedCosmetic>((event, emit) async {
      emit(CosmeticLoading());
      try {
        final docRef = db
            .collection('users')
            .doc(auth.currentUser?.uid)
            .collection('cosmetics')
            .doc(event.id);
        await docRef.update(({'remains': event.newValue}));
      } catch (e) {
        emit(CosmeticError("Error $e"));
      }
    });
  }
}
