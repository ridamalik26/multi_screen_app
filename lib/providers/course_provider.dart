import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/course_model.dart';
import '../repositories/course_repository.dart';
import '../services/api_service.dart';
import '../services/local_storage_service.dart';

// ---------------------------------------------------------------------------
// Dependency providers (UI -> Notifier -> Repository -> ApiService/LocalStorage)
// ---------------------------------------------------------------------------

final apiServiceProvider = Provider<ApiService>((ref) => ApiService());

final localStorageServiceProvider =
    Provider<LocalStorageService>((ref) => LocalStorageService());

final courseRepositoryProvider = Provider<CourseRepository>((ref) {
  return CourseRepository(
    apiService: ref.watch(apiServiceProvider),
    localStorage: ref.watch(localStorageServiceProvider),
  );
});

/// Current search text used to filter the course list by title.
final searchQueryProvider = StateProvider<String>((ref) => '');

/// Course list filtered by [searchQueryProvider], preserving loading/error
/// state. The UI reads this for rendering and keeps the raw list in
/// [courseListProvider] for mutations.
final filteredCoursesProvider = Provider<AsyncValue<List<Course>>>((ref) {
  final coursesAsync = ref.watch(courseListProvider);
  final query = ref.watch(searchQueryProvider).trim().toLowerCase();
  return coursesAsync.whenData((courses) {
    if (query.isEmpty) return courses;
    return courses
        .where((c) => c.title.toLowerCase().contains(query))
        .toList();
  });
});

// ---------------------------------------------------------------------------
// Course list notifier
// ---------------------------------------------------------------------------

final courseListProvider =
    AsyncNotifierProvider<CourseListNotifier, List<Course>>(
  CourseListNotifier.new,
);

class CourseListNotifier extends AsyncNotifier<List<Course>> {
  CourseRepository get _repo => ref.read(courseRepositoryProvider);

  @override
  Future<List<Course>> build() async {
    // Re-sync when connectivity returns: server overwrites cache.
    final sub = _repo.onConnectivityChanged.listen((result) {
      final online = !result.contains(ConnectivityResult.none);
      if (online) {
        refresh();
      }
    });
    ref.onDispose(sub.cancel);

    // Initial load goes through AsyncLoading -> AsyncData/AsyncError.
    return _repo.getCourses();
  }

  /// Re-fetch fresh data and overwrite the cache. Returns a [Future] so it can
  /// drive [RefreshIndicator]. Does NOT flip to [AsyncLoading] — the existing
  /// list stays on screen while the pull-to-refresh spinner runs.
  Future<void> refresh() async {
    state = await AsyncValue.guard(() => _repo.getCourses());
  }

  /// Optimistically insert a new course, then confirm with the API.
  /// Uses a collision-proof temp id (negative epoch millis) so it can never
  /// clash with a real server id while the request is in flight.
  Future<void> addCourse(String title, String body) async {
    final previous = state.valueOrNull ?? const <Course>[];
    final tempId = -DateTime.now().millisecondsSinceEpoch;
    final optimistic = Course(id: tempId, title: title, body: body);
    final newList = <Course>[optimistic, ...previous];

    state = AsyncData(newList);
    try {
      final created = await _repo.addCourse(title, body);
      // Keep the collision-proof id; absorb any server-side field changes.
      final confirmed = <Course>[
        created.copyWith(id: tempId),
        ...previous,
      ];
      state = AsyncData(confirmed);
      await _repo.cacheCourses(confirmed);
    } catch (_) {
      state = AsyncData(previous); // rollback
      rethrow; // UI shows error snackbar
    }
  }

  /// Optimistically apply an edit, then confirm with the API.
  Future<void> updateCourse(Course updated) async {
    final previous = state.valueOrNull ?? const <Course>[];
    final newList = [
      for (final c in previous) if (c.id == updated.id) updated else c,
    ];

    state = AsyncData(newList);
    try {
      await _repo.updateCourse(updated.id, updated.title, updated.body);
      await _repo.cacheCourses(newList);
    } catch (_) {
      state = AsyncData(previous); // rollback
      rethrow; // UI shows error snackbar
    }
  }

  /// Optimistically remove a course, then confirm with the API.
  Future<void> deleteCourse(int id) async {
    final previous = state.valueOrNull ?? const <Course>[];
    final newList = previous.where((c) => c.id != id).toList();

    state = AsyncData(newList);
    try {
      await _repo.deleteCourse(id);
      await _repo.cacheCourses(newList);
    } catch (_) {
      state = AsyncData(previous); // rollback
      rethrow; // UI shows error snackbar
    }
  }
}
