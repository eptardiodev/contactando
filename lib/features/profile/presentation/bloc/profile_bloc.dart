import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/profile_entity.dart';
import '../../domain/usecases/profile_usecases.dart';

part 'profile_event.dart';
part 'profile_state.dart';

@injectable
class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc({
    required GetProfileUseCase getProfile,
    required UpdateProfileUseCase updateProfile,
  })  : _getProfile = getProfile,
        _updateProfile = updateProfile,
        super(const ProfileInitial()) {
    on<ProfileLoadRequested>(_onLoad);
    on<ProfileUpdateRequested>(_onUpdate);
  }

  final GetProfileUseCase _getProfile;
  final UpdateProfileUseCase _updateProfile;

  Future<void> _onLoad(
      ProfileLoadRequested event,
      Emitter<ProfileState> emit,
      ) async {
    emit(const ProfileLoading());
    final result = await _getProfile(GetProfileParams(userId: event.userId));
    result.fold(
          (failure) => emit(ProfileError(failure.message)),
          (profile) => emit(ProfileLoaded(profile)),
    );
  }

  Future<void> _onUpdate(
      ProfileUpdateRequested event,
      Emitter<ProfileState> emit,
      ) async {
    // Mantener perfil visible mientras actualiza
    final current = state is ProfileLoaded
        ? (state as ProfileLoaded).profile
        : null;
    emit(ProfileUpdating(current));

    final result = await _updateProfile(
      UpdateProfileParams(profile: event.profile),
    );
    result.fold(
          (failure) => emit(ProfileError(failure.message, previous: current)),
          (updated) => emit(ProfileLoaded(
        updated,
        successMessage: 'Perfil actualizado exitosamente',
      )),
    );
  }
}