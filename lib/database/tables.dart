import 'package:drift/drift.dart';

class Subjects extends Table{
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1,max: 100)();
  IntColumn get targetPercentage => integer().withDefault(const Constant(75))();
}

class AttendanceEntries extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get subjectId =>
      integer().references(Subjects, #id, onDelete: KeyAction.cascade)();
  DateTimeColumn get date => dateTime()();
  IntColumn get totalSessions => integer().withDefault(const Constant(1))();
  IntColumn get attendedSessions => integer().withDefault(const Constant(0))();
}