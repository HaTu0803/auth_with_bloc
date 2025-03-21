part of 'auth_bloc.dart';

abstract class AuthEvent {}

class AuthStarted extends AuthEvent {}

class AuthLoginStarted extends AuthEvent {
  AuthLoginStarted({required this.email, required this.password});

  final String email;
  final String password;
}

class AuthRegisterStarted extends AuthEvent {
  AuthRegisterStarted({
    required this.email,
    required this.password,
    this.username,
  });

  final String email;
  final String password;
  final String? username;
}

class AuthAuthenticateStarted extends AuthEvent {}

class AuthLogoutStarted extends AuthEvent {}
