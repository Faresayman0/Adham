import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deaf_mute_system/report/available_cars.dart';
import 'package:deaf_mute_system/report/show_report.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class StatusPieChartPage extends StatefulWidget {
  const StatusPieChartPage({Key? key}) : super(key: key);

  @override
  _StatusPieChartPageState createState() => _StatusPieChartPageState();
}

class _StatusPieChartPageState extends State<StatusPieChartPage> {
  int acceptedCount = 0;
  int cancelledCount = 0;
  DateTime selectedDate = DateTime.now();
  List<double> weeklyAcceptedCounts = [0, 0, 0, 0];
  List<double> weeklyCancelledCounts = [0, 0, 0, 0];
  int totalReports = 0;
  double reportsGrowthPercentage = 0.0;
  int currentMonthCount = 0;
  int lastMonthCount = 0;
  List<FlSpot> spotsList = [];
  int selectedYear = DateTime.now().year;
  int totalReportsCount = 0;
  bool showAvailableCars = false; // حالة لتتبع الصفحة الحالية

  @override
  void initState() {
    super.initState();
    _fetchData();
    _fetchTotalReports();
    _fetchDataForAllMonths();
  }

  Widget _buildYearSelector() {
    return DropdownButton<int>(
      value: selectedYear,
      items: List.generate(10, (index) {
        int year = DateTime.now().year - index;
        return DropdownMenuItem<int>(
          value: year,
          child: Text("$year"),
        );
      }),
      onChanged: (value) {
        if (value != null) {
          setState(() {
            selectedYear = value;
            _fetchDataForAllMonths();
          });
        }
      },
    );
  }

  Future<void> _fetchDataForAllMonths() async {
    Map<int, int> reportsPerMonth = {};
    List<FlSpot> spots = [];
    int year = selectedYear;

    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('report').get();

    for (var doc in snapshot.docs) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      DateTime date = (data['date'] as Timestamp).toDate();
      if (date.year == year) {
        int month = date.month;
        reportsPerMonth[month] = (reportsPerMonth[month] ?? 0) + 1;
      }
    }

    for (int month = 1; month <= 12; month++) {
      int count = reportsPerMonth[month] ?? 0;
      spots.add(FlSpot(month.toDouble(), count.toDouble()));
    }

