// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_db.dart';

// ignore_for_file: type=lint
class $SubjectsTable extends Subjects with TableInfo<$SubjectsTable, Subject> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SubjectsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 100,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _targetPercentageMeta = const VerificationMeta(
    'targetPercentage',
  );
  @override
  late final GeneratedColumn<int> targetPercentage = GeneratedColumn<int>(
    'target_percentage',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(75),
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, targetPercentage];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'subjects';
  @override
  VerificationContext validateIntegrity(
    Insertable<Subject> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('target_percentage')) {
      context.handle(
        _targetPercentageMeta,
        targetPercentage.isAcceptableOrUnknown(
          data['target_percentage']!,
          _targetPercentageMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Subject map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Subject(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      targetPercentage: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}target_percentage'],
      )!,
    );
  }

  @override
  $SubjectsTable createAlias(String alias) {
    return $SubjectsTable(attachedDatabase, alias);
  }
}

class Subject extends DataClass implements Insertable<Subject> {
  final int id;
  final String name;
  final int targetPercentage;
  const Subject({
    required this.id,
    required this.name,
    required this.targetPercentage,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['target_percentage'] = Variable<int>(targetPercentage);
    return map;
  }

  SubjectsCompanion toCompanion(bool nullToAbsent) {
    return SubjectsCompanion(
      id: Value(id),
      name: Value(name),
      targetPercentage: Value(targetPercentage),
    );
  }

  factory Subject.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Subject(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      targetPercentage: serializer.fromJson<int>(json['targetPercentage']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'targetPercentage': serializer.toJson<int>(targetPercentage),
    };
  }

  Subject copyWith({int? id, String? name, int? targetPercentage}) => Subject(
    id: id ?? this.id,
    name: name ?? this.name,
    targetPercentage: targetPercentage ?? this.targetPercentage,
  );
  Subject copyWithCompanion(SubjectsCompanion data) {
    return Subject(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      targetPercentage: data.targetPercentage.present
          ? data.targetPercentage.value
          : this.targetPercentage,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Subject(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('targetPercentage: $targetPercentage')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, targetPercentage);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Subject &&
          other.id == this.id &&
          other.name == this.name &&
          other.targetPercentage == this.targetPercentage);
}

class SubjectsCompanion extends UpdateCompanion<Subject> {
  final Value<int> id;
  final Value<String> name;
  final Value<int> targetPercentage;
  const SubjectsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.targetPercentage = const Value.absent(),
  });
  SubjectsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.targetPercentage = const Value.absent(),
  }) : name = Value(name);
  static Insertable<Subject> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<int>? targetPercentage,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (targetPercentage != null) 'target_percentage': targetPercentage,
    });
  }

  SubjectsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<int>? targetPercentage,
  }) {
    return SubjectsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      targetPercentage: targetPercentage ?? this.targetPercentage,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (targetPercentage.present) {
      map['target_percentage'] = Variable<int>(targetPercentage.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SubjectsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('targetPercentage: $targetPercentage')
          ..write(')'))
        .toString();
  }
}

class $AttendanceEntriesTable extends AttendanceEntries
    with TableInfo<$AttendanceEntriesTable, AttendanceEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AttendanceEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _subjectIdMeta = const VerificationMeta(
    'subjectId',
  );
  @override
  late final GeneratedColumn<int> subjectId = GeneratedColumn<int>(
    'subject_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES subjects (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalSessionsMeta = const VerificationMeta(
    'totalSessions',
  );
  @override
  late final GeneratedColumn<int> totalSessions = GeneratedColumn<int>(
    'total_sessions',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _attendedSessionsMeta = const VerificationMeta(
    'attendedSessions',
  );
  @override
  late final GeneratedColumn<int> attendedSessions = GeneratedColumn<int>(
    'attended_sessions',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    subjectId,
    date,
    totalSessions,
    attendedSessions,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'attendance_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<AttendanceEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('subject_id')) {
      context.handle(
        _subjectIdMeta,
        subjectId.isAcceptableOrUnknown(data['subject_id']!, _subjectIdMeta),
      );
    } else if (isInserting) {
      context.missing(_subjectIdMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('total_sessions')) {
      context.handle(
        _totalSessionsMeta,
        totalSessions.isAcceptableOrUnknown(
          data['total_sessions']!,
          _totalSessionsMeta,
        ),
      );
    }
    if (data.containsKey('attended_sessions')) {
      context.handle(
        _attendedSessionsMeta,
        attendedSessions.isAcceptableOrUnknown(
          data['attended_sessions']!,
          _attendedSessionsMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AttendanceEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AttendanceEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      subjectId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}subject_id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      totalSessions: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_sessions'],
      )!,
      attendedSessions: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}attended_sessions'],
      )!,
    );
  }

  @override
  $AttendanceEntriesTable createAlias(String alias) {
    return $AttendanceEntriesTable(attachedDatabase, alias);
  }
}

