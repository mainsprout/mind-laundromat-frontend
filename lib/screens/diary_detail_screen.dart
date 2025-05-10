import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:mind_laundromat/models/diary.dart';
import 'package:mind_laundromat/widgets/custom_app_bar.dart';

class DiaryDetailScreen extends StatefulWidget {
  final int diaryId;

  const DiaryDetailScreen({super.key, required this.diaryId});

  @override
  State<DiaryDetailScreen> createState() => _DiaryDetailScreenState();
}

class _DiaryDetailScreenState extends State<DiaryDetailScreen> {
  Diary? _diary;

  @override
  void initState() {
    super.initState();
    fetchDiaryDetail();
  }

  Future<void> fetchDiaryDetail() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('access_token') ?? '';

      if (accessToken.isEmpty) {
        throw Exception("Access token is not available.");
      }

      final response = await http.get(
        Uri.parse('http://10.0.2.2:8080/cbt/${widget.diaryId}'),
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        if (data['code'] == 'S201') {
          setState(() {
            _diary = Diary.fromJson(data['data']);
          });
        } else {
          throw Exception(data['message']);
        }
      } else {
        throw Exception('Failed to load diary detail (code: ${response.statusCode})');
      }
    } catch (e) {
      print('Error fetching diary details: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Diary'),
      backgroundColor: Colors.white,
      body: _diary == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              DateFormat('yyyy-MM-dd HH:mm').format(_diary!.regDate),
              style: const TextStyle(fontSize: 18, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            Text(
              _diary!.summation,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              _diary!.beforeContent,
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              _diary!.afterContent,
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              _diary!.solution,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
