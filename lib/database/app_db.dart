import 'dart:io';
import 'package:attendance_manager/database/tables.dart';
import 'package:drift/drift.dart';
import 'package:drift_sqflite/drift_sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import 'Dao/attendance_dao.dart';
import 'Dao/subject_dao.dart';

part 'app_db.g.dart';



// Database
@DriftDatabase(tables: [Subjects, AttendanceEntries], daos: [SubjectDao, AttendanceDao])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onUpgrade: (migrator, from, to) async {
          if (from < 2) {
            await migrator.addColumn(subjects, subjects.targetPercentage);
          }
        },
      );

  // Convenience getters
  @override
  SubjectDao get subjectDao => SubjectDao(this);
  @override
  AttendanceDao get attendanceDao => AttendanceDao(this);
}

// Open DB connection using drift_sqflite
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'attendance.sqlite'));
    return SqfliteQueryExecutor(
      path: file.path,
      logStatements: true, // optional: helps debugging SQL
    );
  });
}


