import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BirthdayPicker extends StatefulWidget {
  const BirthdayPicker({
    super.key,
    required this.initialDate,
    required this.onDateChanged,
  });

  final DateTime initialDate;
  final ValueChanged<DateTime> onDateChanged;

  @override
  State<BirthdayPicker> createState() => _BirthdayPickerState();
}

class _BirthdayPickerState extends State<BirthdayPicker> {
  static const _months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  late final List<int> _years;
  late int _selectedYear;
  late int _selectedMonth;
  late int _selectedDay;

  late FixedExtentScrollController _dayController;
  late FixedExtentScrollController _monthController;
  late FixedExtentScrollController _yearController;

  List<int> get _days =>
      List.generate(_daysInMonth(_selectedYear, _selectedMonth), (index) {
        return index + 1;
      });

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _years = List.generate(now.year - 1940 + 1, (index) => 1940 + index);
    _selectedYear = widget.initialDate.year;
    _selectedMonth = widget.initialDate.month;
    _selectedDay = widget.initialDate.day;
    _dayController = FixedExtentScrollController(initialItem: _selectedDay - 1);
    _monthController = FixedExtentScrollController(
      initialItem: _selectedMonth - 1,
    );
    _yearController = FixedExtentScrollController(
      initialItem: _years.indexOf(_selectedYear),
    );
  }

  @override
  void didUpdateWidget(covariant BirthdayPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialDate == widget.initialDate) return;

    _selectedYear = widget.initialDate.year;
    _selectedMonth = widget.initialDate.month;
    _selectedDay = widget.initialDate.day;
  }

  @override
  void dispose() {
    _dayController.dispose();
    _monthController.dispose();
    _yearController.dispose();
    super.dispose();
  }

  int _daysInMonth(int year, int month) {
    return DateTime(year, month + 1, 0).day;
  }

  void _emitDate() {
    widget.onDateChanged(DateTime(_selectedYear, _selectedMonth, _selectedDay));
  }

  void _syncDayIfNeeded() {
    final maxDay = _daysInMonth(_selectedYear, _selectedMonth);
    if (_selectedDay <= maxDay) {
      _emitDate();
      return;
    }

    setState(() {
      _selectedDay = maxDay;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _dayController.jumpToItem(maxDay - 1);
      _emitDate();
    });
  }

  Widget _buildPicker({
    required FixedExtentScrollController controller,
    required int childCount,
    required ValueChanged<int> onSelectedItemChanged,
    required String Function(int index) labelForIndex,
    required bool Function(int index) isSelected,
  }) {
    return CupertinoTheme(
      data: const CupertinoThemeData(brightness: Brightness.dark),
      child: CupertinoPicker.builder(
        scrollController: controller,
        itemExtent: 48,
        diameterRatio: 1.4,
        squeeze: 1.18,
        selectionOverlay: const SizedBox.shrink(),
        onSelectedItemChanged: onSelectedItemChanged,
        childCount: childCount,
        itemBuilder: (context, index) {
          return Center(
            child: Text(
              labelForIndex(index),
              style: TextStyle(
                color: isSelected(index)
                    ? Colors.white
                    : Colors.white.withValues(alpha: 0.26),
                fontSize: isSelected(index) ? 28 : 22,
                fontWeight: isSelected(index)
                    ? FontWeight.w500
                    : FontWeight.w400,
                letterSpacing: -0.4,
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final days = _days;

    return SizedBox(
      height: 244,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            left: 0,
            right: 0,
            top: 90,
            child: IgnorePointer(
              child: Container(
                height: 56,
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1A1E),
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                flex: 23,
                child: _buildPicker(
                  controller: _dayController,
                  childCount: days.length,
                  onSelectedItemChanged: (index) {
                    setState(() {
                      _selectedDay = days[index];
                    });
                    _emitDate();
                  },
                  labelForIndex: (index) => '${days[index]}',
                  isSelected: (index) => days[index] == _selectedDay,
                ),
              ),
              Expanded(
                flex: 39,
                child: _buildPicker(
                  controller: _monthController,
                  childCount: _months.length,
                  onSelectedItemChanged: (index) {
                    setState(() {
                      _selectedMonth = index + 1;
                    });
                    _syncDayIfNeeded();
                  },
                  labelForIndex: (index) => _months[index],
                  isSelected: (index) => index + 1 == _selectedMonth,
                ),
              ),
              Expanded(
                flex: 30,
                child: _buildPicker(
                  controller: _yearController,
                  childCount: _years.length,
                  onSelectedItemChanged: (index) {
                    setState(() {
                      _selectedYear = _years[index];
                    });
                    _syncDayIfNeeded();
                  },
                  labelForIndex: (index) => '${_years[index]}',
                  isSelected: (index) => _years[index] == _selectedYear,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
