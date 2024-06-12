import 'package:flutter/material.dart';

class DisplayReportScreen extends StatelessWidget {
  final List<Map<String, dynamic>> reportData;

  const DisplayReportScreen({
    Key? key,
    required this.reportData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int numberOfReports = reportData.length;

    return Scaffold(
      appBar: AppBar(
        title: Text('Report Details - $numberOfReports Reports'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: reportData.map((data) {
              return Column(
                children: [
                  Text(
                    'Name: ${data['name']}',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Gender: ${data['gender']}',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Query: ${data['selectQuery']}',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Follower Name: ${data['followerName']}',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Date: ${data['date'].toString()}',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 10),Text(
                    'description: ${data['description']}',
                    style: const TextStyle(fontSize: 18),
                  ),   const SizedBox(height: 10),
                  Text(
                    'Comment: ${data['comment']}',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Age: ${data['age']}',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const Divider(),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
