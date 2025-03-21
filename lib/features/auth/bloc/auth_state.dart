part of 'auth_bloc.dart';

sealed class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoginInProgress extends AuthState {}

class AuthLoginSuccess extends AuthState {
  AuthLoginSuccess(this.user);
  final UserModel user;
}

class AuthLoginFailure extends AuthState {
  AuthLoginFailure(this.message);
  final String message;
}

class AuthRegisterInProgress extends AuthState {}

class AuthRegisterSuccess extends AuthState {}

class AuthRegisterFailure extends AuthState {
  AuthRegisterFailure(this.message);
  final String message;
}

class AuthAuthenticated extends AuthState {
  AuthAuthenticated(this.user);
  final UserModel user;
}

class AuthUnauthenticated extends AuthState {}

class AuthLogoutSuccess extends AuthState {}

class AuthLogoutFailure extends AuthState {
  AuthLogoutFailure(this.message);
  final String message;
}
