import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager_test/kanban_board/kanban_board.dart';
import 'package:task_manager_test/models/task_group.dart';

class Prefs {
  static final Prefs _instance = Prefs._internal();
  static Prefs get instance => _instance;
  Prefs._internal();
  factory Prefs() => _instance;

  static late SharedPreferences _prefs;
  static const _keyKanbanBoard = 'KanbanBoard';

  Future<void> init() async => _prefs = await SharedPreferences.getInstance();

  void clear() => _prefs.clear();

  Future<void> saveBoardData(List<KanbanGroupData<dynamic>> list) {
    final List<TaskGroup> groups = [];
    for (final e in list) {
      final group = TaskGroup(
        id: e.id,
        name: e.name,
        taskItems: e.items,
      );
      groups.add(group);
    }
    final encodedJson = jsonEncode(groups);
    return _prefs.setString(_keyKanbanBoard, encodedJson);
  }

  List<KanbanGroupData<dynamic>> get getBoardData {
    final prefsString = _prefs.getString(_keyKanbanBoard) ?? '';
    if (prefsString.isEmpty) return [];

    final List<dynamic> decodedList = jsonDecode(prefsString);
    final taskGroups = TaskGroup.fromJsonList(decodedList).toList();

    final List<KanbanGroupData> groups = [];
    for (final e in taskGroups) {
      final group = KanbanGroupData(
        id: e.id,
        name: e.name,
        items: e.taskItems,
      );
      groups.add(group);
    }

    return groups;
  }

  int? loadElapsedTime(String taskId) {
    int? savedTime = _prefs.getInt('elapsedTime_$taskId');
    if (savedTime != null) {
      return savedTime;
    }
    return null;
  }

  Future<void> saveElapsedTime(String taskId, int elapsedTime) async {
    await _prefs.setInt('elapsedTime_$taskId', elapsedTime);
  }

  Future<void> clearElapsedTime(String taskId) async {
    await _prefs.remove('elapsedTime_$taskId');
  }
}
