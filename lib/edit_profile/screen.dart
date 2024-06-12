import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cubit.dart';
//import 'profile_screen.dart';

class EditProfileScreen extends StatelessWidget {
  static const String routeName = 'edit-profile-screen';

  const EditProfileScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EditProfileCubit(),
      child: const EditProfileScreenContent(),
    );
  }
}

class EditProfileScreenContent extends StatelessWidget {
  const EditProfileScreenContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  // Add your logic to change the photo
                  if (kDebugMode) {
                    print('Change Photo button clicked');
                  }
                },
                child: const CircleAvatar(
                  radius: 70,
                  backgroundImage: NetworkImage(
                      'https://cdn.vectorstock.com/i/1000x1000/73/15/female-avatar-profile-icon-round-woman-face-vector-18307315.webp'),
                  child: Icon(
                    Icons.camera_alt,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ),
              BlocBuilder<EditProfileCubit, EditProfileState>(
                builder: (context, state) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 15),
                      buildLabeledTextField(
                        "Full Name",
                        state.fullName,
                        Icons.person,
                        onChanged: (value) =>
                            context.read<EditProfileCubit>().updateField(fullName: value),
                      ),
                      buildLabeledTextField(
                        "Phone",
                        state.phone,
                        Icons.phone,
                        onChanged: (value) =>
                            context.read<EditProfileCubit>().updateField(phone: value),
                      ),
                      buildLabeledTextField(
                        "Address",
                        state.address,
                        Icons.location_on,
                        onChanged: (value) =>
                            context.read<EditProfileCubit>().updateField(address: value),
                      ),
                      buildLabeledTextField(
                        "Birthdate",
                        state.birthdate,
                        Icons.calendar_today,
                        onChanged: (value) =>
                            context.read<EditProfileCubit>().updateField(birthdate: value),
                      ),
                      buildLabeledTextField(
                        "Email",
                        state.email,
                        Icons.mail,
                        onChanged: (value) =>
                            context.read<EditProfileCubit>().updateField(email: value),
                      ),
                      const SizedBox(height: 15),
                      ElevatedButton(
                        onPressed: () {
                          // Save changes and navigate to the ProfileScreen
                          context.read<EditProfileCubit>().saveChanges();
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => ProfileScreen(),
                          //   ),
                          // );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 144, 29, 29),
                          minimumSize: const Size(50, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                        child: const Text(
                          'Save Change ',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildLabeledTextField(
    String labelText,
    String placeholder,
    IconData iconData, {
    required void Function(String) onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 0.5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            labelText,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 1),
          TextField(
            onChanged: onChanged,
            decoration: InputDecoration(
              hintText: placeholder,
              hintStyle: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              suffixIcon: Icon(
                iconData,
                color: const Color.fromARGB(255, 144, 29, 29),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25.0),
                borderSide: const BorderSide(
                  color: Color.fromARGB(255, 144, 29, 29),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25.0),
                borderSide: const BorderSide(
                  color: Color.fromARGB(255, 144, 29, 29),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
