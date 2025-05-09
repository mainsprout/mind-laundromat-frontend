import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Calendar"),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TableCalendar(
          firstDay: DateTime.utc(2020, 1, 1),
          lastDay: DateTime.utc(2030, 12, 31),
          focusedDay: _focusedDay,
          selectedDayPredicate: (day) {
            return isSameDay(_selectedDay, day);
          },
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
            });
          },
          headerStyle: const HeaderStyle(
            formatButtonVisible: false,  // 2weeks 버튼 숨김
            titleCentered: true,
            // titleTextStyle: TextStyle(color: Colors.black),
            // leftChevronIcon: Icon(Icons.chevron_left, color: Colors.black),
            // rightChevronIcon: Icon(Icons.chevron_right, color: Colors.black),
          ),
          calendarStyle: const CalendarStyle(
            todayDecoration: BoxDecoration(
              color: Color(0xFF6BA8E6),
              shape: BoxShape.circle,
            ),
            selectedDecoration: BoxDecoration(
              color: Colors.black,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }
}
