import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

const String baseUrl = 'http://10.0.2.2:8080';
// 192.168.X.X:8080 for real device
// 10.0.2.2:8080 for emulator
// mindlaundry.help

class ApiService {
  // ---------- 토큰 ----------
  static Future<String> _getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    if (token == null || token.isEmpty) {
      throw Exception("Access token is missing");
    }
    return token;
  }

  // ---------- 가드: 로그인 유효성 검사 ----------
  /// 첫 로드 시 호출: 유효하면 true, 아니면 StartScreen으로 라우팅하고 false.
  static Future<bool> ensureAuthOrRedirect(BuildContext context) async {
    try {
      final token = await _getAccessToken();

      final uri = Uri.parse('$baseUrl/auth/info');
      final resp = await http
          .get(uri, headers: {'Authorization': 'Bearer $token'})
          .timeout(const Duration(seconds: 8));

      if (resp.statusCode == 200) {
        return true;
      } else {
        // 401 포함 기타 코드 → 비로그인 취급
        await _purgeToken();
        _redirectToStart(context);
        return false;
      }
    } on TimeoutException {
      // 네트워크 지연 등 → 일단 비로그인 취급(원하면 네트워크 재시도 UX 추가)
      await _purgeToken();
      _redirectToStart(context);
      return false;
    } catch (e) {
      debugPrint('Access token expired or request failed: $e');
      await _purgeToken();
      _redirectToStart(context);
      return false;
    }
  }

  static Future<void> _purgeToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  static void _redirectToStart(BuildContext context) {
    if (!context.mounted) return;
    Navigator.of(context).pushNamedAndRemoveUntil('/start', (route) => false);
  }

  // ---------- 일반 요청 ----------
  static Future<http.Response> get(String endpoint) async {
    final token = await _getAccessToken();
    final uri = Uri.parse('$baseUrl$endpoint');
    final response = await http.get(
      uri,
      headers: {'Authorization': 'Bearer $token'},
    );
    return _handleResponse(response);
  }

  static Future<http.Response> post(String endpoint, dynamic body) async {
    final token = await _getAccessToken();
    final uri = Uri.parse('$baseUrl$endpoint');
    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
      body: jsonEncode(body),
    );
    return _handleResponse(response);
  }

  static Future<http.Response> postMessage(String endpoint, dynamic cookie, dynamic body) async {
    final token = await _getAccessToken();
    final uri = Uri.parse('$baseUrl$endpoint');
    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
        'Cookie': cookie
      },
      body: jsonEncode(body),
    );
    return _handleResponse(response);
  }

  static Future<http.Response> put(String endpoint, dynamic body) async {
    final token = await _getAccessToken();
    final uri = Uri.parse('$baseUrl$endpoint');
    final response = await http.put(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
      body: jsonEncode(body),
    );
    return _handleResponse(response);
  }

  static Future<http.Response> patch(String endpoint, dynamic body) async {
    final token = await _getAccessToken();
    final uri = Uri.parse('$baseUrl$endpoint');
    final response = await http.patch(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
      body: jsonEncode(body),
    );
    return _handleResponse(response);
  }

  static Future<http.Response> delete(String endpoint) async {
    final token = await _getAccessToken();
    final uri = Uri.parse('$baseUrl$endpoint');
    final response = await http.delete(
      uri,
      headers: {'Authorization': 'Bearer $token'},
    );
    return _handleResponse(response);
  }

  static http.Response _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return response;
    } else {
      final body = jsonDecode(response.body);
      final message = body['message'] ?? 'Unknown error';
      throw Exception('API Error: $message');
    }
  }
}
