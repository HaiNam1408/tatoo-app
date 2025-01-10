import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../generated/colors.gen.dart';
import '../extensions/build_context_x.dart';

class CustomDatePicker extends StatefulWidget {
  final Function(DateTime) onDateSelected;
  final DateTime? initialDate;

  const CustomDatePicker({
    super.key,
    required this.onDateSelected,
    this.initialDate,
  });

  @override
  CustomDatePickerState createState() => CustomDatePickerState();
}

class CustomDatePickerState extends State<CustomDatePicker> {
  late DateTime _selectedDate;
  late DateTime _displayedMonth;
  late DateTime _currentDate;
  bool _isMonthYearPickerVisible = false; // Quản lý hiển thị MonthYearPicker

  @override
  void initState() {
    super.initState();
    _currentDate = DateTime.now();
    _selectedDate = widget.initialDate ?? _currentDate;
    _displayedMonth = DateTime(_selectedDate.year, _selectedDate.month);
  }

  void _selectDate(DateTime date) {
    setState(() {
      _selectedDate = date;
    });
  }

  void _changeMonth(int months) {
    setState(() {
      _displayedMonth =
          DateTime(_displayedMonth.year, _displayedMonth.month + months);
    });
  }

  // Phương thức hiển thị MonthYearPicker và ẩn CustomDatePicker
  void _selectMonthAndYear() {
    setState(() {
      _isMonthYearPickerVisible = true; // Hiển thị MonthYearPicker
    });
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return MonthYearPicker(
          initialDate: _displayedMonth,
          onDateSelected: (DateTime newDate) {
            setState(() {
              _displayedMonth = newDate;
              _isMonthYearPickerVisible = false; // Ẩn MonthYearPicker sau khi chọn
            });
          },
        );
      },
    ).then((_) {
      setState(() {
        _isMonthYearPickerVisible = false; // Hiển thị lại CustomDatePicker sau khi MonthYearPicker đóng
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!_isMonthYearPickerVisible) ...[
            _buildHeader(),
            _buildCalendar(),
            ElevatedButton(
              onPressed: () {
                widget.onDateSelected(_selectedDate);
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                minimumSize: const Size(double.infinity, 48),
              ),
              child: const Text(
                'Hoàn tất',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.white),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_left, size: 30),
          onPressed: () => _changeMonth(-1),
        ),
        InkWell(
          onTap: _selectMonthAndYear, // Hiển thị MonthYearPicker khi nhấn vào đây
          child: Text(
            'Tháng ${DateFormat('MM, yyyy', 'vi_VN').format(_displayedMonth)}',
            style: context.textTheme.bold
                .copyWith(fontSize: 20, color: ColorName.dark),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.arrow_right, size: 30),
          onPressed: () => _changeMonth(1),
        ),
      ],
    );
  }

  Widget _buildCalendar() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        childAspectRatio: 1,
      ),
      itemCount: 7 * 7,
      itemBuilder: (context, index) {
        if (index < 7) {
          return _buildWeekdayLabel(index);
        }
        return _buildDayTile(index - 7);
      },
    );
  }

  Widget _buildWeekdayLabel(int index) {
    final weekdays = ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'];
    return Center(
      child: Text(
        weekdays[index],
        style: context.textTheme.bold
            .copyWith(fontSize: 14, color: ColorName.dark),
      ),
    );
  }

  Widget _buildDayTile(int index) {
    final firstDayOfMonth =
        DateTime(_displayedMonth.year, _displayedMonth.month, 1);
    final dayOffset = firstDayOfMonth.weekday - 1;
    final day = index - dayOffset + 1;

    if (day < 1 ||
        day >
            DateUtils.getDaysInMonth(
                _displayedMonth.year, _displayedMonth.month)) {
      return Container();
    }

    final date = DateTime(_displayedMonth.year, _displayedMonth.month, day);
    final isSelected = date.year == _selectedDate.year &&
        date.month == _selectedDate.month &&
        date.day == _selectedDate.day;
    final isCurrentDate = date.year == _currentDate.year &&
        date.month == _currentDate.month &&
        date.day == _currentDate.day;

    return GestureDetector(
      onTap: () => _selectDate(date),
      child: Container(
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: isSelected ? Colors.black : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (isCurrentDate)
              Container(
                decoration: const BoxDecoration(),
              ),
            Text(
              day.toString().padLeft(2, '0'),
              style: TextStyle(
                color: isSelected
                    ? Colors.white
                    : isCurrentDate
                        ? Colors.grey.withOpacity(0.5)
                        : Colors.black,
                fontWeight: isSelected || isCurrentDate
                    ? FontWeight.w500
                    : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MonthYearPicker extends StatefulWidget {
  final DateTime initialDate;
  final Function(DateTime) onDateSelected;

  const MonthYearPicker({
    super.key,
    required this.initialDate,
    required this.onDateSelected,
  });

  @override
  MonthYearPickerState createState() => MonthYearPickerState();
}

class MonthYearPickerState extends State<MonthYearPicker> {
  late DateTime _selectedDate;
  final List<int> _years = List.generate(101, (index) => 2000 + index); // Years from 2000 to 2100
  late int _selectedYearIndex;
  late int _selectedMonthIndex;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
    _selectedYearIndex = _years.indexOf(_selectedDate.year);
    _selectedMonthIndex = _selectedDate.month - 1;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Tháng ${_selectedDate.month} năm ${_selectedDate.year}',
              style: context.textTheme.medium
                  .copyWith(fontSize: 18, color: ColorName.dark),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 150,
              child: Row(
                children: [
                  Expanded(
                    child: _buildCircularMonthPicker(),
                  ),
                  Expanded(
                    child: _buildYearPicker(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 48),
              ),
              onPressed: () {
                widget.onDateSelected(_selectedDate);
                Navigator.of(context).pop();
              },
              child: const Text('Xong'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCircularMonthPicker() {
    return ListWheelScrollView.useDelegate(
      itemExtent: 45,
      diameterRatio: 12,
      controller: FixedExtentScrollController(initialItem: _selectedMonthIndex),
      physics: const FixedExtentScrollPhysics(),
      onSelectedItemChanged: (index) {
        setState(() {
          _selectedMonthIndex = index % 12;
          _selectedDate = DateTime(_selectedDate.year, _selectedMonthIndex + 1);
       

        });
      },
      childDelegate: ListWheelChildLoopingListDelegate(
        children: List.generate(12, (index) {
          return Center(
            child: Text(
              'Tháng ${index + 1}',
              style: TextStyle(
                fontSize: _selectedMonthIndex == index ? 24 : 20,
                fontWeight: FontWeight.bold,
                color: _selectedMonthIndex == index ? Colors.black :Colors.grey.withOpacity(0.5)
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildYearPicker() {
    return ListWheelScrollView.useDelegate(
      itemExtent: 45,
      diameterRatio: 12,
      controller: FixedExtentScrollController(initialItem: _selectedYearIndex),
      physics: const FixedExtentScrollPhysics(),
      onSelectedItemChanged: (index) {
        setState(() {
          _selectedYearIndex = index;
          _selectedDate = DateTime(_years[index], _selectedDate.month);
        });
      },
      childDelegate: ListWheelChildListDelegate(
        children: _years.map((year) {
          return Center(
            child: Text(
              year.toString(),
              style: TextStyle(
                fontSize: _selectedYearIndex == _years.indexOf(year) ? 24 : 20,
                fontWeight: FontWeight.bold,
                color: _selectedYearIndex == _years.indexOf(year) ? Colors.black :Colors.grey.withOpacity(0.5)
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
