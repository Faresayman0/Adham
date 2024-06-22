import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart';  // Add this import for date formatting

class AvailableCarsPage extends StatefulWidget {
  const AvailableCarsPage({Key? key}) : super(key: key);

  @override
  _AvailableCarsPageState createState() => _AvailableCarsPageState();
}

class _AvailableCarsPageState extends State<AvailableCarsPage> {
  List<String> selectedMinistries = [];
  final List<String> ministries = [
    'CivilProtection',
    'Health',
    'Interior',
    'NAS'
  ];

  Future<Map<String, List<Map<String, dynamic>>>> _fetchAvailableCars() async {
    Map<String, List<Map<String, dynamic>>> vehicles = {};

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
          'location': data['location'] ?? GeoPoint(0, 0),
        };
      }).toList();
    }
    return vehicles;
  }

  void _openMap(GeoPoint location) async {
    final Uri url = Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=${location.latitude},${location.longitude}');
    if (await canLaunch(url.toString())) {
      await launch(url.toString());
    } else {
      throw 'Could not launch $url';
    }
  }

  void _printLocation(GeoPoint location) {
    print('Location: ${location.latitude}, ${location.longitude}');
  }

  Widget _buildPieChart(
      int count, String status, Color color, int totalReports) {
    double emptySpace =
        totalReports > 0 ? (totalReports - count).toDouble() : 0;
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

 Future<void> _printReport(BuildContext context, List<String> ministriesToPrint) async {
  Map<String, List<Map<String, dynamic>>> vehicles = await _fetchAvailableCars();
  final pdf = pw.Document();
  String currentDateTime = DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now());

  final image = pw.MemoryImage(
    (await rootBundle.load('assets/logo.png')).buffer.asUint8List(),
  );

  for (String ministry in ministriesToPrint) {
    if (vehicles.containsKey(ministry)) {
      List<Map<String, dynamic>> cars = vehicles[ministry]!;

      pdf.addPage(
        pw.MultiPage(
          build: (context) => [
            pw.Container(
              width: double.infinity,
              child: pw.Image(image, fit: pw.BoxFit.fitWidth),
            ),
            pw.SizedBox(height: 10),
            pw.Header(level: 0, child: pw.Text('All Cars Report - $ministry')),
            pw.Table.fromTextArray(
              headers: [
                'Plate Number',
                'Availability',
                'On Mission',
              ],
              data: cars.map((car) {
                return [
                  car['plate_number'],
                  car['available'] ? 'Available' : 'Not Available',
                  car['onMission'] ? 'Yes' : 'No',
                ];
              }).toList(),
              cellAlignment: pw.Alignment.center,
            ),
          ],
          footer: (context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text('Signature: (____________________)', style: pw.TextStyle(fontSize: 18)),
                pw.Text('Printed on: $currentDateTime', style: pw.TextStyle(fontSize: 12)),
                pw.Align(
                  alignment: pw.Alignment.centerRight,
                  child: pw.Text(
                    'Page ${context.pageNumber} of ${context.pagesCount}',
                    style: pw.TextStyle(fontSize: 12),
                  ),
                ),
              ],
            );
          },
        ),
      );
    }
  }

  await Printing.layoutPdf(
    onLayout: (format) async => pdf.save(),
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Available Cars'),
      ),
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
              for (var car in cars) {
                if (car['available']) {
                  totalAvailable++;
                } else {
                  totalUnavailable++;
                }
              }
            });

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Available Cars Summary',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 16.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildPieChart(totalAvailable, 'Available', Colors.green,
                            totalAvailable + totalUnavailable),
                        _buildPieChart(totalUnavailable, 'Unavailable',
                            Colors.red, totalAvailable + totalUnavailable),
                      ],
                    ),
                    SizedBox(height: 16.0),
                    Text(
                      'Details by Ministry',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 16.0),
                    ListView(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      children: vehicles.entries.map((entry) {
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
                                DataColumn(label: Text('Location')),
                              ],
                              rows: cars.map((car) {
                                return DataRow(cells: [
                                  DataCell(Text(car['plate_number'])),
                                  DataCell(Text(car['available']
                                      ? 'Available'
                                      : 'Not Available')),
                                  DataCell(Center(
                                      child: Text(car['onMission']
                                          ? 'Yes'
                                          : 'No'))),
                                  DataCell(IconButton(
                                    icon: const Icon(Icons.location_on),
                                    onPressed: () {
                                      _openMap(car['location']);
                                      _printLocation(car['location']);
                                    },
                                  )),
                                ]);
                              }).toList(),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 16.0),
                              child: ElevatedButton(
                                onPressed: () {
                                  _printReport(context, [ministry]);
                                },
                                child: Text('Print $ministry Report'),
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                    SizedBox(height: 16.0),
                    Text(
                      'Select Ministries to Print',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 16.0),
                    Column(
                      children: ministries.map((ministry) {
                        return CheckboxListTile(
                          title: Text(ministry),
                          value: selectedMinistries.contains(ministry),
                          onChanged: (bool? value) {
                            setState(() {
                              if (value == true) {
                                selectedMinistries.add(ministry);
                              } else {
                                selectedMinistries.remove(ministry);
                              }
                            });
                          },
                        );
                      }).toList(),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Center(
                        child: ElevatedButton(
                          onPressed: () {
                            _printReport(context, selectedMinistries);
                          },
                          child: const Text('Print Selected Reports'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
