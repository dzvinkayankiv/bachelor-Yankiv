part of 'notification_bloc.dart';

@immutable
abstract class NotificationEvent {}

class ReceiveNotification extends NotificationEvent {
  final String title;
  final String body;

  ReceiveNotification(this.title, this.body);
}

class SetupFCWToken extends NotificationEvent {

  SetupFCWToken();
}