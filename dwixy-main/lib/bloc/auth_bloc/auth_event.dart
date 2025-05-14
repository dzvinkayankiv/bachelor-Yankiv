part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent {}

class CheckUserAuthStatus extends AuthEvent {}

class LoginRequest extends AuthEvent {
  final String email;
  final String password;

  LoginRequest(this.email, this.password);
}

class RegisterRequest extends AuthEvent {
  final String email;
  final String password;

  RegisterRequest(this.email, this.password);
}

class LogoutRequest extends AuthEvent {}

class LoginViaGoogle extends AuthEvent {}

class LoginViaFacebook extends AuthEvent {}

class ClearAuthData extends AuthEvent {}