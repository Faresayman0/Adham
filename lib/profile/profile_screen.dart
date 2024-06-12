import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../gallery/gallery_screen.dart';
import '../user/settings_screen.dart';
import 'profile_cubit.dart';
import 'package:deaf_mute_system/edit_profile/screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  static const String routeName = 'profile-screen';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileCubit(),
      child: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          return _buildProfileScreen(context, state);
        },
      ),
    );
  }

  Widget _buildProfileScreen(BuildContext context, ProfileState state) {
    int selectedIndex = 3;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
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
              const CircleAvatar(
                radius: 70,
                backgroundImage: NetworkImage(
                    'https://cdn.vectorstock.com/i/1000x1000/73/15/female-avatar-profile-icon-round-woman-face-vector-18307315.webp'),
              ),
              const SizedBox(height: 20),
              itemProfile('Name', 'Razan Alaa', Icons.person),
              const SizedBox(height: 10),
              itemProfile('Phone', '0123456789', Icons.phone),
              const SizedBox(height: 10),
              itemProfile('Address', 'Mokktam, Cairo city', Icons.location_on),
              const SizedBox(height: 10),
              itemProfile('Birthdate', '25/10/2000', Icons.calendar_today),
              const SizedBox(height: 10),
              itemProfile('Email', 'razan@gmail.com', Icons.mail),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  // Navigate to the EditProfileScreen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const EditProfileScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 144, 29, 29),
                  minimumSize: const Size(200, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                child: const Text(
                  'Edit profile',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30.0),
          topRight: Radius.circular(30.0),
        ),
        child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: const Color.fromARGB(255, 144, 29, 29),
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.camera_alt),
                label: 'SOS',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.drive_file_move_rounded),
                label: 'Gallery',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                label: 'Settings',
              ),
            ],
            currentIndex: state.selectedIndex,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.white,
            onTap: (index) {
              context.read<ProfileCubit>().updateIndex(index);
              selectedIndex = index;

              // Check the selected index and navigate accordingly
              switch (selectedIndex) {
                case 0:
                  // No need to navigate to SettingsScreen here, it will be displayed in the pages list
                  break;
                case 1:
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProfileScreen(),
                    ),
                  );
                  break;
                case 2:
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const GalleryScreen(),
                    ),
                  );
                  break;
                case 3:
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SettingsScreen(),
                    ),
                  );
                  break;
              }
            }),
      ),
    );
  }

  Widget itemProfile(String title, String subtitle, IconData iconData) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        title: Text(title),
        subtitle: Text(subtitle),
        leading: Icon(iconData, color: const Color.fromARGB(255, 144, 29, 29)),
        tileColor: Colors.white,
      ),
    );
  }
}
