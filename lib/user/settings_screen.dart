import 'package:deaf_mute_system/controller/sos_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../authentication/login_screen.dart';
import '../gallery/gallery_screen.dart';
import '../profile/profile_screen.dart';
import 'change_password_screen.dart';
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  int _selectedIndex = 3; // Set the initial index for SettingsScreen
  bool isNotificationEnabled = true; // Initial notification state
  bool isDarkModeEnabled = false; // Initial dark mode state
  Language selectedLanguage = Language.english;

  Widget itemPSetting(String title, IconData iconData) {
    return Container(
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: Icon(iconData, color: const Color.fromARGB(255, 144, 29, 29)),
        trailing: _buildTrailingWidget(title),
      ),
    );
  }

  Widget _buildTrailingWidget(String title) {
    switch (title) {
      case 'Notification':
        return Switch(
          value: isNotificationEnabled,
          onChanged: (value) {
            setState(() {
              isNotificationEnabled = value;
            });
          },
          activeColor: const Color.fromARGB(255, 144, 29, 29),
        );
      case 'Password':
        return IconButton(
          icon: const Icon(Icons.arrow_forward,
              color: Color.fromARGB(255, 144, 29, 29)),
          onPressed: () {
            // Navigate to the ChangePasswordScreen
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ChangePasswordScreen(),
              ),
            );
          },
        );
      case 'Theme':
        return Switch(
          value: isDarkModeEnabled,
          onChanged: (value) {
            setState(() {
              isDarkModeEnabled = value;
            });
          },
          activeColor: const Color.fromARGB(255, 144, 29, 29),
        );
      case 'Language':
        return DropdownButton<Language>(
          value: selectedLanguage,
          items: const [
            DropdownMenuItem(
              value: Language.arabic,
              child: Text('Arabic'),
            ),
            DropdownMenuItem(
              value: Language.english,
              child: Text('English'),
            ),
          ],
          onChanged: (Language? value) {
            if (value != null) {
              setState(() {
                selectedLanguage = value;
              });
            }
          },
        );
      case 'Logout':
        return GestureDetector(
          onTap: () {
            FirebaseAuth.instance.signOut();
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const LoginScreen(),
              ),
            );
          },
          child: const Icon(
            Icons.arrow_forward,
            color: Color.fromARGB(255, 144, 29, 29),
          ),
        );

      default:
        return const Icon(Icons.arrow_forward,
            color: Color.fromARGB(255, 144, 29, 29));
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData currentTheme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: currentTheme.scaffoldBackgroundColor,
      ),
      body: Column(
        children: [
          itemPSetting('Theme', Icons.palette),
          itemPSetting('Password', Icons.lock),
          itemPSetting('Notification', Icons.notifications),
          itemPSetting('Language', Icons.language),
          itemPSetting('Logout', Icons.exit_to_app),
        ],
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
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;

              // Check the selected index and navigate accordingly
              switch (_selectedIndex) {
                case 0:
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SOSScreen(),
                    ),
                  );
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
                  // No need to navigate to SettingsScreen here, it will be displayed in the pages list
                  break;
              }
            });
            if (_selectedIndex == 4) {
              // Navigate to SignInScreen on Logout
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoginScreen(),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}

enum Language { arabic, english }
