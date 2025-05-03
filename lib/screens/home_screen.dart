import 'package:flutter/material.dart';
import 'dart:math';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotationY;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _rotationY = Tween<double>(begin: 0, end: pi).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _colorAnimation = ColorTween(begin: Colors.black, end: Colors.white).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            // 상단 아이콘들
            Positioned(
              top: 16,
              left: 16,
              child: Icon(Icons.calendar_today, size: 40),
            ),
            Positioned(
              top: 16,
              right: 16,
              child: Icon(Icons.person, size: 40),
            ),

            // 중앙: Y축 회전 하트
            Center(
              child: AnimatedBuilder(
                animation: _rotationY,
                builder: (context, child) {
                  return Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.001)
                      ..rotateY(_rotationY.value),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // 테두리 하트 (항상 검정색)
                        Icon(
                          Icons.favorite_border,
                          size: 124, // 살짝 크게
                          color: Colors.black,
                        ),
                        // 안쪽 하트 (애니메이션 색상)
                        Icon(
                          Icons.favorite,
                          size: 120,
                          color: _colorAnimation.value,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // 하단 버튼
            Positioned(
              bottom: 40,
              left: 32,
              right: 32,
              child: ElevatedButton(
                onPressed: () {
                  // Doing Clean 버튼 동작
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                ),
                child: const Text(
                  'Doing Clean',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
