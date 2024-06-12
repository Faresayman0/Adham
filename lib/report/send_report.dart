import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SendReport extends StatefulWidget {
  const SendReport({Key? key}) : super(key: key);

  @override
  _SendReportState createState() => _SendReportState();
}

class _SendReportState extends State<SendReport> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _followerNameController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String? _selectedName;
  String? _status;
  final TextEditingController _commentController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Send Report'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), labelText: 'Name'),
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: _ageController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), labelText: 'Age'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(
                height: 20,
              ),
              ListTile(
                title: Text(
                    "Date: ${_selectedDate.toLocal().toString().split(' ')[0]}"),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate,
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );
                  if (picked != null && picked != _selectedDate) {
                    setState(() {
                      _selectedDate = picked;
                    });
                  }
                },
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: _followerNameController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), labelText: 'Follower Name'),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: _selectedName,
                      hint: const Text("Select Report"),
                      items: [
                        "Emergency Medical Response Dispatch Report",
                        "Emergency Fire Response Dispatch Report",
                        "Emergency Police Response Dispatch Report",
                        "NAS Report",
                      ].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value, overflow: TextOverflow.ellipsis),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          _selectedName = newValue;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              DropdownButton<String>(
                isExpanded: true,
                value: _status,
                hint: const Text("Select status"),
                items: ["accept", "cancelled"].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value, overflow: TextOverflow.ellipsis),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _status = newValue;
                  });
                },
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), labelText: 'Description'),
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: _commentController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Comment (Optional)'),
              ),
              const SizedBox(
                height: 20,
              ),
              _isLoading
                  ? const CircularProgressIndicator(
                      color: Color(0xff1384A9),
                    ) // عرض مؤشر التحميل عند الحاجة
                  : ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 60),
                          backgroundColor: const Color(0xff1384A9)),
                      onPressed: _saveData,
                      child: const Text(
                        'Save report',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _saveData() async {
    if (_nameController.text.isNotEmpty &&
        _ageController.text.isNotEmpty &&
        _selectedName != null &&
        _status != null &&
        _descriptionController.text.trim().isNotEmpty &&
        _followerNameController.text.isNotEmpty) {
      setState(() {
        _isLoading = true;
      });

      try {
        await FirebaseFirestore.instance.collection('report').add({
          'name': _nameController.text,
          'age': int.parse(_ageController.text),
          'date': Timestamp.fromDate(_selectedDate),
          'selectQuery': _selectedName,
          'status': _status,
          'followerName': _followerNameController.text,
          'description': _descriptionController.text,
          'comment': _commentController.text.isEmpty
              ? "no comment"
              : _commentController.text,
        });

        // عرض رسالة نجاح الحفظ
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Report saved successfully')),
        );

        // إعادة تعيين الحقول والمتغيرات بعد الحفظ
        _nameController.clear();
        _ageController.clear();
        _commentController.clear();
        _followerNameController.clear();
        _descriptionController.clear();
        setState(() {
          _selectedDate = DateTime.now();
          _selectedName = null;
          _status = null;
          _isLoading = false;
        });
      } catch (e) {
        // عرض رسالة في حال حدوث خطأ أثناء عملية الحفظ
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving report: $e')),
        );
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      // عرض رسالة إذا كانت الحقول فارغة أو لم يتم اختيار القيم
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                'Please fill all fields and select a name,status,and description ')),
      );
      setState(() {
        _isLoading = false;
      });
    }
  }
}
