import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:deaf_mute_system/user/settings_screen.dart';
import 'package:flutter/material.dart';
import '../authentication/login_screen.dart';
import '../authentication/signup_screen.dart';
import 'scan_controller.dart';
import '../gallery/gallery_screen.dart';
import '../profile/profile_screen.dart';


class SOSScreen extends StatefulWidget {
  const SOSScreen({Key? key}) : super(key: key);
  static const String routeName = 'sos-screen';

  @override
  State<SOSScreen> createState() => _SOSScreenState();
}

class _SOSScreenState extends State<SOSScreen> {
  int _selectedIndex = 3;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(scaffoldBackgroundColor: Colors.white),
      home: SafeArea(
        child: Scaffold(
          body: GetBuilder<ScanController>(
            init: ScanController(),
            builder: (controller) {
              return Stack(
                children: [
                  controller.isCameraInitialized.value
                      ? SizedBox(
                          width: size.width,
                          height: size.height,
                          child: FittedBox(
                            fit: BoxFit.cover,
                            child: SizedBox(
                              width: 100,
                              child: CameraPreview(
                                controller.cameraController,
                              ),
                            ),
                          ),
                        )
                      : const Center(child: CircularProgressIndicator()),
                  Positioned(
                    top: 20.0,
                    right: 20.0,
                    child: GestureDetector(
                      onTap: () {
                        if (kDebugMode) {
                          print("Help button tapped");
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          color: const Color(0xffC40915),
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: const Text(
                          "Help",
                          style: TextStyle(
                            fontSize: 17.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 20.0,
                    left: 20.0,
                    child: GestureDetector(
                      onTap: () {
                        //toggleCamera();
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          color: const Color(0xffC40915),
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: const Icon(
                          Icons.switch_camera,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
          bottomNavigationBar: BottomNavigationBar(
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
                switch (_selectedIndex) {
                  case 0:
                    // No need to navigate to SosScreen here, it is already on the SOS tab
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
                  case 4: // Added for login screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    );
                    break;
                  case 5: // Added for signup screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SignupScreen(),
                      ),
                    );
                    break;
                }
              });
            },
          ),
        ),
      ),
    );
  }
}