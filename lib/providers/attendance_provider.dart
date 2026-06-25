import 'dart:async';
import 'package:flutter/foundation.dart';

import '../database/Dao/attendance_dao.dart';
import '../database/app_db.dart';

class AttendanceProvider extends ChangeNotifier {
  final AttendanceDao _dao;

  int? _activeSubjectId;
  int? get activeSubjectId => _activeSubjectId;

  // Per-subject entries
  List<AttendanceEntry> _entries = [];
  List<AttendanceEntry> get entries => List.unmodifiable(_entries);

  // All-subjects totals (for home page)
  Map<int, ({int attended, int total})> _allTotals = {};
  Map<int, ({int attended, int total})> get allTotals =>
      Map.unmodifiable(_allTotals);

  // Loading & error
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  StreamSubscription<List<AttendanceEntry>>? _entrySub;
  StreamSubscription<Map<int, ({int attended, int total})>>? _totalsSub;

  AttendanceProvider(this._dao) {
    _watchAllTotals();
  }

  // ── Home-page totals ──────────────────────────────────────────────

  void _watchAllTotals() {
    _totalsSub = _dao.watchAllSubjectTotals().listen(
      (totals) {
        _allTotals = totals;
        notifyListeners();
      },
      onError: (e) {
        debugPrint('AttendanceProvider totals error: $e');
      },
    );
  }

  /// Get attended/total for a subject. Returns (0,0) if unknown.
  ({int attended, int total}) totalsFor(int subjectId) =>
      _allTotals[subjectId] ?? (attended: 0, total: 0);

  // ── Per-subject detail ────────────────────────────────────────────

  /// Start watching entries for a specific subject (call when navigating in).
  void loadSubject(int subjectId) {
    _activeSubjectId = subjectId;
    _entrySub?.cancel();
    _isLoading = true;
    notifyListeners();

    _entrySub = _dao.watchEntriesForSubject(subjectId).listen(
      (list) {
        _entries = list;
        _isLoading = false;
        _error = null;
        notifyListeners();
      },
      onError: (e) {
        _error = e.toString();
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  /// Save or update attendance for the active subject on a given date.
  Future<void> saveAttendance({
    required DateTime date,
    required int attended,
    required int total,
  }) async {
    if (_activeSubjectId == null) return;

    try {
      // Check if an entry already exists for this subject+date
      final existing = _entries.where((e) =>
          e.date.year == date.year &&
          e.date.month == date.month &&
          e.date.day == date.day);

      if (existing.isNotEmpty) {
        await _dao.updateEntry(
            id: existing.first.id, attended: attended, total: total);
      } else {
        await _dao.insertEntry(
          subjectId: _activeSubjectId!,
          date: date,
          attended: attended,
          total: total,
        );
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  /// Delete a single attendance entry.
  Future<void> deleteAttendance(int entryId) async {
    try {
      await _dao.deleteEntry(entryId);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  // ── Computed helpers ──────────────────────────────────────────────

  int get totalAttended =>
      _entries.fold(0, (sum, e) => sum + e.attendedSessions);

  int get totalSessions =>
      _entries.fold(0, (sum, e) => sum + e.totalSessions);

  double get overallPercent =>
      totalSessions == 0 ? 0 : totalAttended / totalSessions;

  /// Lookup attendance for a specific date (for the active subject).
  AttendanceEntry? entryForDate(DateTime date) {
    final d = DateTime(date.year, date.month, date.day);
    for (final e in _entries) {
      final ed = DateTime(e.date.year, e.date.month, e.date.day);
      if (ed == d) return e;
    }
    return null;
  }

  /// Map of date → {attended, total} for calendar markers.
  Map<DateTime, ({int attended, int total})> get attendanceByDate {
    final Map<DateTime, ({int attended, int total})> result = {};
    for (final e in _entries) {
      final d = DateTime(e.date.year, e.date.month, e.date.day);
      result[d] = (attended: e.attendedSessions, total: e.totalSessions);
    }
    return result;
  }

  @override
  void dispose() {
    _entrySub?.cancel();
    _totalsSub?.cancel();
    super.dispose();
  }
}
