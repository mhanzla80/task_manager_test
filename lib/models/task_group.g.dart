// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_group.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TaskGroup _$TaskGroupFromJson(Map<String, dynamic> json) => TaskGroup(
      id: json['id'] as String,
      name: json['name'] as String,
      taskItems: (json['taskItems'] as List<dynamic>)
          .map((e) => Task.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$TaskGroupToJson(TaskGroup instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'taskItems': instance.taskItems,
    };

Task _$TaskFromJson(Map<String, dynamic> json) => Task(
      title: json['title'] as String,
      subtitle: json['description'] as String,
    )..draggable = ReorderFlexItem.draggableFromJson(json['draggable'] as bool);

Map<String, dynamic> _$TaskToJson(Task instance) => <String, dynamic>{
      'draggable': ReorderFlexItem.draggableToJson(instance.draggable),
      'title': instance.title,
      'description': instance.subtitle,
    };
