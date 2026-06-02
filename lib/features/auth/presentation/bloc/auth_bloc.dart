import 'package:contactando/core/utils/use_case.dart';
import 'package:contactando/features/auth/domain/repositories/auth_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/sign_in_usecase.dart';
import '../../domain/usecases/sign_out_usecase.dart';

part 'auth_event.dart';
part 'auth_state.dart';

@injectable
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({
    required SignInUseCase signIn,
    required SignOutUseCase signOut,
    required AuthRepository authRepository,
  })  : _signIn = signIn,
        _signOut = signOut,
        _authRepository = authRepository,
        super(const AuthInitial()) {
    on<AuthSignInRequested>(_onSignIn);
    on<AuthSignOutRequested>(_onSignOut);
  }

  final SignInUseCase _signIn;
  final SignOutUseCase _signOut;
  final AuthRepository _authRepository;

  Future<void> _onSignIn(
    AuthSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    final result = await _signIn(
      LoginParam(email: event.email, password: event.password)
    );

    if (result.isLeft()) {
      final failure = result.getLeft().toNullable()!;
      emit(AuthError(failure.message));
    } else {
      final user = result.getRight().toNullable()!;
      await _authRepository.saveLoginTimestamp();
      emit(AuthAuthenticated(user));
    }
  }

  Future<void> _onSignOut(
    AuthSignOutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    final result = await _signOut(
      NoParams()
    );

    if (result.isLeft()) {
      final failure = result.getLeft().toNullable()!;
      emit(AuthError(failure.message));
    } else {
      await _authRepository.clearLoginTimestamp();
      emit(const AuthUnauthenticated());
    }
  }

}
