// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attendance_dao.dart';

// ignore_for_file: type=lint
mixin _$AttendanceDaoMixin on DatabaseAccessor<AppDatabase> {
  $SubjectsTable get subjects => attachedDatabase.subjects;
  $AttendanceEntriesTable get attendanceEntries =>
      attachedDatabase.attendanceEntries;
  AttendanceDaoManager get managers => AttendanceDaoManager(this);
}

class AttendanceDaoManager {
  final _$AttendanceDaoMixin _db;
  AttendanceDaoManager(this._db);
  $$SubjectsTableTableManager get subjects =>
      $$SubjectsTableTableManager(_db.attachedDatabase, _db.subjects);
  $$AttendanceEntriesTableTableManager get attendanceEntries =>
      $$AttendanceEntriesTableTableManager(
        _db.attachedDatabase,
        _db.attendanceEntries,
      );
}
