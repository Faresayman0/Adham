import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:fl_chart/fl_chart.dart';

class AvailableCarsPage extends StatelessWidget {
  const AvailableCarsPage({Key? key}) : super(key: key);

  Future<Map<String, List<Map<String, dynamic>>>> _fetchAvailableCars() async {
    Map<String, List<Map<String, dynamic>>> vehicles = {};
    List<String> ministries = ['CivilProtection', 'Health', 'Interior', 'NAS'];

    for (String ministry in ministries) {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('Ministries')
          .doc(ministry)
          .collection('vehicles')
          .get();

      vehicles[ministry] = snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return {
          'plate_number': data['plate_number'] ?? 'Unknown',
          'available': data['available'] ?? false,
          'onMission': data['onMission'] ?? false,
          'location': data['location'] ?? GeoPoint(0, 0), // Add the 'location' field and default GeoPoint
        };
      }).toList();
    }
    return vehicles;
  }

  void _openMap(GeoPoint location) async {
    final Uri url = Uri.parse('https://www.google.com/maps/search/?api=1&query=${location.latitude},${location.longitude}');
    if (await canLaunch(url.toString())) {
      await launch(url.toString());
    } else {
      throw 'Could not launch $url';
    }
  }

  void _printLocation(GeoPoint location) {
    print('Location: ${location.latitude}, ${location.longitude}');
  }

  Widget _buildPieChart(int count, String status, Color color, int totalReports) {
    double emptySpace = totalReports > 0 ? (totalReports - count).toDouble() : 0;
    return SizedBox(
      width: 150,
      height: 150,
      child: Stack(
        alignment: Alignment.center,
        children: [
          PieChart(
            PieChartData(
              sections: [
                PieChartSectionData(
                  color: color,
                  value: count.toDouble(),
                  showTitle: false,
                  radius: 10,
                ),
                PieChartSectionData(
                  color: Colors.grey.shade300,
                  value: emptySpace,
                  showTitle: false,
                  radius: 10,
                ),
              ],
              sectionsSpace: 1,
              centerSpaceRadius: 50,
            ),
          ),
          Text(
            '$status\n$count',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Available Cars')),
      body: FutureBuilder<Map<String, List<Map<String, dynamic>>>>(
        future: _fetchAvailableCars(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error loading data'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No data available'));
          } else {
            Map<String, List<Map<String, dynamic>>> vehicles = snapshot.data!;
            int totalAvailable = 0;
            int totalUnavailable = 0;
            vehicles.forEach((_, cars) {
              cars.forEach((car) {
                if (car['available']) {
                  totalAvailable++;
                } else {
                  totalUnavailable++;
                }
              });
            });

            return ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildPieChart(totalAvailable, 'Available', Colors.green, totalAvailable + totalUnavailable),
                      _buildPieChart(totalUnavailable, 'Unavailable', Colors.red, totalAvailable + totalUnavailable),
                    ],
                  ),
                ),
                ...vehicles.entries.map((entry) {
                  String ministry = entry.key;
                  List<Map<String, dynamic>> cars = entry.value;
                  return ExpansionTile(
                    title: Text(ministry),
                    children: [
                      DataTable(
                        columnSpacing: 10,
                        columns: const [
                          DataColumn(label: Text('Plate Number')),
                          DataColumn(label: Text('Availability')),
                          DataColumn(label: Text('On Mission')),
                          DataColumn(label: Text('Location')), // Add the 'Location' column
                        ],
                        rows: cars.map((car) {
                          return DataRow(cells: [
                            DataCell(Text(car['plate_number'])),
                            DataCell(Text(car['available'] ? 'Available' : 'Not Available')),
                            DataCell(Center(child: Text(car['onMission'] ? 'Yes' : 'No'))), // Center align the 'onMission' cell
                            DataCell(IconButton(
                              icon: Icon(Icons.location_on),
                              onPressed: () {
                                _openMap(car['location']);
                                _printLocation(car['location']);
                              },
                            )), // Add the 'Location' cell with icon button
                          ]);
                        }).toList(),
                      ),
                    ],
                  );
                }).toList(),
              ],
            );
          }
        },
      ),
    );
  }
}
