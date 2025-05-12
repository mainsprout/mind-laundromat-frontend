import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'start_screen.dart';
import 'package:mind_laundromat/widgets/custom_app_bar.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _email = '';
  String _firstname = '';
  String _lastname = '';
  String _name = '';
  String _emotion = 'happiness';

  bool isEditingName = false;
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token') ?? '';

    try {
      final response = await http.get(
        Uri.parse('http://10.0.2.2:8080/auth/info'),
        headers: {'Authorization': 'Bearer $token'}, // 'Bearer ' 붙여서 보냄
      );

      if (response.statusCode == 200) {
        final decodedBody = utf8.decode(response.bodyBytes);
        final data = json.decode(decodedBody);
        final userInfo = data['data'];

        setState(() {
          _email = userInfo['email'];
          _firstname = userInfo['first_name'];
          _lastname = userInfo['last_name'];
          _name = '$_firstname $_lastname';
          // TODO: 유저가 선택한 감정
          firstNameController.text = _firstname;
          lastNameController.text = _lastname;
        });
      } else {
        print('Failed to fetch user info. Status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching user info: $e');
    }
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => StartScreen()),
            (Route<dynamic> route) => false,
      );
    }
  }

  Future<void> _deleteAccount() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token') ?? '';

    try {
      final response = await http.delete(
        Uri.parse('http://10.0.2.2:8080/auth'),
        headers: {'Authorization': 'Bearer $token'}, // 'Bearer ' 붙여서 보냄
      );

      if (response.statusCode == 200) {
        await prefs.clear();
        await prefs.setBool('isLoggedIn', false);

        if (mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => StartScreen()),
                (Route<dynamic> route) => false,
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to delete account. (${response.statusCode})")),
        );
      }
    } catch (e) {
      print('Error deleting account: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error occurred while deleting account.")),
      );
    }
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(title: 'Profile'),
      body: Padding(
        //padding: const EdgeInsets.all(40.0),
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 70),

            // 이름 + 이메일 + 이미지
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 감정 이미지
                ClipRRect(
                  borderRadius: BorderRadius.circular(40),
                  child: Image.asset(
                    'assets/emotions/$_emotion.png',
                    width: 64,
                    height: 64,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 16),

                // 이름, 이메일 (또는 TextField)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      isEditingName
                          ? Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: firstNameController,
                              decoration: const InputDecoration(
                                isDense: true, // 내부 패딩도 줄임
                                contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 2),
                                //border: OutlineInputBorder(),
                                hintText: 'First Name',
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              controller: lastNameController,
                              decoration: const InputDecoration(
                                isDense: true, // 내부 패딩도 줄임
                                contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 2),
                                //border: OutlineInputBorder(),
                                hintText: 'Last Name',
                              ),
                            ),
                          ),
                        ],
                      )
                          : Text(
                        _name,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _email,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 8),

                // 편집 아이콘
                GestureDetector(
                  onTap: () {
                    setState(() {
                      if (isEditingName) {
                        // 편집 완료 → 저장
                        _firstname = firstNameController.text;
                        _lastname = lastNameController.text;
                        _name = '$_firstname $_lastname';

                        // 여기에 서버 전송 코드 나중에 넣으면 됨
                        print('저장됨: $_firstname $_lastname');
                      } else {
                        // 편집 시작 → 현재 이름값 세팅
                        firstNameController.text = _firstname;
                        lastNameController.text = _lastname;
                      }

                      isEditingName = !isEditingName;
                    });
                  },
                  child: Padding(padding: const EdgeInsets.only(top: 10.0),
                    child: Image.asset(
                      isEditingName
                          ? 'assets/icons/edit1.png'
                          : 'assets/icons/edit2.png',
                      width: 28,
                      height: 28,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 40),

            // 로그아웃
            GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Log out'),
                    content: const Text('Are you sure you want to log out?'),
                    backgroundColor: Colors.white,
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context), // 취소
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context); // 다이얼로그 닫고
                          _logout();              // 로그아웃 실행
                        },
                        child: const Text(
                          'Log out',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                );
              },
              child: const Text(
                'Log out',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.red,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // 계정삭제
            GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Delete Account'),
                    backgroundColor: Colors.white,
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('Are you sure you want to delete your account?'),
                        SizedBox(height: 12),
                        Text(
                          'This action cannot be undone.',
                          style: TextStyle(color: Colors.red),
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          _deleteAccount();
                        },
                        child: const Text(
                          'Delete',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                );
              },
              child: const Text(
                'Delete Account',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black45,
                ),
              ),
            ),
            const SizedBox(height: 40),

            // FAQ
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/faq');
              },
              child: const Text(
                'FAQ',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
