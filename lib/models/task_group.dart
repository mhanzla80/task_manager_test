import 'package:json_annotation/json_annotation.dart';
import 'package:task_manager_test/helpers/task_timer.dart';
import 'package:task_manager_test/kanban_board/kanban_board.dart';
import 'package:task_manager_test/kanban_board/src/widgets/reorder_flex/reorder_flex.dart';

part 'task_group.g.dart';

@JsonSerializable()
class TaskGroup {
  final String id;
  final String name;
  final List<KanbanGroupItem> taskItems;
  final KanbanGroupHeaderData headerData;

  TaskGroup({
    required this.id,
    required this.name,
    this.taskItems = const <KanbanGroupItem>[],
  }) : headerData = KanbanGroupHeaderData(
          groupId: id,
          groupName: name,
        );

  static List<TaskGroup> fromJsonList(List<dynamic> jsonList) =>
      jsonList.map((e) => TaskGroup.fromJson(e)).toList();

  factory TaskGroup.fromJson(Map<String, dynamic> json) =>
      _$TaskGroupFromJson(json);

  Map<String, dynamic> toJson() => _$TaskGroupToJson(this);

  static final tempTaskGroups = [
    TaskGroup(
      id: 'To Do',
      name: 'To Do',
      taskItems: [
        Task(title: "Card 1"),
        Task(title: "Card 2"),
        Task(title: "Card 3", subtitle: 'Aug 1, 2020 4:05 PM'),
        Task(title: "Card 4"),
        Task(title: "Card 5"),
      ],
    ),
    TaskGroup(
      id: 'In Progress',
      name: 'In Progress',
      taskItems: [
        Task(title: "Card 6"),
        Task(title: "Card 7", subtitle: 'Aug 1, 2020 4:05 PM'),
        Task(title: "Card 8", subtitle: 'Aug 1, 2020 4:05 PM'),
      ],
    ),
    TaskGroup(
      id: 'Pending',
      name: 'Pending',
      taskItems: [
        Task(title: "Card 9"),
        Task(title: "Card 10", subtitle: 'Aug 1, 2020 4:05 PM'),
        Task(title: "Card 11"),
        Task(title: "Card 12"),
      ],
    ),
  ];
}

@JsonSerializable()
class Task extends KanbanGroupItem {
  String title;
  String subtitle;
  List<String> comments;
  final TaskTimer timer;

  @override
  String get id => title;

  Task({
    required this.title,
    this.subtitle = '',
    this.comments = const <String>[],
  }) : timer = TaskTimer(title);

  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);

  Map<String, dynamic> toJson() => _$TaskToJson(this);
}
