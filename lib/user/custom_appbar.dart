import 'package:deaf_mute_system/user/appbar_clipper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'category_screen.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120.0,
      child: ClipPath(
        clipper: AppBarClipper(),
        child: Container(
          color: const Color.fromARGB(255, 144, 29, 29),
          padding: const EdgeInsets.all(16.0),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              CustomAppBarButton(label: 'All', category: 'All'),
              CustomAppBarButton(label: 'Books', category: 'Books'),
              CustomAppBarButton(label: 'Reference', category: 'Reference'),
              CustomAppBarButton(label: 'Others', category: 'Others'),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomAppBarButton extends StatelessWidget {
  final String label;
  final String? category;

  const CustomAppBarButton({super.key, required this.label, required this.category});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // Add your logic for each button click
        if (kDebugMode) {
          print('$label button clicked');
        }
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CategoryScreen(category: category),
          ),
        );
      },
      style: ElevatedButton.styleFrom(
        foregroundColor: const Color.fromARGB(255, 144, 29, 29), backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Color.fromARGB(255, 144, 29, 29),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}