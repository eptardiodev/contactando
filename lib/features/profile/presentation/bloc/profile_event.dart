part of 'profile_bloc.dart';

sealed class ProfileEvent extends Equatable {
  const ProfileEvent();
  @override
  List<Object?> get props => [];
}

final class ProfileLoadRequested extends ProfileEvent {
  const ProfileLoadRequested(this.userId);
  final String userId;
  @override
  List<Object?> get props => [userId];
}

final class ProfileUpdateRequested extends ProfileEvent {
  const ProfileUpdateRequested(this.profile);
  final ProfileEntity profile;
  @override
  List<Object?> get props => [profile];
}