    setState(() {
      spotsList = spots;
    });
  }

  Widget _buildTotalReportsChart() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Total Reports',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  '$totalReports',
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      reportsGrowthPercentage >= 0
                          ? Icons.arrow_upward
                          : Icons.arrow_downward,
                      color: reportsGrowthPercentage >= 0
                          ? Colors.green
                          : Colors.red,
                    ),
                    Text(
                      '${reportsGrowthPercentage.toStringAsFixed(2)}%',
                      style: TextStyle(
                        color: reportsGrowthPercentage >= 0
                            ? Colors.green
                            : Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 20),
          SizedBox(
            width: 200,
            height: 100,
            child: LineChart(
              LineChartData(
                gridData: const FlGridData(show: false),
                titlesData: const FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: spotsList,
                    isCurved: false,
                    color: Colors.blue,
                    barWidth: 2,
                    dotData: const FlDotData(show: false),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _fetchTotalReports() async {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('report').get();

    DateTime currentDate = DateTime.now();
    DateTime lastMonth =
        DateTime(currentDate.year, currentDate.month - 1, currentDate.day);

    for (var doc in snapshot.docs) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      DateTime date = (data['date'] as Timestamp).toDate();
      if (date.month == currentDate.month && date.year == currentDate.year) {
        currentMonthCount++;
      } else if (date.month == lastMonth.month && date.year == lastMonth.year) {
        lastMonthCount++;
      }
      totalReportsCount++;
    }

    double growthOrReductionRate;
    if (lastMonthCount == 0) {
      growthOrReductionRate = currentMonthCount * 100.0;
    } else {
      growthOrReductionRate =
          ((currentMonthCount - lastMonthCount) / lastMonthCount) * 100;
    }

    setState(() {
      totalReports = totalReportsCount;
      reportsGrowthPercentage = growthOrReductionRate;
    });
  }

  void _selectDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        _fetchData();
      });
    }
  }

  Future<void> _fetchData() async {
    DateTime firstDayOfMonth =
        DateTime(selectedDate.year, selectedDate.month, 1);
    DateTime lastDayOfMonth =
        DateTime(selectedDate.year, selectedDate.month + 1, 0, 23, 59, 59);

    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('report')
        .where('date',
            isGreaterThanOrEqualTo: Timestamp.fromDate(firstDayOfMonth))
        .where('date', isLessThanOrEqualTo: Timestamp.fromDate(lastDayOfMonth))
        .get();

    int localAcceptedCount = 0;
    int localCancelledCount = 0;

    for (var doc in snapshot.docs) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      if (data['status'] == 'accept') {
        localAcceptedCount++;
      } else if (data['status'] == 'cancelled') {
        localCancelledCount++;
      }
    }

    await _fetchWeeklyData();

    setState(() {
      acceptedCount = localAcceptedCount;
      cancelledCount = localCancelledCount;
    });
  }

  Future<void> _fetchWeeklyData() async {
    DateTime firstDayOfMonth =
        DateTime(selectedDate.year, selectedDate.month, 1);
    List<double> localWeeklyAcceptedCounts = [0, 0, 0, 0];
    List<double> localWeeklyCancelledCounts = [0, 0, 0, 0];

    for (int week = 0; week < 4; week++) {
      DateTime weekStart = firstDayOfMonth.add(Duration(days: 7 * week));
      DateTime weekEnd = weekStart
          .add(const Duration(days: 6, hours: 23, minutes: 59, seconds: 59));

      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('report')
          .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(weekStart))
          .where('date', isLessThanOrEqualTo: Timestamp.fromDate(weekEnd))
          .get();

      for (var doc in snapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        if (data['status'] == 'accept') {
          localWeeklyAcceptedCounts[week]++;
        } else if (data['status'] == 'cancelled') {
          localWeeklyCancelledCounts[week]++;
        }
      }
    }

    setState(() {
      weeklyAcceptedCounts = localWeeklyAcceptedCounts;
      weeklyCancelledCounts = localWeeklyCancelledCounts;
    });
  }

  List<LineChartBarData> _buildLineBarsData() {
    return [
      LineChartBarData(
        spots: _getSpots(weeklyAcceptedCounts),
        isCurved: true,
        color: Colors.blue,
        barWidth: 4,
        isStrokeCapRound: true,
        dotData: const FlDotData(show: true),
        belowBarData: BarAreaData(show: false),
      ),
      LineChartBarData(
        spots: _getSpots(weeklyCancelledCounts),
        isCurved: true,
        color: Colors.red,
        barWidth: 4,
        isStrokeCapRound: true,
        dotData: const FlDotData(show: true),
        belowBarData: BarAreaData(show: false),
      ),
    ];
  }

  List<FlSpot> _getSpots(List<double> weeklyCounts) {
    List<FlSpot> spots = [];
    for (int index = 0; index < weeklyCounts.length; index++) {
      spots.add(FlSpot(index.toDouble(), weeklyCounts[index]));
    }
    return spots;
  }

  Widget _buildLineChart() {
    double maxY = max(acceptedCount.toDouble(), cancelledCount.toDouble());
    maxY = max(maxY, weeklyAcceptedCounts.reduce(max));
    maxY = max(maxY, weeklyCancelledCounts.reduce(max));

    maxY += maxY * 0.2;

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: true,
          getDrawingVerticalLine: (value) => FlLine(
            color: Colors.grey.shade300,
            strokeWidth: 1,
          ),
          drawHorizontalLine: true,
          getDrawingHorizontalLine: (value) => FlLine(
            color: Colors.grey.shade300,
            strokeWidth: 1,
          ),
        ),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              getTitlesWidget: (value, meta) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  '${value.toInt()}',
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              interval: 1,
              getTitlesWidget: (value, meta) {
                return Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: Text(
                    'week${value.toInt() + 1}',
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        lineBarsData: _buildLineBarsData(),
        minX: 0,
        maxX: 3,
        minY: 0,
        maxY: maxY,
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            tooltipBgColor: Colors.blueGrey,
            getTooltipItems: (touchedSpots) {
              return touchedSpots.map((touchedSpot) {
                return LineTooltipItem(
                  '${touchedSpot.y}',
                  const TextStyle(color: Colors.white),
                );
              }).toList();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildPieChart(
      int count, String status, Color color, int totalReports) {
    double emptySpace =
        totalReports > 0 ? (totalReports - count).toDouble() : 0;
    return Stack(
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(showAvailableCars ? 'Available Cars' : 'Reports Status'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ToggleButtons(
              isSelected: [!showAvailableCars, showAvailableCars],
              onPressed: (index) {
                setState(() {
                  showAvailableCars = index == 1;
                });
              },
              children: const [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text('Reports'),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text('Available Cars'),
                ),
              ],
            ),
          ),
          Expanded(
            child: showAvailableCars
                ? const AvailableCarsPage()
                : _buildReportsPage(),
          ),
        ],
      ),
    );
  }

  Widget _buildReportsPage() {
    return Column(
      children: [
        _buildYearSelector(),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: _buildTotalReportsChart(),
        ),
        Expanded(
          child: Row(
            children: [
              ElevatedButton.icon(
                onPressed: _selectDate,
                icon: const Icon(
                  Icons.calendar_month,
                  color: Colors.black,
                ),
                label: const Text(
                  "Select date",
                  style: TextStyle(color: Colors.black),
                ),
              ),
              Expanded(
                child: _buildPieChart(
                    acceptedCount, 'Accepted', Colors.blue, totalReports),
              ),
              Expanded(
                child: _buildPieChart(
                    cancelledCount, 'Cancelled', Colors.red, totalReports),
              ),
            ],
          ),
        ),
        Row(
          children: [
            Text(
              ' Date: ${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(width: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  side: const BorderSide(style: BorderStyle.solid)),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return const ReportScreen();
                    },
                  ),
                );
              },
              child: const Text(
                "View Reports",
                style: TextStyle(color: Colors.black),
              ),
            ),
            const SizedBox(width: 10),
            Column(
              children: [
                RichText(
                  text: const TextSpan(
                    children: [
                      WidgetSpan(
                        child: Icon(Icons.circle, size: 14, color: Colors.red),
                      ),
                      TextSpan(
                        text: " CANCELLED",
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                RichText(
                  text: const TextSpan(
                    children: [
                      WidgetSpan(
                        child: Icon(Icons.circle, size: 14, color: Colors.blue),
                      ),
                      TextSpan(
                        text: " accept",
                        style: TextStyle(color: Colors.blue, fontSize: 20),
                      ),
                    ],
                  ),
                ),
                RichText(
                  text: const TextSpan(
                    children: [
                      WidgetSpan(
                        child: Icon(Icons.circle, size: 14, color: Colors.grey),
                      ),
                      TextSpan(
                        text: "Another Report",
                        style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: _buildLineChart(),
          ),
        ),
      ],
    );
  }
}
