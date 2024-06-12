import 'package:deaf_mute_system/authentication/firebase_auth_services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../controller/sos_screen.dart';
import 'login_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});
  static const String routeName = 'signup-screen';

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(35.0),
            child: Column(
              children: [
                Text(
                  'Sign Up',
                  style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 30),
                SignupForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SignupForm extends StatefulWidget {
  const SignupForm({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SignupFormState createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final FirebaseAuthService _auth = FirebaseAuthService();

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController birthDateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        buildTextField('First Name', firstNameController),
        buildTextField('Last Name', lastNameController),
        buildTextField('Email Address', emailController),
        buildTextField('Password', passwordController, isPassword: true),
        buildTextField('Confirm Password', confirmPasswordController,
            isPassword: true),
        buildTextField('Phone Number', phoneNumberController),
        buildTextField('Birth Date', birthDateController),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () {
            _signUp();
            // Navigator.pushReplacement(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => const SOSScreen(),
            //   ),
            // );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 144, 29, 29),
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          child: const Text(
            'Create Account',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.normal, // Make the text bold
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 15),
        Column(
          mainAxisAlignment: MainAxisAlignment.center, // Center the text
          children: [
            RichText(
              text: TextSpan(
                text: 'Already have an account? ',
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
                children: [
                  TextSpan(
                    text: 'Login',
                    style: const TextStyle(
                      color: Color.fromARGB(255, 144, 29, 29),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        // Handle the 'Login' click here
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                        );
                      },
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget buildTextField(String labelText, TextEditingController controller,
      {bool isPassword = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: SizedBox(
        width: double.infinity,
        child: TextField(
          controller: controller,
          obscureText: isPassword,
          maxLines: 1,
          minLines: 1,
          decoration: InputDecoration(
            labelText: labelText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
          ),
        ),
      ),
    );
  }

  void _signUp() async {
    String firstName = firstNameController.text;
    String lastname = lastNameController.text;
    String email = emailController.text;
    String password = passwordController.text;
    String confirm = confirmPasswordController.text;
    String phoneNumber = phoneNumberController.text;
    String birthDate = birthDateController.text;

    User? user = await _auth.SignUpWithEmailAndPassword(
        email, password, firstName, lastname, confirm, phoneNumber, birthDate);

    if (password == confirm) {
      if (user != null) {
        if (kDebugMode) {
          print('Account successfully created');
        }
        // ignore: use_build_context_synchronously
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const SOSScreen(),
          ),
        );
      } else {
        if (kDebugMode) {
          print('Some error occurred');
        }
      }
    } else {
      if (kDebugMode) {
        print('Some error occurred');
      }
    }
  }
}
