import 'package:flutter/material.dart';

class DiaryDetailScreen extends StatelessWidget {
  final String diaryContent;

  const DiaryDetailScreen({super.key, required this.diaryContent});

  @override
  Widget build(BuildContext context) {
    //TODO: 다이어리 아이디를 받아서 상세페이지 출력
    return Scaffold(
      appBar: AppBar(
        title: const Text('다이어리 상세보기'),
        backgroundColor: const Color(0xFF6BA8E6),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          diaryContent,
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
