import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
      home: const CheckLoginStatus(),
      routes: {
        '/home': (context) => const HomeScreen(),
        '/login': (context) => const LoginScreen(),
        '/sign-in': (context) => const SignInScreen(),
        '/sign-up': (context) => const SignUpScreen(),
        '/calendar': (context) => CalendarScreen(),
        '/profile': (context) => ProfileScreen(),
        '/counsel': (context) => CounselScreen(),
      },
    );
  }
}


class CheckLoginStatus extends StatefulWidget {
  const CheckLoginStatus({super.key});

  @override
  State<CheckLoginStatus> createState() => _CheckLoginStatusState();
}

class _CheckLoginStatusState extends State<CheckLoginStatus> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  // 로그인 상태 확인
  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    // 로그인 상태에 따라 화면 전환
    if (isLoggedIn) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // 로딩 중일 때는 아무 화면도 보여주지 않음 (혹은 로딩 인디케이터를 추가해도 좋습니다)
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}