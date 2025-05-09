import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // 로그인 성공 후 상태 저장
  Future<void> _signIn() async {
    final email = _emailController.text;
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      // 빈 입력 처리
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter your email address and password.")),
      );
      return;
    }

    // 로그인 API 호출 (백엔드 연동)
    final response = await _loginApi(email, password);

    if (response != null && response['token'] != null) {
      // 로그인 성공 후 SharedPreferences에 상태 저장
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true); // 로그인 상태 저장
      await prefs.setString('access_token', response['token']);  // 로그인 응답에서 받은 토큰

      // 로그인 후 홈 화면으로 이동
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      // 로그인 실패 처리
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Invalid email or password")),
      );
    }
  }

  // 로그인 API 호출
  Future<Map<String, dynamic>?> _loginApi(String email, String password) async {
    final url = 'http://10.0.2.2:8080/login';

    try {
      var request = http.MultipartRequest('POST', Uri.parse(url));
      request.fields['username'] = email;
      request.fields['password'] = password;

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      print('Status: ${response.statusCode}');
      print('Headers: ${response.headers}');

      if (response.statusCode == 200) {
        final token = response.headers['authorization'];
        if (token != null && token.startsWith('Bearer ')) {
          return {'token': token}; // Bearer 포함해서 저장 (필요시 split 가능)
        } else {
          print('Token not found in headers.');
          return null;
        }
      } else {
        print('Failed with status ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                "Sign In",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 40),

              // 이메일 입력 필드
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // 비밀번호 입력 필드
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),

              // 로그인 버튼
              ElevatedButton(
                onPressed: _signIn,
                child: const Text("Sign In"),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                ),
              ),

              // 회원가입 화면으로 이동
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/sign-up');
                },
                child: const Text(
                  "Don't have an account? Sign Up",
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
