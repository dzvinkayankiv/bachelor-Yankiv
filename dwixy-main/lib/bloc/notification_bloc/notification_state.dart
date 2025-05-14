part of 'notification_bloc.dart';

@immutable
abstract class NotificationState {}

final class NotificationInitial extends NotificationState {}

final class NotificationReceived extends NotificationState {
  final String title;
  final String body;

  NotificationReceived(this.title, this.body);
}

final class NotificationLoading extends NotificationState {}

final class NotificationSuccess extends NotificationState {}

final class NotificationError extends NotificationState {
  final String message;

  NotificationError(this.message);
}