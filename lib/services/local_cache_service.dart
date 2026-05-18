import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class LocalCacheService {
  static const _downloadedLessonsKey = 'downloaded_lessons';
  static const _pendingProgressKey = 'pending_progress';

  Future<void> saveDownloadedLessons(List<Map<String, dynamic>> lessons) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_downloadedLessonsKey, jsonEncode(lessons));
  }

  Future<List<Map<String, dynamic>>> loadDownloadedLessons() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_downloadedLessonsKey);
    if (raw == null) return [];
    return (jsonDecode(raw) as List)
        .map((item) => Map<String, dynamic>.from(item as Map))
        .toList();
  }

  Future<void> queueProgressSync(Map<String, dynamic> progress) async {
    final prefs = await SharedPreferences.getInstance();
    final existing = prefs.getStringList(_pendingProgressKey) ?? [];
    await prefs.setStringList(_pendingProgressKey, [...existing, jsonEncode(progress)]);
  }
}
