import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:table_calendar/table_calendar.dart';
import 'package:mind_laundromat/widgets/custom_app_bar.dart';
import 'package:intl/intl.dart';
import 'package:mind_laundromat/screens/diary_detail_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mind_laundromat/models/diary.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  List<DateTime> diaryDays = [];
  List<Diary> diaries = [];

  // 월별 다이어리가 기록된 날짜
  Future<void> fetchDiaryDatesForMonth(DateTime month) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('access_token') ?? '';

      if (accessToken.isEmpty) {
        throw Exception("Access token is not available.");
      }

      final response = await http.post(
        Uri.parse('http://10.0.2.2:8080/cbt/month/list'),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          //'localDate': '2025-05-01',
          'localDate': DateFormat('yyyy-MM-dd').format(month), // 선택된 월의 첫 번째 날짜
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        if (data['code'] == 'S201') {
          // 서버에서 받은 날짜 데이터
          List<String> dateStrings = List<String>.from(data['data']);
          setState(() {
            diaryDays = dateStrings.map((date) => DateTime.parse(date)).toList();
          });
        } else {
          throw Exception(data['message']);
        }
      } else {
        throw Exception('Failed to load diary dates');
      }
    } catch (e) {
      // 오류 처리
      print('Error fetching diary dates: $e');
    }
  }

  // 날짜별 다이어리들
  Future<void> fetchDiaryForDay(DateTime day) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('access_token') ?? '';

      if (accessToken.isEmpty) {
        throw Exception("Access token is not available.");
      }

      final response = await http.post(
        Uri.parse('http://10.0.2.2:8080/cbt/list'),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'localDate': DateFormat('yyyy-MM-dd').format(day), // 선택한 날짜
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        if (data['code'] == 'S201') {
          // 서버에서 받은 다이어리 데이터
          List<dynamic> diaryList = data['data'];
          setState(() {
            diaries = diaryList.map((e) => Diary.fromJson(e)).toList();
          });
        } else {
          throw Exception(data['message']);
        }
      } else {
        throw Exception('Failed to load diary data');
      }
    } catch (e) {
      // 오류 처리
      print('Error fetching diary for day: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchDiaryDatesForMonth(_focusedDay); // 앱이 시작될 때 현재 월의 다이어리 날짜 데이터 가져오기
    fetchDiaryForDay(_focusedDay); // 기본적으로 현재 날짜의 다이어리 정보 불러오기
  }

  // 월이 바뀌면 다이어리 날짜 데이터를 다시 받아옴
  void _onMonthChanged(DateTime focusedMonth) {
    setState(() {
      _focusedDay = focusedMonth;  // focusedDay를 바꿔주고
    });
    fetchDiaryDatesForMonth(focusedMonth); // 월에 맞는 데이터 새로 불러오기
  }

  // 날짜가 선택되면 해당 날짜에 대한 다이어리를 불러옴
  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;
    });
    // 선택된 날짜에 대한 다이어리 정보 가져오기
    fetchDiaryForDay(selectedDay);
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
                onDaySelected: _onDaySelected,
                onPageChanged: (focusedMonth) {
                  _onMonthChanged(focusedMonth); // 월이 변경될 때마다 데이터 불러오기
                },
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
                          Text(date.day.toString()),

                        Container(
                          margin: const EdgeInsets.all(6.0),
                          decoration: BoxDecoration(
                            color: Colors.white.withAlpha(100),
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
                itemCount: diaries.length,
                itemBuilder: (context, index) {
                  final diary = diaries[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => DiaryDetailScreen(diaryId: diary.diaryId),
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
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                DateFormat('HH:mm').format(diary.regDate), // 시와 분 표시
                                style: const TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.grey,
                                ),
                              ),
                              SizedBox(height: 4.0),
                              Text(
                                diary.summation,
                                style: const TextStyle(fontSize: 16.0),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            )
            /*
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
            */
          ],
        ),
      ),
    );
  }
}
