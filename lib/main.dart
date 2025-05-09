import 'package:flutter/material.dart';
import 'screens/screens.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mind Laundromat',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const StartScreen(), // 홈을 StartScreen으로 설정
      routes: {
        '/home': (context) => const HomeScreen(),
        '/login': (context) => const LoginScreen(),
        '/sign-in': (context) => const SignInScreen(),
        '/sign-up': (context) => const SignUpScreen(),
        '/calendar': (context) => const CalendarScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/counsel': (context) => const CounselScreen(),
      },
    );
  }
}
