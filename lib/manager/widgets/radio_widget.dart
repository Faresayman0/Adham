import 'package:flutter/material.dart';

class CustomRadioWidget extends StatefulWidget {
  final String value;
  final String selectText;
  final String? groupValue; // إضافة groupValue للتحقق من تحديد عنصر واحد فقط
  final Function(String) onChange;

  const CustomRadioWidget({
    required this.value,
    required this.selectText,
    required this.groupValue,
    required this.onChange,
    Key? key,
  }) : super(key: key);

  @override
  State<CustomRadioWidget> createState() => _CustomRadioWidgetState();
}

class _CustomRadioWidgetState extends State<CustomRadioWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(
          width: 50,
        ),
        Radio(
          value: widget.value,
          groupValue: widget.groupValue,
          onChanged: (value) {
            setState(() {
              widget.onChange(value.toString());
            });
          },
        ),
        Text(
          widget.selectText,
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(width: 20),
      ],
    );
  }
}
