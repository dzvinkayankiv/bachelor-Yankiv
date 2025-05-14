import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:meta/meta.dart';

part 'notification_event.dart';

part 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final _firebaseMessaging = FirebaseMessaging.instance;
  final db = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  NotificationBloc() : super(NotificationInitial()) {
    on<ReceiveNotification>((event, emit) {
      emit(NotificationReceived(event.title, event.body));
    });

    on<SetupFCWToken>((event, emit) async {
      emit(NotificationLoading());
      try {
        final token = await _firebaseMessaging.getToken();
        final docRef = db.collection('users').doc(auth.currentUser!.uid);
        docRef.update({'fcwToken': token});
      } catch (e) {
        emit(NotificationError("Error: $e"));
      }
    });
  }
}
