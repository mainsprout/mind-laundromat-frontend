import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();

  String _gender = 'Male'; // 기본 값: Male

  // 성별 선택 버튼 위젯
  Widget _genderSelector(String label) {
    final isSelected = _gender == label;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _gender = label;
          });
        },
        child: Container(
          height: 48,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: isSelected ? Colors.grey : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected ? Colors.grey : Colors.grey,
              width: 1.5,
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // TODO: 회원가입 API 호출
  Future<void> _signUp() async {
    final email = _emailController.text;
    final password = _passwordController.text;
    final name = _nameController.text;

    if (email.isEmpty || password.isEmpty || name.isEmpty) {
      // 빈 입력 처리
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter all items.")),
      );
      return;
    }

    // 회원가입 API 호출 (백엔드 연동은 나중에 구현)
    print("Email: $email, Name: $name, Password: $password, Gender: $_gender");

    // 회원가입 후 로그인 화면으로 이동 (백엔드 연결 후 변경 예정)
    Navigator.pushReplacementNamed(context, '/login');
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
                "Sign Up",
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

              // 이름 입력 필드
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
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
              const SizedBox(height: 16),

              Row(
                children: [
                  _genderSelector("Male"),
                  _genderSelector("Female"),
                ],
              ),
              const SizedBox(height: 24),

              // 회원가입 버튼
              ElevatedButton(
                onPressed: _signUp,
                child: const Text("Sign Up"),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                ),
              ),

              //const SizedBox(height: 8),

              // 로그인 화면으로 이동
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/sign-in');
                },
                child: const Text(
                  "Already have an account? Sign In",
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
