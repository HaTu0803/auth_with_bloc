import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/user_model.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  UserModel? _currentUser;
  String? _authToken;

  AuthBloc() : super(AuthInitial()) {
    on<AuthStarted>(_onAuthStarted);
    on<AuthLoginStarted>(_onAuthLoginStarted);
    on<AuthRegisterStarted>(_onAuthRegisterStarted);
    on<AuthAuthenticateStarted>(_onAuthAuthenticateStarted);
    on<AuthLogoutStarted>(_onAuthLogoutStarted);
  }

  void _onAuthStarted(AuthStarted event, Emitter<AuthState> emit) {
    add(AuthAuthenticateStarted());
  }

  void _onAuthAuthenticateStarted(
    AuthAuthenticateStarted event,
    Emitter<AuthState> emit,
  ) {
    if (_authToken != null && _currentUser != null) {
      emit(AuthAuthenticated(_currentUser!));
    } else {
      emit(AuthUnauthenticated());
    }
  }

  Future<void> _onAuthLoginStarted(
    AuthLoginStarted event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoginInProgress());

    await Future.delayed(const Duration(seconds: 2));

    try {
      if (event.email.isEmpty || event.password.isEmpty) {
        emit(AuthLoginFailure('Email and password cannot be empty'));
        return;
      }

      if (event.password.length < 6) {
        emit(AuthLoginFailure('Password must be at least 6 characters'));
        return;
      }

      _authToken = 'token-${DateTime.now().millisecondsSinceEpoch}';
      _currentUser = UserModel(
        id: 'user-${DateTime.now().millisecondsSinceEpoch}',
        email: event.email,
      );

      emit(AuthLoginSuccess(_currentUser!));
      emit(AuthAuthenticated(_currentUser!));
    } catch (e) {
      emit(AuthLoginFailure('An unexpected error occurred'));
    }
  }

  Future<void> _onAuthRegisterStarted(
    AuthRegisterStarted event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthRegisterInProgress());

    await Future.delayed(const Duration(seconds: 2));

    try {
      if (event.email.isEmpty || event.password.isEmpty) {
        emit(AuthRegisterFailure('Email and password cannot be empty'));
        return;
      }

      if (event.password.length < 6) {
        emit(AuthRegisterFailure('Password must be at least 6 characters'));
        return;
      }

      _authToken = 'token-${DateTime.now().millisecondsSinceEpoch}';
      _currentUser = UserModel(
        id: 'user-${DateTime.now().millisecondsSinceEpoch}',
        email: event.email,
        username: event.username,
      );

      emit(AuthRegisterSuccess());
      emit(AuthAuthenticated(_currentUser!));
    } catch (e) {
      emit(AuthRegisterFailure('An unexpected error occurred'));
    }
  }

  Future<void> _onAuthLogoutStarted(
    AuthLogoutStarted event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLogoutSuccess());

    await Future.delayed(const Duration(milliseconds: 500));

    try {
      _authToken = null;
      _currentUser = null;
      emit(AuthUnauthenticated());
    } catch (e) {
      emit(AuthLogoutFailure('Failed to sign out'));
    }
  }
}
