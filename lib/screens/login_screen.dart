import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(flex: 2),
            Center(
              child: Image.asset(
                'assets/logo.png',
                width: 200,
                height: 200,
                fit: BoxFit.contain,
              ),
            ),
            const Spacer(flex: 1),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/sign-up');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black87,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'GET STARTED',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/sign-in');
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      side: const BorderSide(color: Colors.black87),
                    ),
                    child: const Text(
                      'I HAVE AN ACCOUNT',
                      style: TextStyle(fontSize: 16, color: Colors.black87),
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(flex: 1),
          ],
        ),
      ),
    );
  }
}
