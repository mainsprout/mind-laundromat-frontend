import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mind_laundromat/models/diary.dart';
import 'package:mind_laundromat/widgets/custom_app_bar.dart';

class DiaryDetailScreen extends StatefulWidget {
  final Diary diary;

  const DiaryDetailScreen({super.key, required this.diary});

  @override
  State<DiaryDetailScreen> createState() => _DiaryDetailScreenState();
}

class _DiaryDetailScreenState extends State<DiaryDetailScreen> {
  Diary? _diary;

  @override
  void initState() {
    super.initState();
    _diary = widget.diary;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Diary'),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              DateFormat('yyyy-MM-dd HH:mm').format(_diary!.regDate),
              style: const TextStyle(fontSize: 18, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            Text(
              _diary!.summation,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              _diary!.beforeContent,
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              _diary!.afterContent,
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              _diary!.solution,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
