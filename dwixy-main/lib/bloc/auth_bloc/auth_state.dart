part of 'auth_bloc.dart';

@immutable
abstract class AuthState {}

final class AuthInitial extends AuthState {}

final class AuthLoading extends AuthState {}

final class AuthAuthenticated extends AuthState {
  final User user;

  AuthAuthenticated(this.user);
}

final class AuthUnauthenticated extends AuthState {}

final class AuthError extends AuthState {
  final String message;

  AuthError(this.message);
}
