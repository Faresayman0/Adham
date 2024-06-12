import 'package:bloc/bloc.dart';

class EditProfileCubit extends Cubit<EditProfileState> {
  EditProfileCubit() : super(EditProfileState());

  void updateField({String? fullName, String? phone, String? address, String? birthdate, String? email}) {
    emit(state.copyWith(
      fullName: fullName ?? state.fullName,
      phone: phone ?? state.phone,
      address: address ?? state.address,
      birthdate: birthdate ?? state.birthdate,
      email: email ?? state.email,
    ));
  }

  void saveChanges() {
    // Implement your logic to save changes
  }
}

class EditProfileState {
  final String fullName;
  final String phone;
  final String address;
  final String birthdate;
  final String email;

  EditProfileState({
    this.fullName = 'Razan Alaa',
    this.phone = '0123456789',
    this.address = 'Mokktam Cairo city',
    this.birthdate = '25/10/2000',
    this.email = 'razan@gmail.com',
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
