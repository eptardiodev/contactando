part of 'profile_bloc.dart';

sealed class ProfileState extends Equatable {
  const ProfileState();
  @override
  List<Object?> get props => [];
}

final class ProfileInitial extends ProfileState {
  const ProfileInitial();
}

final class ProfileLoading extends ProfileState {
  const ProfileLoading();
}

final class ProfileLoaded extends ProfileState {
  const ProfileLoaded(this.profile, {this.successMessage});
  final ProfileEntity profile;
  final String? successMessage;
  @override
  List<Object?> get props => [profile, successMessage];
}

final class ProfileUpdating extends ProfileState {
  const ProfileUpdating(this.profile);
  final ProfileEntity? profile;
  @override
  List<Object?> get props => [profile];
}

final class ProfileError extends ProfileState {
  const ProfileError(this.message, {this.previous});
  final String message;
  final ProfileEntity? previous;
  @override
  List<Object?> get props => [message, previous];
}