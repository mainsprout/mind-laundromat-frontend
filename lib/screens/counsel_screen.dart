import 'package:flutter/material.dart';
import '../widgets/custom_app_bar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class CounselScreen extends StatefulWidget {
  const CounselScreen({super.key});

  @override
  State<CounselScreen> createState() => _CounselScreenState();
}

class _CounselScreenState extends State<CounselScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];

  String _emotion = '';
  bool _isSending = false;

  // 초기 메시지
  @override
  void initState() {
    super.initState();
    _fetchUserEmotion();
    _messages.add({
      'role': 'bot',
      'content': 'Hello! What are you worried about? Feel free to tell me. 😊',
    });
  }

  Future<void> _fetchUserEmotion() async {
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
            _emotion = emotion;
          });
        }
      }
    } catch (e) {
      print('Failed to load emotion: $e');
    }
  }

  Future<void> _sendMessage() async {
    final userInput = _controller.text.trim();
    if (userInput.isEmpty || _isSending) return;

    setState(() {
      _messages.add({'role': 'user', 'content': userInput});
      _isSending = true;
      _controller.clear();
    });

    try {
      // TODO: api 연동
      await Future.delayed(const Duration(seconds: 1));
      final botResponse = 'You are truly the best.';

      setState(() {
        _messages.add({'role': 'bot', 'content': botResponse});
      });
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
                child: _emotion.isNotEmpty
                ? Image.asset(
                  'assets/emotions/$_emotion.png',
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
      appBar: const CustomAppBar(title: ''),
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
