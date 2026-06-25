import 'package:drift/drift.dart';

import '../app_db.dart';
import '../tables.dart';

part 'attendance_dao.g.dart';

@DriftAccessor(tables: [AttendanceEntries])
class AttendanceDao extends DatabaseAccessor<AppDatabase>
    with _$AttendanceDaoMixin {
  final AppDatabase db;

  AttendanceDao(this.db) : super(db);

  /// Watch all entries for a subject, ordered by date descending.
  Stream<List<AttendanceEntry>> watchEntriesForSubject(int subjectId) {
    return (select(attendanceEntries)
          ..where((t) => t.subjectId.equals(subjectId))
          ..orderBy([(t) => OrderingTerm.desc(t.date)]))
        .watch();
  }

  /// Get all entries for a subject (one-shot).
  Future<List<AttendanceEntry>> getEntriesForSubject(int subjectId) {
    return (select(attendanceEntries)
          ..where((t) => t.subjectId.equals(subjectId))
          ..orderBy([(t) => OrderingTerm.desc(t.date)]))
        .get();
  }

  /// Insert or update attendance for a specific subject + date.
  Future<int> insertOrUpdateEntry({
    required int subjectId,
    required DateTime date,
    required int attended,
    required int total,
  }) {
    return into(attendanceEntries).insertOnConflictUpdate(
      AttendanceEntriesCompanion(
        subjectId: Value(subjectId),
        date: Value(date),
        totalSessions: Value(total),
        attendedSessions: Value(attended),
      ),
    );
  }

  /// Insert a new entry (always creates a new row).
  Future<int> insertEntry({
    required int subjectId,
    required DateTime date,
    required int attended,
    required int total,
  }) {
    return into(attendanceEntries).insert(
      AttendanceEntriesCompanion(
        subjectId: Value(subjectId),
        date: Value(date),
        totalSessions: Value(total),
        attendedSessions: Value(attended),
      ),
    );
  }

  /// Update an existing entry by its ID.
  Future<bool> updateEntry({
    required int id,
    required int attended,
    required int total,
  }) {
    return (update(attendanceEntries)..where((t) => t.id.equals(id)))
        .write(AttendanceEntriesCompanion(
          totalSessions: Value(total),
          attendedSessions: Value(attended),
        ))
        .then((rows) => rows > 0);
  }

  /// Delete an entry by ID.
  Future<int> deleteEntry(int id) {
    return (delete(attendanceEntries)..where((t) => t.id.equals(id))).go();
  }

  /// Get totals (attended, total) across all entries for a subject.
  Future<({int attended, int total})> getTotalsForSubject(int subjectId) async {
    final entries = await getEntriesForSubject(subjectId);
    int attended = 0;
    int total = 0;
    for (final e in entries) {
      attended += e.attendedSessions;
      total += e.totalSessions;
    }
    return (attended: attended, total: total);
  }

  /// Watch totals for all subjects at once (for the home page).
  Stream<Map<int, ({int attended, int total})>> watchAllSubjectTotals() {
    return select(attendanceEntries).watch().map((entries) {
      final Map<int, ({int attended, int total})> result = {};
      for (final e in entries) {
        final existing = result[e.subjectId];
        result[e.subjectId] = (
          attended: (existing?.attended ?? 0) + e.attendedSessions,
          total: (existing?.total ?? 0) + e.totalSessions,
        );
      }
      return result;
    });
  }
}
