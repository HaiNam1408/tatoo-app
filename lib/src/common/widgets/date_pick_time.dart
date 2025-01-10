import 'package:flutter/material.dart';

class CustomTimePicker extends StatefulWidget {
  final Function(int, int) onTimeSelected;
  final int? initialHour;
  final int? initialMinute;

  const CustomTimePicker({
    super.key, 
    required this.onTimeSelected, 
    this.initialHour, 
    this.initialMinute
  });

  @override
  CustomTimePickerState createState() => CustomTimePickerState();
}

class CustomTimePickerState extends State<CustomTimePicker> {
  late int _selectedHour;
  late int _selectedMinute;

  @override
  void initState() {
    super.initState();
    _selectedHour = widget.initialHour?? _selectedHour;
    _selectedMinute = widget.initialMinute ??  _selectedMinute;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildNumberColumn(23, (value) => setState(() {
                  _selectedHour = value;
                  widget.onTimeSelected(_selectedHour, _selectedMinute);
                }), _selectedHour),
                const SizedBox(width: 40),
                const Text(':', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black)),
                const SizedBox(width: 40),
                _buildNumberColumn(59, (value) => setState(() {
                  _selectedMinute = value;
                  widget.onTimeSelected(_selectedHour, _selectedMinute);
                }), _selectedMinute),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('Hoàn tất', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNumberColumn(int maxValue, Function(int) onChanged, int selectedValue) {
    return SizedBox(
      height: 150,
      width: 50,
      child: ListWheelScrollView.useDelegate(
        itemExtent: 50,
        perspective: 0.005,
        diameterRatio: 1.2,
        physics: const FixedExtentScrollPhysics(),
        childDelegate: ListWheelChildBuilderDelegate(
          childCount: maxValue + 1,
          builder: (context, index) {
            return Center(
              child: Text(
                index.toString().padLeft(2, '0'),
                style: TextStyle(
                  fontSize: index == selectedValue ? 24 : 20,
                  fontWeight: index == selectedValue ? FontWeight.bold : FontWeight.normal,
                  color: index == selectedValue ? Colors.black : Colors.grey,
                ),
              ),
            );
          },
        ),
        onSelectedItemChanged: (index) => onChanged(index),
        controller: FixedExtentScrollController(initialItem: selectedValue),
      ),
    );
  }
}