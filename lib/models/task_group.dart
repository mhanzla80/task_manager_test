import 'package:json_annotation/json_annotation.dart';
import 'package:task_manager_test/helpers/task_timer.dart';
import 'package:task_manager_test/kanban_board/kanban_board.dart';
import 'package:task_manager_test/kanban_board/src/widgets/reorder_flex/reorder_flex.dart';

part 'task_group.g.dart';

@JsonSerializable()
class TaskGroup {
  final String id;
  final String name;
  final List<Task> taskItems;

  const TaskGroup({
    required this.id,
    required this.name,
    required this.taskItems,
  });

  factory TaskGroup.fromJson(Map<String, dynamic> json) =>
      _$TaskGroupFromJson(json);

  Map<String, dynamic> toJson() => _$TaskGroupToJson(this);
}

@JsonSerializable()
class Task extends KanbanGroupItem {
  final String title;
  final String subtitle;
  final TaskTimer timer;

  @override
  String get id => title;

  Task({required this.title, this.subtitle = ''}) : timer = TaskTimer(title);

  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);

  Map<String, dynamic> toJson() => _$TaskToJson(this);
}
