part of 'profile_cubit.dart';

// profile_state.dart


class ProfileState extends Equatable {
  final int selectedIndex;

  const ProfileState({required this.selectedIndex});

  @override
  List<Object> get props => [selectedIndex];

  ProfileState copyWith({
    int? selectedIndex,
  }) {
    return ProfileState(
      selectedIndex: selectedIndex ?? this.selectedIndex,
    );
  }
}
