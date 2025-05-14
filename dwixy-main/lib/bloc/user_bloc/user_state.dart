part of 'user_bloc.dart';

@immutable
abstract class UserState {
  final UserModel? user;

  const UserState({this.user});
}

final class UserInitial extends UserState {
  const UserInitial() : super(user: null);
}

final class UserLoading extends UserState {
  const UserLoading({super.user});
}

final class UserLoaded extends UserState {
  const UserLoaded({required UserModel user}) : super(user: user);
}

final class UserError extends UserState {
  final String message;

  const UserError(this.message, {super.user});
}

final class UserEmpty extends UserState {
  const UserEmpty() : super(user: null);
}

final class UserSaved extends UserState {
  const UserSaved({super.user});
}
