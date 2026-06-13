import 'package:connectivity_plus/connectivity_plus.dart';

import '../models/course_model.dart';
import '../services/api_service.dart';
import '../services/local_storage_service.dart';

/// Data-logic layer between the providers and the raw data sources.
///
/// Decides whether to read from the network ([ApiService]) or from the local
/// cache ([LocalStorageService]) based on connectivity, and keeps the cache in
/// sync after successful network reads.
class CourseRepository {
  CourseRepository({
    required ApiService apiService,
    required LocalStorageService localStorage,
    Connectivity? connectivity,
  })  : _api = apiService,
        _local = localStorage,
        _connectivity = connectivity ?? Connectivity();

  final ApiService _api;
  final LocalStorageService _local;
  final Connectivity _connectivity;

  /// Emits whenever the device's connectivity interfaces change.
  Stream<List<ConnectivityResult>> get onConnectivityChanged =>
      _connectivity.onConnectivityChanged;

  /// Online if any interface is present (i.e. the list is not just `[none]`).
  /// Note: this reflects interface state, not real reachability — callers must
  /// still handle network exceptions (see [getCourses]).
  Future<bool> isOnline() async {
    final result = await _connectivity.checkConnectivity();
    return !result.contains(ConnectivityResult.none);
  }

  /// Returns courses, preferring the network when available.
  ///
  /// - Offline: returns the cached list.
  /// - Online: attempts a fresh fetch, overwrites the cache on success, and
  ///   falls back to the cache on ANY network exception (connectivity only
  ///   reports interface state, not actual internet reachability).
  Future<List<Course>> getCourses() async {
    final online = await isOnline();
    if (!online) {
      return _local.loadCourses();
    }
    try {
      final courses = await _api.fetchCourses();
      await _local.saveCourses(courses);
      return courses;
    } catch (_) {
      // Interface up but request failed (no real internet, server down, etc.).
      return _local.loadCourses();
    }
  }

  /// Persist the given list to the local cache. Used by the notifier to keep
  /// the cache aligned with optimistic state after a confirmed write.
  Future<void> cacheCourses(List<Course> courses) => _local.saveCourses(courses);

  Future<Course> addCourse(String title, String body) =>
      _api.addCourse(title, body);

  Future<Course> updateCourse(int id, String title, String body) =>
      _api.updateCourse(id, title, body);

  Future<void> deleteCourse(int id) => _api.deleteCourse(id);
}
