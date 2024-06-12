class EditProfileState {
  final String fullName;
  final String phone;
  final String address;
  final String birthdate;
  final String email;

  EditProfileState({
    this.fullName = '',
    this.phone = '',
    this.address = '',
    this.birthdate = '',
    this.email = '',
  });

  EditProfileState copyWith({
    String? fullName,
    String? phone,
    String? address,
    String? birthdate,
    String? email,
  }) {
    return EditProfileState(
      fullName: fullName ?? this.fullName,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      birthdate: birthdate ?? this.birthdate,
      email: email ?? this.email,
    );
  }
}
