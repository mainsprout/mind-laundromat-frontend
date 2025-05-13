import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mind_laundromat/models/diary.dart';
import 'package:mind_laundromat/screens/diary_detail_screen.dart';

class CounselScreen extends StatefulWidget {
  const CounselScreen({super.key});

  @override
  State<CounselScreen> createState() => _CounselScreenState();
}

class _CounselScreenState extends State<CounselScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];

  String _userEmotion ='';
  String _botEmotion = '';
  bool _isSending = false;
  String _diaryId = '';

  // 초기 메시지
  @override
  void initState() {
    super.initState();
    _fetchUserEmotion();
    _fetchBotEmotion();
    _messages.add({
      'role': 'bot',
      'content': 'Hello! What are you worried about? Feel free to tell me. 😊',
    });
  }

  // SharedPreferences에서 감정 값을 불러오기
  Future<void> _fetchUserEmotion() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedEmotion = prefs.getString('selected_emotion');
      if (savedEmotion != null && savedEmotion.isNotEmpty) {
        setState(() {
          _userEmotion = savedEmotion.toUpperCase();
        });
      }
      prefs.remove('selected_emotion');
    } catch (e) {
      print('Failed to load emotion: $e');
    }
  }

  // 유저 정보에서 봇 프로필 가져오기
  Future<void> _fetchBotEmotion() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('access_token') ?? '';

      if (accessToken.isEmpty) {
        throw Exception("Access token is not available.");
      }
      final response = await http.get(
        Uri.parse('http://10.0.2.2:8080/auth/info'),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final emotion = data['data']['emotion']?.toString().toLowerCase();
        if (emotion != null && emotion.isNotEmpty) {
          setState(() {
            _botEmotion = emotion;
          });
        }
      }
    } catch (e) {
      print('Failed to load emotion: $e');
    }
  }

  // 메시지 주고받기
  Future<void> _sendMessage() async {
    final userInput = _controller.text.trim();
    if (userInput.isEmpty || _isSending) return;

    setState(() {
      _messages.add({'role': 'user', 'content': userInput});
      _isSending = true;
      _controller.clear();
    });
    try {
      final prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('access_token') ?? '';

      if (accessToken.isEmpty) {
        throw Exception("Access token is not available.");
      }

      //메시지 보내기
      final String body = userInput;

      final response = await http.post(
        Uri.parse('http://10.0.2.2:8080/gemini/chat'),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: json.encode(body),
      );

      // 메시지 받기
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final String botResponse = data['gemini']!;

        setState(() {
          _messages.add({'role': 'bot', 'content': botResponse});
        });
      } else {
        print('Failed to receive message. Status: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        _messages.add({'role': 'bot', 'content': 'An error occurred.'});
      });
    } finally {
      setState(() {
        _isSending = false;
      });
    }
  }

  // 종료 시그널 보내기
  Future<void> _sendEndSignal() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('access_token') ?? '';

      if (accessToken.isEmpty) {
        throw Exception("Access token is not available.");
      }

      // 종료 시그널 및 감정 정보 보내기
      final response = await http.post(
        Uri.parse('http://10.0.2.2:8080/gemini/chat/complete?emotion=$_userEmotion'),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );

      // 전체 다이어리 정보 받기
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        _diaryId = data['diary_id'];
        print('다이어리 아이디는 $_diaryId');
      } else {
        print("HTTP 오류 상태 코드: ${response.statusCode}");
      }
    } catch (e) {
      print("예외 발생: $e");
    }
  }

  Future<void> _getDiary()async{
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('access_token') ?? '';

    if (accessToken.isEmpty) {
      throw Exception("Access token is not available.");
    }

    try {
      // 종료 시그널 및 감정 정보 보내기
      final response = await http.get(
        Uri.parse('http://10.0.2.2:8080/cbt/$_diaryId'),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );

      // 전체 다이어리 정보 받기
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        if (data['code'] == 'S201') {
          // 서버에서 받은 다이어리 데이터
          final diaryJson = data['data'];
          final Diary diary = Diary.fromJson(diaryJson);

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => DiaryDetailScreen(diary: diary),
            ),
          );
        } else {
          print("서버 응답 코드: ${data['code']}, 메시지: ${data['message']}");
        }
      } else {
        print("HTTP 오류 상태 코드: ${response.statusCode}");
      }
    } catch (e) {
      print("예외 발생!!: $e");
    }
  }

  // 뒤로가기 버튼 클릭 시 동작
  void _goBack() {
    Navigator.pop(context);
  }

  // 챗 종료
  void _endChat() {
    _sendEndSignal();
    _getDiary();
  }

  Widget _buildMessage(Map<String, String> message) {
    final isUser = message['role'] == 'user';

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment:
        isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isUser)
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: _botEmotion.isNotEmpty
                ? Image.asset(
                  'assets/emotions/$_botEmotion.png',
                  width: 32,
                  height: 32,
                  //fit: BoxFit.cover,
                ) : Container(
                  width: 32,
                  height: 32,
                  color: Colors.grey[200], // 로딩 중일 때 배경
                ),
              ),
            ),
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(12),
              constraints: const BoxConstraints(maxWidth: 250),
              decoration: BoxDecoration(
                color: isUser
                    ? const Color(0xFFFEFEFE)
                    : const Color(0xFFADCCEC),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(isUser ? 12 : 0),
                  topRight: Radius.circular(isUser ? 0 : 12),
                  bottomLeft: const Radius.circular(12),
                  bottomRight: const Radius.circular(12),
                ),
              ),
              child: Text(
                message['content'] ?? '',
                style: TextStyle(
                  color:
                  isUser ? const Color(0xFF313131) : Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEDEDED),
      //appBar: const CustomAppBar(title: ''),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0),  // 왼쪽 아이콘과 벽 사이의 간격 설정
          child: IconButton(
            icon: const Icon(Icons.chevron_left, color: Colors.black, size: 30),
            onPressed: _goBack,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),  // 오른쪽 아이콘과 벽 사이의 간격 설정
            child: IconButton(
              icon: const Icon(Icons.exit_to_app, color: Colors.black, size: 30),
              onPressed: _endChat,
            ),
          ),
        ],
        toolbarHeight: 60,
      ),

      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              padding: const EdgeInsets.all(12),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final reversedIndex = _messages.length - 1 - index;
                return _buildMessage(_messages[reversedIndex]);
              },
            ),
          ),
          if (_isSending)
            const Padding(
              padding: EdgeInsets.only(bottom: 12),
              child: CircularProgressIndicator(),
            ),
          Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            padding: const EdgeInsets.fromLTRB(12, 16, 12, 32),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextField(
                      controller: _controller,
                      decoration: const InputDecoration(
                        hintText: 'Send Message...',
                        hintStyle: TextStyle(color: Colors.grey),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: _sendMessage,
                  child: Transform.rotate(
                    angle: -0.2,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFADCCEC),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.send,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
