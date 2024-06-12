import 'dart:io';

import 'package:deaf_mute_system/manager/widgets/radio_widget.dart';
import 'package:deaf_mute_system/report/print_repoet.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({Key? key}) : super(key: key);

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  late DateTime _selectedFromDate;
  late DateTime _selectedToDate;
  bool _isToday = true;
  String? _selectedQuery;

  @override
  void initState() {
    super.initState();
    DateTime now = DateTime.now();
    _selectedFromDate = DateTime(now.year, now.month, now.day); // بداية اليوم
    _selectedToDate =
        DateTime(now.year, now.month, now.day, 23, 59, 59); // نهاية اليوم
  }

  Future<void> _selectFromDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedFromDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedFromDate) {
      setState(() {
        _selectedFromDate = picked;
      });
    }
  }

  Future<void> _selectToDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedToDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedToDate) {
      setState(() {
        _selectedToDate = picked;
      });
    }
  }

  void _toggleDateRange() {
    setState(() {
      _isToday = !_isToday;
      if (_isToday) {
        _selectedFromDate = DateTime.now();
        _selectedToDate = DateTime.now();
      } else {
        _selectedFromDate = DateTime.now().subtract(const Duration(days: 1));
        _selectedToDate = DateTime.now().subtract(const Duration(days: 1));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title: const Text(
          "Reports",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 10),
              const Text(
                "Pick date",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff1384A9),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                ),
                onPressed: _toggleDateRange,
                icon: Icon(
                  _isToday ? Icons.arrow_back_ios : Icons.arrow_back_ios,
                  color: Colors.black,
                ),
                label: Text(
                  _isToday ? 'Today' : 'Yesterday',
                  style: const TextStyle(color: Colors.black),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Or select date",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff1384A9)),
                    onPressed: () => _selectFromDate(context),
                    child: Text(
                      "From ${_selectedFromDate.day}/${_selectedFromDate.month}/${_selectedFromDate.year}",
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff1384A9)),
                    onPressed: () => _selectToDate(context),
                    child: Text(
                      "To ${_selectedToDate.day}/${_selectedToDate.month}/${_selectedToDate.year}",
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                "Select Report",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Center(
                child: Column(
                  children: [
                    CustomRadioWidget(
                      groupValue: _selectedQuery,
                      onChange: (value) {
                        setState(() {
                          _selectedQuery = value;
                        });
                      },
                      selectText:
                          "Emergency Medical Response\n Dispatch Report",
                      value: "Emergency Medical Response Dispatch Report",
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    CustomRadioWidget(
                      groupValue: _selectedQuery,
                      onChange: (value) {
                        setState(() {
                          _selectedQuery = value;
                        });
                      },
                      selectText: "Emergency Fire Response\n Dispatch Report",
                      value: "Emergency Fire Response Dispatch Report",
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    CustomRadioWidget(
                      groupValue: _selectedQuery,
                      onChange: (value) {
                        setState(() {
                          _selectedQuery = value;
                        });
                      },
                      selectText: "Emergency Police Response\n Dispatch Report",
                      value: "Emergency Police Response Dispatch Report",
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    CustomRadioWidget(
                      groupValue: _selectedQuery,
                      onChange: (value) {
                        setState(() {
                          _selectedQuery = value;
                        });
                      },
                      selectText: "NAS Report",
                      value: "NAS Report",
                    ),
                    CustomRadioWidget(
                      groupValue: _selectedQuery,
                      onChange: (value) {
                        setState(() {
                          _selectedQuery = value;
                        });
                      },
                      selectText: "Number of Failed Cases Report",
                      value: "Number For Failure Report",
                    ),
                    CustomRadioWidget(
                      groupValue: _selectedQuery,
                      onChange: (value) {
                        setState(() {
                          _selectedQuery = value;
                        });
                      },
                      selectText: "Number of Completed Cases Report",
                      value: "Number For Completed Report",
                    ),
                    CustomRadioWidget(
                      groupValue: _selectedQuery,
                      onChange: (value) {
                        setState(() {
                          _selectedQuery = value;
                        });
                      },
                      selectText: "Number for all cases",
                      value: "Number for all cases",
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 60,
              ),
            ],
          ),
        ),
      ),
      bottomSheet: Builder(
        builder: (BuildContext context) {
          return BottomSheet(
            onClosing: () {}, // لا يوجد شيء يمكن أن يغلق هنا
            builder: (BuildContext context) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                ),
                color: Colors.grey[200],
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff1384A9)),
                      onPressed: printDataForSelectedDateRangeAndQuery,
                      child: const Text(
                        "Print Report",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff1384A9)),
                      onPressed: fetchDataAndDisplay,
                      child: const Text(
                        "show Report",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff1384A9)),
                      onPressed: shareDataAsPDF,
                      child: const Text(
                        "share Report",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  void fetchDataAndDisplay() async {
    if (_selectedQuery == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a query option.')));
      return;
    }

    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference collection = firestore.collection("report");

    Timestamp startOfTheRange = Timestamp.fromDate(_selectedFromDate);
    Timestamp endOfTheRange = Timestamp.fromDate(_selectedToDate);

    try {
      QuerySnapshot querySnapshot = await collection
          .where("selectQuery", isEqualTo: _selectedQuery)
          .where("date", isGreaterThanOrEqualTo: startOfTheRange)
          .where("date", isLessThanOrEqualTo: endOfTheRange)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        List<Map<String, dynamic>> reportData = querySnapshot.docs
            .map((doc) => {
                  "name": doc['name'],
                  "gender": doc['gender'],
                  "selectQuery": doc['selectQuery'],
                  "followerName": doc['followerName'],
                  "date": (doc['date'] as Timestamp).toDate(),
                  "comment": doc['comment'],
                  "age": doc['age'],
                })
            .toList();

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DisplayReportScreen(reportData: reportData),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('No data found for the selected period')));
      }
    } catch (e) {
      print('Error fetching data: $e');
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error fetching data: $e')));
    }
  }

  Future<void> shareDataAsPDF() async {
    if (_selectedQuery == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a report option.')));
      return;
    }

    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference collection = firestore.collection("report");

    Timestamp startOfTheRange = Timestamp.fromDate(_selectedFromDate);
    Timestamp endOfTheRange = Timestamp.fromDate(_selectedToDate);

    try {
      QuerySnapshot querySnapshot = await collection
          .where("date", isGreaterThanOrEqualTo: startOfTheRange)
          .where("date", isLessThanOrEqualTo: endOfTheRange)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final logoImage = await _loadImage(); // Loading the logo
        final pdf = pw.Document();
        final totalReports = querySnapshot.docs.length;
        int failedReports = querySnapshot.docs
            .where((doc) => doc['status'] == 'cancelled')
            .length;
        int completedReports =
            querySnapshot.docs.where((doc) => doc['status'] == 'accept').length;

        // Check which type of report to generate
        switch (_selectedQuery) {
          case "Number for all cases":
            pdf.addPage(pw.Page(
                build: (pw.Context context) => createReportPage(
                        context, logoImage, "Number for all cases", [
                      pw.Column(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
                        children: [
                          pw.Row(
                            mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
                            children: [
                              reportDetails(totalReports, "Total Reports"),
                              pw.SizedBox(width: 50),
                              reportDetails(
                                  completedReports, "Completed Reports")
                            ],
                          ),
                          pw.SizedBox(height: 20),
                          reportDetails(failedReports, "Failed Reports")
                        ],
                      )
                    ])));
            break;
          case "Number For Failure Report":
            pdf.addPage(pw.Page(
                build: (pw.Context context) => createReportPage(
                        context, logoImage, "Number for Failure Reports", [
                      reportDetails(totalReports, "Total Reports"),
                      reportDetails(failedReports, "Failed Reports")
                    ])));
            break;
          case "Number For Completed Report":
            pdf.addPage(pw.Page(
                build: (pw.Context context) => createReportPage(
                        context, logoImage, "Number for Completed Reports", [
                      reportDetails(totalReports, "Total Reports"),
                      reportDetails(completedReports, "Completed Reports")
                    ])));
            break;
          default:
            // Generate default reports for any other query type
            List<QueryDocumentSnapshot> filteredDocs = querySnapshot.docs
                .where((doc) => doc['selectQuery'] == _selectedQuery)
                .toList();

            if (filteredDocs.isNotEmpty) {
              for (var doc in filteredDocs) {
                Map<String, dynamic> docData =
                    doc.data() as Map<String, dynamic>;
                DateTime caseDate = (doc['date'] as Timestamp).toDate();
                pdf.addPage(pw.Page(
                    build: (pw.Context context) => createDefaultReportPage(
                        context,
                        logoImage,
                        docData,
                        caseDate,
                        filteredDocs.indexOf(doc) +
                            1, // Update index to start from 1
                        filteredDocs
                            .length, // Use filteredDocs.length as totalPages
                        _selectedQuery!)));
              }
            } else {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('No data found for the selected query.')));
              return; // Exit function if no data found
            }
        }

        // Save the PDF and share it
        final bytes = await pdf.save();
        await Printing.sharePdf(bytes: bytes, filename: 'report.pdf');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No data found for this period.')));
      }
    } catch (e) {
      print('Error fetching data: $e');
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error fetching data: $e')));
    }
  }

  void printDataForSelectedDateRangeAndQuery() async {
    if (_selectedQuery == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a report option.')));
      return;
    }

    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference collection = firestore.collection("report");

    Timestamp startOfTheRange = Timestamp.fromDate(_selectedFromDate);
    Timestamp endOfTheRange = Timestamp.fromDate(_selectedToDate);

    try {
      QuerySnapshot querySnapshot = await collection
          .where("date", isGreaterThanOrEqualTo: startOfTheRange)
          .where("date", isLessThanOrEqualTo: endOfTheRange)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final logoImage = await _loadImage(); // Loading the logo
        final pdf = pw.Document();
        final totalReports = querySnapshot.docs.length;
        int failedReports = querySnapshot.docs
            .where((doc) => doc['status'] == 'cancelled')
            .length;
        int completedReports =
            querySnapshot.docs.where((doc) => doc['status'] == 'accept').length;

        // Check which type of report to generate
        switch (_selectedQuery) {
          case "Number for all cases":
            pdf.addPage(pw.Page(
                build: (pw.Context context) => createReportPage(
                        context, logoImage, "Number for all cases", [
                      pw.Column(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
                        children: [
                          pw.Row(
                            mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
                            children: [
                              reportDetails(totalReports, "Total Reports"),
                              pw.SizedBox(width: 50),
                              reportDetails(
                                  completedReports, "Completed Reports")
                            ],
                          ),
                          pw.SizedBox(height: 20),
                          reportDetails(failedReports, "Failed Reports")
                        ],
                      )
                    ])));
            break;
          case "Number For Failure Report":
            pdf.addPage(pw.Page(
                build: (pw.Context context) => createReportPage(
                        context, logoImage, "Number for Failure Reports", [
                      reportDetails(totalReports, "Total Reports"),
                      reportDetails(failedReports, "Failed Reports")
                    ])));
            break;
          case "Number For Completed Report":
            pdf.addPage(pw.Page(
                build: (pw.Context context) => createReportPage(
                        context, logoImage, "Number for Completed Reports", [
                      reportDetails(totalReports, "Total Reports"),
                      reportDetails(completedReports, "Completed Reports")
                    ])));
            break;
          default:
            // Generate default reports for any other query type
            List<QueryDocumentSnapshot> filteredDocs = querySnapshot.docs
                .where((doc) => doc['selectQuery'] == _selectedQuery)
                .toList();

            if (filteredDocs.isNotEmpty) {
              for (var doc in filteredDocs) {
                Map<String, dynamic> docData =
                    doc.data() as Map<String, dynamic>;
                DateTime caseDate = (doc['date'] as Timestamp).toDate();
                pdf.addPage(pw.Page(
                    build: (pw.Context context) => createDefaultReportPage(
                        context,
                        logoImage,
                        docData,
                        caseDate,
                        filteredDocs.indexOf(doc) +
                            1, // Update index to start from 1
                        filteredDocs
                            .length, // Use filteredDocs.length as totalPages
                        _selectedQuery!)));
              }
            } else {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('No data found for the selected query.')));
              return; // Exit function if no data found
            }
        }

        await Printing.layoutPdf(
            onLayout: (PdfPageFormat format) async => pdf.save());
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No data found for this period.')));
      }
    } catch (e) {
      print('Error fetching data: $e');
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error fetching data: $e')));
    }
  }

  pw.Widget createDefaultReportPage(
      pw.Context context,
      pw.ImageProvider logoImage,
      Map<String, dynamic> doc,
      DateTime caseDate,
      int index,
      int totalPages,
      String query) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(50),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(width: 1),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Center(child: pw.Image(logoImage, width: 450, height: 120)),
          pw.SizedBox(height: 30),
          pw.Center(
              child: pw.Text("($query)",
                  style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold, fontSize: 16))),
          pw.SizedBox(height: 20),
          pw.Text('Case Name: ${doc['name']}',
              style: const pw.TextStyle(fontSize: 16)),
          pw.Text('Case Age: ${doc['age']}',
              style: const pw.TextStyle(fontSize: 16)),
          pw.Text('Case Gender: ${doc['gender']}',
              style: const pw.TextStyle(fontSize: 16)),
          pw.Text('Case Date and Time: ${caseDate.toString()}',
              style: const pw.TextStyle(fontSize: 16)),
          pw.Divider(),
          pw.Text('Case description:',
              style:
                  pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 16)),
          pw.Text(doc['description'] ?? 'N/A',
              style: const pw.TextStyle(fontSize: 16)),
          pw.Divider(),
          pw.Text('Recommendation:',
              style:
                  pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 16)),
          pw.Text(doc['comment'] ?? 'N/A',
              style: const pw.TextStyle(fontSize: 16)),
          pw.Divider(),
          pw.Text('Follower Name: ${doc['followerName']}',
              style: const pw.TextStyle(fontSize: 16)),
          pw.Text('Report Issue Date: ${DateTime.now().toString()}',
              style: const pw.TextStyle(fontSize: 16)),
          pw.Padding(
            padding: const pw.EdgeInsets.only(top: 20),
            child: pw.Text('Signature: (____________________)',
                style:
                    pw.TextStyle(fontStyle: pw.FontStyle.italic, fontSize: 16)),
          ),
          pw.Expanded(
            child: pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.end,
              children: [
                pw.Align(
                  alignment: pw.Alignment.bottomRight,
                  child: pw.Text(
                    'Page $index of $totalPages', // Dynamic page number display
                    style: const pw.TextStyle(fontSize: 12),
                  ),
                ),
                pw.Align(
                  alignment: pw.Alignment.bottomRight,
                  child: pw.Text(
                    'Deep Learning Deaf and Mute System (DLDMS)',
                    style: const pw.TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  pw.Widget createReportPage(pw.Context context, pw.ImageProvider logoImage,
      String reportTitle, List<pw.Widget> countDetails) {
    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 30),
      decoration: pw.BoxDecoration(border: pw.Border.all(width: 1)),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Center(child: pw.Image(logoImage, width: 450, height: 120)),
          pw.SizedBox(height: 30),
          pw.Center(
              child: pw.Text(reportTitle,
                  style: const pw.TextStyle(fontSize: 20))),
          pw.SizedBox(height: 100),
          pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
              children: countDetails),
          pw.Spacer(),
          pw.Text('Report Issue Date: ${DateTime.now().toString()}',
              style: const pw.TextStyle(fontSize: 16)),
          pw.SizedBox(height: 40),
          pw.Align(
            alignment: pw.Alignment.bottomRight,
            child: pw.Text('Deep Learning Deaf and Mute System (DLDMS)',
                style: const pw.TextStyle(fontSize: 12)),
          ),
        ],
      ),
    );
  }

  pw.Widget reportDetails(int count, String label) {
    return pw.Column(children: [
      pw.Text(label,
          style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 20)),
      pw.SizedBox(height: 20),
      pw.Container(
        width: 120,
        height: 120,
        alignment: pw.Alignment.center,
        decoration: pw.BoxDecoration(
          shape: pw.BoxShape.circle,
          border: pw.Border.all(width: 2),
        ),
        child: pw.Text('$count',
            style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
      ),
    ]);
  }

  Future<pw.ImageProvider> _loadImage() async {
    final byteData = await rootBundle.load('assets/logo.png');
    final buffer = byteData.buffer;
    return pw.MemoryImage(
      buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes),
    );
  }
}
