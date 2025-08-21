import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiClient {
  ApiClient({required this.baseUrl, http.Client? httpClient})
      : _client = httpClient ?? http.Client();

  final String baseUrl;
  final http.Client _client;

  Uri _u(String path, [Map<String, dynamic>? query]) {
    return Uri.parse('$baseUrl$path').replace(
      queryParameters: query?.map(
        (k, v) => MapEntry(k, v?.toString()),
      ),
    );
  }

  Future<Map<String, dynamic>> _get(String path, [Map<String, dynamic>? query]) async {
    final res = await _client.get(_u(path, query), headers: _jsonHeaders());
    _ensureOk(res);
    return _decode(res);
  }

  Future<Map<String, dynamic>> _post(String path, Map<String, dynamic> body) async {
    final res = await _client.post(
      _u(path),
      headers: _jsonHeaders(),
      body: jsonEncode(body),
    );
    _ensureOk(res);
    return _decode(res);
  }

  Map<String, String> _jsonHeaders() => const {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

  void _ensureOk(http.Response res) {
    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw ApiException('HTTP ${res.statusCode}: ${res.body}');
    }
  }

  Map<String, dynamic> _decode(http.Response res) {
    if (res.body.isEmpty) return <String, dynamic>{};
    final dynamic decoded = jsonDecode(res.body);
    if (decoded is Map<String, dynamic>) return decoded;
    return <String, dynamic>{'data': decoded};
  }

  // Endpoints
  Future<Map<String, dynamic>> gps() => _get('/gps');

  Future<Map<String, dynamic>> epf(double salary) =>
      _post('/epf', {'salary': salary});

  Future<Map<String, dynamic>> perkeso(double salary) =>
      _post('/perkeso', {'salary': salary});

  Future<Map<String, dynamic>> pcb(double salary) =>
      _post('/pcb', {'salary': salary});

  Future<Map<String, dynamic>> clockIn(String employeeId) =>
      _post('/clock_in', {'employee_id': employeeId});

  Future<List<dynamic>> attendance(String employeeId) async {
    final res = await _get('/attendance', {'employee_id': employeeId});
    return res['data'] as List<dynamic>? ?? (res as dynamic) as List<dynamic>? ?? <dynamic>[];
  }

  Future<Map<String, dynamic>> payroll(String employeeId) =>
      _get('/payroll', {'employee_id': employeeId});

  Future<Map<String, dynamic>> advance(String employeeId, double amount) =>
      _post('/advance', {'employee_id': employeeId, 'amount': amount});

  Future<Map<String, dynamic>> profile(String employeeId) =>
      _get('/profile', {'employee_id': employeeId});

  Future<Map<String, dynamic>> sendMessage({
    required String senderId,
    required String receiverId,
    required String message,
  }) =>
      _post('/chat', {
        'sender_id': senderId,
        'receiver_id': receiverId,
        'message': message,
      });

  Future<Map<String, dynamic>> translate({
    required String text,
    required String targetLanguage,
  }) =>
      _post('/translate', {
        'text': text,
        'target_language': targetLanguage,
      });
}

class ApiException implements Exception {
  ApiException(this.message);
  final String message;
  @override
  String toString() => 'ApiException: $message';
}
