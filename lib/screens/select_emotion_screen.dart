import 'package:flutter/material.dart';
import 'package:mind_laundromat/widgets/custom_app_bar.dart';

class SelectEmotionScreen extends StatelessWidget {
  const SelectEmotionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final emotions = [
      {'name': 'happiness', 'path': 'assets/emotions/happiness.png'},
      {'name': 'sadness', 'path': 'assets/emotions/sadness.png'},
      {'name': 'anger', 'path': 'assets/emotions/anger.png'},
      {'name': 'neutral', 'path': 'assets/emotions/neutral.png'},
      {'name': 'calm', 'path': 'assets/emotions/calm.png'},
    ];

    Widget emotionItem(Map<String, String> emotion, String routeName) {
      return Padding(
        padding: const EdgeInsets.all(4.0),
        child: GestureDetector(
          onTap: () {
            Navigator.pushNamed(
              context,
              routeName,
              arguments: emotion['name'],
            );
          },
          child: Image.asset(
            emotion['path']!,
            width: 100,
            height: 100,
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: const CustomAppBar(title: ''),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 윗줄 3개
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (index) {
                return emotionItem(emotions[index], '/counsel');
              }),
            ),
            const SizedBox(height: 16),
            // 아랫줄 2개
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(2, (index) {
                return emotionItem(emotions[index + 3], '/counsel');
              }),
            ),
            const SizedBox(height: 24),
            // 아래 텍스트
            const Text(
              'Pick how you feel',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
