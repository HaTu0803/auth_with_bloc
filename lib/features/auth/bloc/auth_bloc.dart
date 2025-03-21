import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/user_model.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  // Mock user for demonstration
  UserModel? _currentUser;

  AuthBloc() : super(AuthInitial()) {
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<SignInRequested>(_onSignInRequested);
    on<SignUpRequested>(_onSignUpRequested);
    on<SignOutRequested>(_onSignOutRequested);
  }

  void _onAuthCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) {
    // Simulate checking for existing session
    if (_currentUser != null) {
      emit(Authenticated(_currentUser!));
    } else {
      emit(Unauthenticated());
    }
  }

  Future<void> _onSignInRequested(
    SignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    // Simulate API delay
    await Future.delayed(const Duration(seconds: 2));

    try {
      // Mock authentication logic
      if (event.email.isEmpty || event.password.isEmpty) {
        emit(AuthError('Email and password cannot be empty'));
        return;
      }

      if (!event.email.contains('@')) {
        emit(AuthError('Please enter a valid email'));
        return;
      }

      if (event.password.length < 6) {
        emit(AuthError('Password must be at least 6 characters'));
        return;
      }

      // Mock successful login
      _currentUser = UserModel(
        id: 'user-${DateTime.now().millisecondsSinceEpoch}',
        email: event.email,
      );

      emit(Authenticated(_currentUser!));
    } catch (e) {
      emit(AuthError('An unexpected error occurred'));
    }
  }

  Future<void> _onSignUpRequested(
    SignUpRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    // Simulate API delay
    await Future.delayed(const Duration(seconds: 2));

    try {
      // Mock registration logic
      if (event.email.isEmpty || event.password.isEmpty) {
        emit(AuthError('Email and password cannot be empty'));
        return;
      }

      if (!event.email.contains('@')) {
        emit(AuthError('Please enter a valid email'));
        return;
      }

      if (event.password.length < 6) {
        emit(AuthError('Password must be at least 6 characters'));
        return;
      }

      // Mock successful registration
      _currentUser = UserModel(
        id: 'user-${DateTime.now().millisecondsSinceEpoch}',
        email: event.email,
        username: event.username,
      );

      emit(Authenticated(_currentUser!));
    } catch (e) {
      emit(AuthError('An unexpected error occurred'));
    }
  }

  Future<void> _onSignOutRequested(
    SignOutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 500));

    try {
      // Mock sign out
      _currentUser = null;
      emit(Unauthenticated());
    } catch (e) {
      emit(AuthError('Failed to sign out'));
    }
  }
}
