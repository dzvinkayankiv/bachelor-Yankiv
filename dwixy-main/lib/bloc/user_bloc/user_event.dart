part of 'user_bloc.dart';

@immutable
abstract class UserEvent {}

class GetUserData extends UserEvent {
  final String uid;

  GetUserData({required this.uid});
}

class PushUserData extends UserEvent {
  final UserModel user;

  PushUserData(this.user);
}

class UpdateUserData extends UserEvent {
  final String displayName;
  final Timestamp birthdday;
  final String gender;

  UpdateUserData({
    required this.displayName,
    required this.gender,
    required this.birthdday,
  });
}

class NotificationValueChange extends UserEvent {
  final String changType;
  final bool newValue;

  NotificationValueChange(this.changType, this.newValue);
}

class UpdateUserPhoto extends UserEvent {
  final File imageFile;

  UpdateUserPhoto(this.imageFile);
}

class CleanUserInfo extends UserEvent {}

class UpdateQuestionnaireValue extends UserEvent {}
