import 'package:flutter/material.dart';

class CategoryScreen extends StatelessWidget {
  final String? category;

  const CategoryScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(category ?? 'All'),
      ),
      body: Center(
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
          ),
          itemCount: 6,
          itemBuilder: (context, index) {
            // You can replace this with your actual image loading logic
            return Container(
              color: Colors.grey[200],
              child: Center(
                child: Text('${category ?? 'All'} Photo ${index + 1}'),
              ),
            );
          },
        ),
      ),
    );
  }
}