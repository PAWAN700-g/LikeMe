import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class UserSession {
  final String id;
  final String name;
  final String username;
  final String email;
  final String role;
  final String? city;
  final String? avatarUrl;

  UserSession({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    required this.role,
    this.city,
    this.avatarUrl,
  });

  factory UserSession.fromJson(Map<String, dynamic> json) {
    return UserSession(
      id: json['id'] as String,
      name: json['name'] as String,
      username: json['username'] as String,
      email: json['email'] as String,
      role: json['role'] as String,
      city: json['city'] as String?,
      avatarUrl: json['avatarUrl'] as String?,
    );
  }
}

class ApiService {
  ApiService._();
  static final ApiService instance = ApiService._();

  static String get baseUrl {
    const customUrl = String.fromEnvironment('API_URL', defaultValue: '');
    if (customUrl.isNotEmpty) return customUrl;

    const reelUrl = String.fromEnvironment('REELS_API_URL', defaultValue: '');
    if (reelUrl.isNotEmpty) return reelUrl;

    if (kIsWeb || defaultTargetPlatform == TargetPlatform.windows || defaultTargetPlatform == TargetPlatform.macOS) {
      return 'http://localhost:3000';
    }
    return 'http://10.0.2.2:3000';
  }

  UserSession? currentUser;

  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        if (currentUser != null) 'x-user-id': currentUser!.id,
      };

  Future<UserSession> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode != 200) {
      final errorJson = jsonDecode(response.body);
      throw Exception(errorJson['error'] ?? 'Login failed');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    currentUser = UserSession.fromJson(data);
    return currentUser!;
  }

  Future<UserSession> register({
    required String email,
    required String password,
    required String name,
    required String username,
    required String role,
    String? city,
    String? about,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
        'name': name,
        'username': username,
        'role': role,
        'city': city,
        'about': about,
      }),
    );

    if (response.statusCode != 201) {
      final errorJson = jsonDecode(response.body);
      throw Exception(errorJson['error'] ?? 'Registration failed');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    currentUser = UserSession.fromJson(data);
    return currentUser!;
  }

  Future<List<Map<String, dynamic>>> fetchReels() async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/reels'),
      headers: _headers,
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch reels (${response.statusCode})');
    }

    final List list = jsonDecode(response.body) as List;
    return list.cast<Map<String, dynamic>>();
  }

  Future<Map<String, dynamic>> publishReel(XFile file, String caption) async {
    if (currentUser == null) {
      throw Exception('Must be logged in to publish a reel');
    }

    final request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/api/reels'),
    )
      ..headers['x-user-id'] = currentUser!.id
      ..fields['caption'] = caption
      ..files.add(
        http.MultipartFile.fromBytes(
          'video',
          await file.readAsBytes(),
          filename: file.name,
        ),
      );

    final response = await request.send();
    final body = await response.stream.bytesToString();

    if (response.statusCode != 201) {
      throw Exception('Reel upload failed: ${response.statusCode}');
    }

    return jsonDecode(body) as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> toggleReelLike(String reelId) async {
    if (currentUser == null) {
      throw Exception('Must be logged in to like reels');
    }

    final response = await http.post(
      Uri.parse('$baseUrl/api/reels/$reelId/like'),
      headers: _headers,
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to toggle like');
    }

    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  Future<List<Map<String, dynamic>>> fetchModels() async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/models'),
      headers: _headers,
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch models (${response.statusCode})');
    }

    final List list = jsonDecode(response.body) as List;
    return list.cast<Map<String, dynamic>>();
  }

  Future<List<Map<String, dynamic>>> fetchJobs() async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/jobs'),
      headers: _headers,
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch jobs (${response.statusCode})');
    }

    final List list = jsonDecode(response.body) as List;
    return list.cast<Map<String, dynamic>>();
  }

  Future<Map<String, dynamic>> createJob({
    required String title,
    required String category,
    required String location,
    required String date,
    required int durationHours,
    required int budget,
    String? description,
    String? requirements,
  }) async {
    if (currentUser == null) {
      throw Exception('Must be logged in to create a job');
    }

    final response = await http.post(
      Uri.parse('$baseUrl/api/jobs'),
      headers: _headers,
      body: jsonEncode({
        'title': title,
        'category': category,
        'location': location,
        'date': date,
        'durationHours': durationHours,
        'budget': budget,
        'description': description,
        'requirements': requirements,
      }),
    );

    if (response.statusCode != 201) {
      final errorJson = jsonDecode(response.body);
      throw Exception(errorJson['error'] ?? 'Failed to create job');
    }

    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  Future<void> applyToJob(String jobId, {String? introduction, int? expectedFee}) async {
    if (currentUser == null) {
      throw Exception('Must be logged in to apply for a job');
    }

    final response = await http.post(
      Uri.parse('$baseUrl/api/jobs/$jobId/apply'),
      headers: _headers,
      body: jsonEncode({
        'introduction': introduction ?? 'Interested in this job opportunity.',
        'expectedFee': expectedFee,
      }),
    );

    if (response.statusCode != 201) {
      final errorJson = jsonDecode(response.body);
      throw Exception(errorJson['error'] ?? 'Failed to submit application');
    }
  }
}
