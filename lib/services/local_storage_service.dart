import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/course_model.dart';

/// Caches the course list locally using SharedPreferences.
///
/// The whole `List<Course>` is JSON-encoded into a single string key so it can
/// be written/read in one shot. This keeps its own dedicated key and never
/// touches the auth keys owned by [AuthService].
class LocalStorageService {
  static const String _coursesKey = 'cached_courses';

  /// JSON-encode the course list and persist it under a single key.
  Future<void> saveCourses(List<Course> courses) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = json.encode(courses.map((c) => c.toJson()).toList());
    await prefs.setString(_coursesKey, encoded);
  }

  /// Decode and return the cached course list, or an empty list if nothing
  /// has been cached yet (or the stored value is empty/corrupt).
  Future<List<Course>> loadCourses() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_coursesKey);
    if (raw == null || raw.isEmpty) {
      return [];
    }
    try {
      final List<dynamic> decoded = json.decode(raw) as List<dynamic>;
      return decoded
          .map((e) => Course.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      // Corrupt cache — treat as empty rather than crashing.
      return [];
    }
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_coursesKey);
  }
}