class AttendanceEntry extends DataClass implements Insertable<AttendanceEntry> {
  final int id;
  final int subjectId;
  final DateTime date;
  final int totalSessions;
  final int attendedSessions;
  const AttendanceEntry({
    required this.id,
    required this.subjectId,
    required this.date,
    required this.totalSessions,
    required this.attendedSessions,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['subject_id'] = Variable<int>(subjectId);
    map['date'] = Variable<DateTime>(date);
    map['total_sessions'] = Variable<int>(totalSessions);
    map['attended_sessions'] = Variable<int>(attendedSessions);
    return map;
  }

  AttendanceEntriesCompanion toCompanion(bool nullToAbsent) {
    return AttendanceEntriesCompanion(
      id: Value(id),
      subjectId: Value(subjectId),
      date: Value(date),
      totalSessions: Value(totalSessions),
      attendedSessions: Value(attendedSessions),
    );
  }

  factory AttendanceEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AttendanceEntry(
      id: serializer.fromJson<int>(json['id']),
      subjectId: serializer.fromJson<int>(json['subjectId']),
      date: serializer.fromJson<DateTime>(json['date']),
      totalSessions: serializer.fromJson<int>(json['totalSessions']),
      attendedSessions: serializer.fromJson<int>(json['attendedSessions']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'subjectId': serializer.toJson<int>(subjectId),
      'date': serializer.toJson<DateTime>(date),
      'totalSessions': serializer.toJson<int>(totalSessions),
      'attendedSessions': serializer.toJson<int>(attendedSessions),
    };
  }

  AttendanceEntry copyWith({
    int? id,
    int? subjectId,
    DateTime? date,
    int? totalSessions,
    int? attendedSessions,
  }) => AttendanceEntry(
    id: id ?? this.id,
    subjectId: subjectId ?? this.subjectId,
    date: date ?? this.date,
    totalSessions: totalSessions ?? this.totalSessions,
    attendedSessions: attendedSessions ?? this.attendedSessions,
  );
  AttendanceEntry copyWithCompanion(AttendanceEntriesCompanion data) {
    return AttendanceEntry(
      id: data.id.present ? data.id.value : this.id,
      subjectId: data.subjectId.present ? data.subjectId.value : this.subjectId,
      date: data.date.present ? data.date.value : this.date,
      totalSessions: data.totalSessions.present
          ? data.totalSessions.value
          : this.totalSessions,
      attendedSessions: data.attendedSessions.present
          ? data.attendedSessions.value
          : this.attendedSessions,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AttendanceEntry(')
          ..write('id: $id, ')
          ..write('subjectId: $subjectId, ')
          ..write('date: $date, ')
          ..write('totalSessions: $totalSessions, ')
          ..write('attendedSessions: $attendedSessions')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, subjectId, date, totalSessions, attendedSessions);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AttendanceEntry &&
          other.id == this.id &&
          other.subjectId == this.subjectId &&
          other.date == this.date &&
          other.totalSessions == this.totalSessions &&
          other.attendedSessions == this.attendedSessions);
}

class AttendanceEntriesCompanion extends UpdateCompanion<AttendanceEntry> {
  final Value<int> id;
  final Value<int> subjectId;
  final Value<DateTime> date;
  final Value<int> totalSessions;
  final Value<int> attendedSessions;
  const AttendanceEntriesCompanion({
    this.id = const Value.absent(),
    this.subjectId = const Value.absent(),
    this.date = const Value.absent(),
    this.totalSessions = const Value.absent(),
    this.attendedSessions = const Value.absent(),
  });
  AttendanceEntriesCompanion.insert({
    this.id = const Value.absent(),
    required int subjectId,
    required DateTime date,
    this.totalSessions = const Value.absent(),
    this.attendedSessions = const Value.absent(),
  }) : subjectId = Value(subjectId),
       date = Value(date);
  static Insertable<AttendanceEntry> custom({
    Expression<int>? id,
    Expression<int>? subjectId,
    Expression<DateTime>? date,
    Expression<int>? totalSessions,
    Expression<int>? attendedSessions,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (subjectId != null) 'subject_id': subjectId,
      if (date != null) 'date': date,
      if (totalSessions != null) 'total_sessions': totalSessions,
      if (attendedSessions != null) 'attended_sessions': attendedSessions,
    });
  }

  AttendanceEntriesCompanion copyWith({
    Value<int>? id,
    Value<int>? subjectId,
    Value<DateTime>? date,
    Value<int>? totalSessions,
    Value<int>? attendedSessions,
  }) {
    return AttendanceEntriesCompanion(
      id: id ?? this.id,
      subjectId: subjectId ?? this.subjectId,
      date: date ?? this.date,
      totalSessions: totalSessions ?? this.totalSessions,
      attendedSessions: attendedSessions ?? this.attendedSessions,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (subjectId.present) {
      map['subject_id'] = Variable<int>(subjectId.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (totalSessions.present) {
      map['total_sessions'] = Variable<int>(totalSessions.value);
    }
    if (attendedSessions.present) {
      map['attended_sessions'] = Variable<int>(attendedSessions.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AttendanceEntriesCompanion(')
          ..write('id: $id, ')
          ..write('subjectId: $subjectId, ')
          ..write('date: $date, ')
          ..write('totalSessions: $totalSessions, ')
          ..write('attendedSessions: $attendedSessions')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $SubjectsTable subjects = $SubjectsTable(this);
  late final $AttendanceEntriesTable attendanceEntries =
      $AttendanceEntriesTable(this);
  late final SubjectDao subjectDao = SubjectDao(this as AppDatabase);
  late final AttendanceDao attendanceDao = AttendanceDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    subjects,
    attendanceEntries,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'subjects',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('attendance_entries', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$SubjectsTableCreateCompanionBuilder =
    SubjectsCompanion Function({
      Value<int> id,
      required String name,
      Value<int> targetPercentage,
    });
typedef $$SubjectsTableUpdateCompanionBuilder =
    SubjectsCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<int> targetPercentage,
    });

final class $$SubjectsTableReferences
    extends BaseReferences<_$AppDatabase, $SubjectsTable, Subject> {
  $$SubjectsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$AttendanceEntriesTable, List<AttendanceEntry>>
  _attendanceEntriesRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.attendanceEntries,
        aliasName: $_aliasNameGenerator(
          db.subjects.id,
          db.attendanceEntries.subjectId,
        ),
      );

  $$AttendanceEntriesTableProcessedTableManager get attendanceEntriesRefs {
    final manager = $$AttendanceEntriesTableTableManager(
      $_db,
      $_db.attendanceEntries,
    ).filter((f) => f.subjectId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _attendanceEntriesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$SubjectsTableFilterComposer
    extends Composer<_$AppDatabase, $SubjectsTable> {
  $$SubjectsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get targetPercentage => $composableBuilder(
    column: $table.targetPercentage,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> attendanceEntriesRefs(
    Expression<bool> Function($$AttendanceEntriesTableFilterComposer f) f,
  ) {
    final $$AttendanceEntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.attendanceEntries,
      getReferencedColumn: (t) => t.subjectId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AttendanceEntriesTableFilterComposer(
            $db: $db,
            $table: $db.attendanceEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SubjectsTableOrderingComposer
    extends Composer<_$AppDatabase, $SubjectsTable> {
  $$SubjectsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get targetPercentage => $composableBuilder(
    column: $table.targetPercentage,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SubjectsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SubjectsTable> {
  $$SubjectsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get targetPercentage => $composableBuilder(
    column: $table.targetPercentage,
    builder: (column) => column,
  );

  Expression<T> attendanceEntriesRefs<T extends Object>(
    Expression<T> Function($$AttendanceEntriesTableAnnotationComposer a) f,
  ) {
    final $$AttendanceEntriesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.attendanceEntries,
          getReferencedColumn: (t) => t.subjectId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$AttendanceEntriesTableAnnotationComposer(
                $db: $db,
                $table: $db.attendanceEntries,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$SubjectsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SubjectsTable,
          Subject,
          $$SubjectsTableFilterComposer,
          $$SubjectsTableOrderingComposer,
          $$SubjectsTableAnnotationComposer,
          $$SubjectsTableCreateCompanionBuilder,
          $$SubjectsTableUpdateCompanionBuilder,
          (Subject, $$SubjectsTableReferences),
          Subject,
          PrefetchHooks Function({bool attendanceEntriesRefs})
        > {
  $$SubjectsTableTableManager(_$AppDatabase db, $SubjectsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SubjectsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SubjectsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SubjectsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> targetPercentage = const Value.absent(),
              }) => SubjectsCompanion(
                id: id,
                name: name,
                targetPercentage: targetPercentage,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<int> targetPercentage = const Value.absent(),
              }) => SubjectsCompanion.insert(
                id: id,
                name: name,
                targetPercentage: targetPercentage,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$SubjectsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({attendanceEntriesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (attendanceEntriesRefs) db.attendanceEntries,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (attendanceEntriesRefs)
                    await $_getPrefetchedData<
                      Subject,
                      $SubjectsTable,
                      AttendanceEntry
                    >(
                      currentTable: table,
                      referencedTable: $$SubjectsTableReferences
                          ._attendanceEntriesRefsTable(db),
                      managerFromTypedResult: (p0) => $$SubjectsTableReferences(
                        db,
                        table,
                        p0,
                      ).attendanceEntriesRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.subjectId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$SubjectsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SubjectsTable,
      Subject,
      $$SubjectsTableFilterComposer,
      $$SubjectsTableOrderingComposer,
      $$SubjectsTableAnnotationComposer,
      $$SubjectsTableCreateCompanionBuilder,
      $$SubjectsTableUpdateCompanionBuilder,
      (Subject, $$SubjectsTableReferences),
      Subject,
      PrefetchHooks Function({bool attendanceEntriesRefs})
    >;
typedef $$AttendanceEntriesTableCreateCompanionBuilder =
    AttendanceEntriesCompanion Function({
      Value<int> id,
      required int subjectId,
      required DateTime date,
      Value<int> totalSessions,
      Value<int> attendedSessions,
    });
typedef $$AttendanceEntriesTableUpdateCompanionBuilder =
    AttendanceEntriesCompanion Function({
      Value<int> id,
      Value<int> subjectId,
      Value<DateTime> date,
      Value<int> totalSessions,
      Value<int> attendedSessions,
    });

final class $$AttendanceEntriesTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $AttendanceEntriesTable,
          AttendanceEntry
        > {
  $$AttendanceEntriesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $SubjectsTable _subjectIdTable(_$AppDatabase db) =>
      db.subjects.createAlias(
        $_aliasNameGenerator(db.attendanceEntries.subjectId, db.subjects.id),
      );

  $$SubjectsTableProcessedTableManager get subjectId {
    final $_column = $_itemColumn<int>('subject_id')!;

    final manager = $$SubjectsTableTableManager(
      $_db,
      $_db.subjects,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_subjectIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$AttendanceEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $AttendanceEntriesTable> {
  $$AttendanceEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalSessions => $composableBuilder(
    column: $table.totalSessions,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get attendedSessions => $composableBuilder(
    column: $table.attendedSessions,
    builder: (column) => ColumnFilters(column),
  );

  $$SubjectsTableFilterComposer get subjectId {
    final $$SubjectsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.subjectId,
      referencedTable: $db.subjects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SubjectsTableFilterComposer(
            $db: $db,
            $table: $db.subjects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AttendanceEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $AttendanceEntriesTable> {
  $$AttendanceEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalSessions => $composableBuilder(
    column: $table.totalSessions,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get attendedSessions => $composableBuilder(
    column: $table.attendedSessions,
    builder: (column) => ColumnOrderings(column),
  );

  $$SubjectsTableOrderingComposer get subjectId {
    final $$SubjectsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.subjectId,
      referencedTable: $db.subjects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SubjectsTableOrderingComposer(
            $db: $db,
            $table: $db.subjects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AttendanceEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $AttendanceEntriesTable> {
  $$AttendanceEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<int> get totalSessions => $composableBuilder(
    column: $table.totalSessions,
    builder: (column) => column,
  );

  GeneratedColumn<int> get attendedSessions => $composableBuilder(
    column: $table.attendedSessions,
    builder: (column) => column,
  );

  $$SubjectsTableAnnotationComposer get subjectId {
    final $$SubjectsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.subjectId,
      referencedTable: $db.subjects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SubjectsTableAnnotationComposer(
            $db: $db,
            $table: $db.subjects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AttendanceEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AttendanceEntriesTable,
          AttendanceEntry,
          $$AttendanceEntriesTableFilterComposer,
          $$AttendanceEntriesTableOrderingComposer,
          $$AttendanceEntriesTableAnnotationComposer,
          $$AttendanceEntriesTableCreateCompanionBuilder,
          $$AttendanceEntriesTableUpdateCompanionBuilder,
          (AttendanceEntry, $$AttendanceEntriesTableReferences),
          AttendanceEntry,
          PrefetchHooks Function({bool subjectId})
        > {
  $$AttendanceEntriesTableTableManager(
    _$AppDatabase db,
    $AttendanceEntriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AttendanceEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AttendanceEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AttendanceEntriesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> subjectId = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<int> totalSessions = const Value.absent(),
                Value<int> attendedSessions = const Value.absent(),
              }) => AttendanceEntriesCompanion(
                id: id,
                subjectId: subjectId,
                date: date,
                totalSessions: totalSessions,
                attendedSessions: attendedSessions,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int subjectId,
                required DateTime date,
                Value<int> totalSessions = const Value.absent(),
                Value<int> attendedSessions = const Value.absent(),
              }) => AttendanceEntriesCompanion.insert(
                id: id,
                subjectId: subjectId,
                date: date,
                totalSessions: totalSessions,
                attendedSessions: attendedSessions,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$AttendanceEntriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({subjectId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (subjectId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.subjectId,
                                referencedTable:
                                    $$AttendanceEntriesTableReferences
                                        ._subjectIdTable(db),
                                referencedColumn:
                                    $$AttendanceEntriesTableReferences
                                        ._subjectIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$AttendanceEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AttendanceEntriesTable,
      AttendanceEntry,
      $$AttendanceEntriesTableFilterComposer,
      $$AttendanceEntriesTableOrderingComposer,
      $$AttendanceEntriesTableAnnotationComposer,
      $$AttendanceEntriesTableCreateCompanionBuilder,
      $$AttendanceEntriesTableUpdateCompanionBuilder,
      (AttendanceEntry, $$AttendanceEntriesTableReferences),
      AttendanceEntry,
      PrefetchHooks Function({bool subjectId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$SubjectsTableTableManager get subjects =>
      $$SubjectsTableTableManager(_db, _db.subjects);
  $$AttendanceEntriesTableTableManager get attendanceEntries =>
      $$AttendanceEntriesTableTableManager(_db, _db.attendanceEntries);
}
