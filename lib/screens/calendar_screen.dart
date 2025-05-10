import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:mind_laundromat/widgets/custom_app_bar.dart';
import 'package:intl/intl.dart';
import 'package:mind_laundromat/screens/diary_detail_screen.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  List<DateTime> diaryDays = [];

  List<String> getDiariesForDay(DateTime day) {
    // TODO: 실제 다이어리 API 연동 전까지는 항상 임시 데이터 반환
    return [
      '오늘은 좋은 하루였어요.',
      '산책하면서 기분이 좋아졌어요.',
      'Flutter 공부도 했어요.',
    ];
  }

  @override
  void initState() {
    super.initState();

    // TODO: 임시로 다이어리가 기록된 날짜를 추가
    diaryDays = [
      DateTime(2025, 5, 4), // 4일
    ];
  }

  bool isDiaryDay(DateTime day) {
    // 같은 연도, 월, 일이 일치하는 경우 다이어리 있는 날로 처리
    return diaryDays.any((diaryDay) =>
    diaryDay.year == day.year &&
        diaryDay.month == day.month &&
        diaryDay.day == day.day);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Calendar'),
      backgroundColor: Colors.grey[200],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // White box wrapping the calendar with some padding at top and bottom
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(vertical: 8.0), // Add vertical padding
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
                // 이벤트 로더 설정
                //eventLoader: getEventsForDay,
                headerStyle: const HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                ),
                calendarStyle: CalendarStyle(
                  todayDecoration: BoxDecoration(
                    color: Color(0xFFE2E8ED), // Today's background color
                    shape: BoxShape.circle,
                  ),
                  todayTextStyle: TextStyle(
                    color: Color(0xFF446E9A), // Today's text color
                  ),
                ),
                calendarBuilders: CalendarBuilders(
                  dowBuilder: (context, day) {
                    if (day.weekday == DateTime.sunday) {
                      final text = DateFormat.E().format(day);
                      return Center(
                        child: Text(
                          text,
                          style: TextStyle(color: Colors.red),
                        ),
                      );
                    }
                  },
                  defaultBuilder: (context, day, focusedDay) {
                    if (isDiaryDay(day)) {
                      return Container(
                        margin: const EdgeInsets.all(6.0),
                        decoration: BoxDecoration(
                          color: const Color(0xFF6BA8E6),
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          day.day.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    }
                    return null;
                  },
                  selectedBuilder: (context, date, focusedDay) {
                    final isToday = isSameDay(date, DateTime.now());
                    final isDiary = isDiaryDay(date);

                    // 기본 배경 스타일을 결정 (오늘이거나 다이어리인 경우)
                    BoxDecoration? baseDecoration;
                    TextStyle? baseTextStyle;

                    if (isDiary) {
                      baseDecoration = BoxDecoration(
                        color: const Color(0xFF6BA8E6),
                        shape: BoxShape.circle,
                      );
                      baseTextStyle = const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      );
                    } else if (isToday) {
                      baseDecoration = BoxDecoration(
                        color: const Color(0xFFE2E8ED),
                        shape: BoxShape.circle,
                      );
                      baseTextStyle = const TextStyle(
                        color: Color(0xFF446E9A),
                      );
                    }

                    return Stack(
                      alignment: Alignment.center,
                      children: [
                        // 아래에 오늘/다이어리 스타일
                        if (baseDecoration != null)
                          Container(
                            margin: const EdgeInsets.all(6.0),
                            decoration: baseDecoration,
                            alignment: Alignment.center,
                            child: Text(
                              date.day.toString(),
                              style: baseTextStyle,
                            ),
                          )
                        else
                        // 기본 날짜 스타일
                          Text(date.day.toString()),

                        // 위에 반투명한 흰 배경 + 파란 테두리
                        Container(
                          margin: const EdgeInsets.all(6.0),
                          decoration: BoxDecoration(
                            color: Colors.white.withAlpha(100), // 약간의 투명도
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: const Color(0xFF6BA8E6),
                              width: 2,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),

              ),
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: ListView.builder(
                itemCount: getDiariesForDay(_selectedDay ?? _focusedDay).length,
                itemBuilder: (context, index) {
                  final diary = getDiariesForDay(_selectedDay ?? _focusedDay)[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          //TODO: 다이어리 아이디 넘겨줘야함
                          builder: (_) => DiaryDetailScreen(diaryContent: diary),
                        ),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 6.0),
                      padding: const EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        diary,
                        style: const TextStyle(fontSize: 16.0),
                      ),
                    ),
                  );
                },
              ),
            ),

          ],
        ),
      ),
    );
  }
}
