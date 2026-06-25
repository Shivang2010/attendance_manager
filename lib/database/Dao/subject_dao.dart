import 'package:drift/drift.dart';

import '../app_db.dart';
import '../tables.dart';

part 'subject_dao.g.dart';

@DriftAccessor(tables: [Subjects])
class SubjectDao extends DatabaseAccessor<AppDatabase> with _$SubjectDaoMixin {

  final  AppDatabase db ;
  SubjectDao(this.db):super(db);


  // insert a new subject
  Future<int> insertSubject(String name ){
    return into(subjects).insert(
      SubjectsCompanion(
        name:Value(name)
      )
    );
  }

  // get all subjects
  Future<List<Subject>> getAllSubjects(){
    return select(subjects).get();
  }

  // Watch all subjects (auto-update UI when DB changes)
  Stream<List<Subject>> watchAllSubjects() {
    return select(subjects).watch();
  }

  // Delete a subject by ID
  Future<int> deleteSubject(int id) {
    return (delete(subjects)..where((t) => t.id.equals(id))).go();
  }

  // Update a subject's name
  Future<bool> updateSubject(int id, String newName) {
    return (update(subjects)..where((t) => t.id.equals(id)))
        .write(SubjectsCompanion(name: Value(newName)))
        .then((rows) => rows > 0);
  }

  // Update a subject's target percentage
  Future<bool> updateTargetPercentage(int id, int target) {
    return (update(subjects)..where((t) => t.id.equals(id)))
        .write(SubjectsCompanion(targetPercentage: Value(target)))
        .then((rows) => rows > 0);
  }

}
