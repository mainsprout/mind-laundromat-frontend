import 'package:flutter/material.dart';

class CounselScreen extends StatelessWidget {
  const CounselScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('상담 챗봇'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: const Center(
        child: Text(
          '상담 챗봇 화면',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
