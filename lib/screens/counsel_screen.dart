import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CounselScreen extends StatefulWidget {
  const CounselScreen({super.key});

  @override
  State<CounselScreen> createState() => _CounselScreenState();
}

class _CounselScreenState extends State<CounselScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = []; // role: user or bot, content

  bool _isSending = false;

  Future<void> _sendMessage() async {
    final userInput = _controller.text.trim();
    if (userInput.isEmpty || _isSending) return;

    setState(() {
      _messages.add({'role': 'user', 'content': userInput});
      _isSending = true;
      _controller.clear();
    });

    try {
      // API 호출 (임시로 지연 후 고정 응답)
      await Future.delayed(const Duration(seconds: 1));
      final botResponse = '안녕하세요! 무엇을 도와드릴까요?'; // ← 여기에 실제 API 응답 넣기

      // 실제 API 호출 예시
      /*
      final response = await http.post(
        Uri.parse('https://your-api.com/chat'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'message': userInput}),
      );
      final data = jsonDecode(response.body);
      final botResponse = data['reply'] ?? '답변을 가져오지 못했습니다.';
      */

      setState(() {
        _messages.add({'role': 'bot', 'content': botResponse});
      });
    } catch (e) {
      setState(() {
        _messages.add({'role': 'bot', 'content': '오류가 발생했습니다.'});
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
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Container(
        padding: const EdgeInsets.all(12),
        constraints: const BoxConstraints(maxWidth: 250),
        decoration: BoxDecoration(
          color: isUser ? Colors.black : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          message['content'] ?? '',
          style: TextStyle(color: isUser ? Colors.white : Colors.black),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('상담 챗봇'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
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
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: '메시지를 입력하세요...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _sendMessage,
                  color: Colors.black,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
