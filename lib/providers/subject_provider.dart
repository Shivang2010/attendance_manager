import 'dart:async';
import 'package:flutter/foundation.dart';

import '../database/Dao/subject_dao.dart';
import '../database/app_db.dart';



class SubjectProvider extends ChangeNotifier {
  final SubjectDao _dao;

  // Local cache used by UI
  List<Subject> _subjects = [];

  List<Subject> get subjects => List.unmodifiable(_subjects);

  // loading/error states for UI
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  String? _error;

  String? get error => _error;

  // Stream subscription to react to DB changes
  StreamSubscription<List<Subject>>? _subs;

  SubjectProvider(this._dao) {
    _startWatching();
  }

  void _startWatching() {
    _isLoading = true;
    notifyListeners();

    _subs = _dao.watchAllSubjects().listen(
      (list) {
        _subjects = list;
        _isLoading = false;
        _error = null;
        notifyListeners();
      },
      onError: (e, st) {
        _error = e.toString();
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  Future<int> addSubject(String name) async {
    try {
      _isLoading = true;
      notifyListeners();

      final id = await _dao.insertSubject(name);

      // No need to manually refresh if using watchAllSubjects
      // because the Stream will emit the new list automatically.
      _isLoading = false;
      notifyListeners();
      return id;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<List<Subject>> loadOnce() async {
    _isLoading = true;
    notifyListeners();
    try {
      final list = await _dao.getAllSubjects();
      _subjects = list;
      _isLoading = false;
      _error = null;
      notifyListeners();
      return list;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> deleteSubject(int id) async {
    try {
      await _dao.deleteSubject(id);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> updateSubject(int id, String newName) async {
    try {
      await _dao.updateSubject(id, newName);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> updateTargetPercentage(int id, int target) async {
    try {
      await _dao.updateTargetPercentage(id, target);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _subs?.cancel();
    super.dispose();
  }
}
