import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Change Password'),
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Old Password Field
            buildTextField("Old Password", "", Icons.lock),

            // New Password Field
            buildTextField("New Password", "", Icons.lock),

            // Confirm New Password Field
            buildTextField("Confirm New Password", "", Icons.lock),

            const SizedBox(height: 40),

            // Change Password Button
            ElevatedButton(
              onPressed: () {
                // Implement your logic for changing the password
                if (kDebugMode) {
                  print('Change Password button clicked');
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 144, 29, 29),
                minimumSize: const Size(200, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
              child: const Text(
                'Change Password',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTextField(String labelText, String placeholder, IconData iconData) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30.0),
      child: TextField(
        obscureText: labelText.contains("Password"),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.only(bottom: 7),
          labelText: labelText,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          hintText: placeholder,
          hintStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          suffixIcon: Icon(
            iconData,
            color: const Color.fromARGB(255, 144, 29, 29),
          ),
        ),
      ),
    );
  }
}
