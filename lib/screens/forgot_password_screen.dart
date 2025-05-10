import 'package:flutter/material.dart';
import 'package:mind_laundromat/widgets/custom_app_bar.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: '', backgroundColor: Color(0xFFADCCEC),),
      backgroundColor: Color(0xFFADCCEC),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Text(
            "Forgot Password page (임시)\n\n비밀번호 재설정 기능이 여기에 구현될 예정입니다.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }
}
