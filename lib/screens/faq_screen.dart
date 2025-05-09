import 'package:flutter/material.dart';

class FAQScreen extends StatelessWidget {
  const FAQScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FAQ'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Text(
          '자주 묻는 질문들\n\n1. 로그인 문제\n2. 비밀번호 재설정\n3. 계정 삭제 등...',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
