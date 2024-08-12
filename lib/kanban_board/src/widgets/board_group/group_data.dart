import 'dart:collection';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:task_manager_test/kanban_board/src/utils/log.dart';
import 'package:task_manager_test/kanban_board/src/widgets/reorder_flex/reorder_flex.dart';

typedef IsDraggable = bool;

/// A item represents the generic data model of each group card.
///
/// Each item displayed in the group required to implement this class.
abstract class KanbanGroupItem extends ReoderFlexItem {
  bool get isPhantom => false;

  @override
  String toString() => id;
}

/// [KanbanGroupController] is used to handle the [KanbanGroupData].
///
/// * Remove an item by calling [removeAt] method.
/// * Move item to another position by calling [move] method.
/// * Insert item to index by calling [insert] method
/// * Replace item at index by calling [replace] method.
///
/// All there operations will notify listeners by default.
///
class KanbanGroupController extends ChangeNotifier with EquatableMixin {
  KanbanGroupController({required this.groupData});

  final KanbanGroupData groupData;

  @override
  List<Object?> get props => groupData.props;

  /// Returns the readonly List<KanbanGroupItem>
  UnmodifiableListView<KanbanGroupItem> get items =>
      UnmodifiableListView(groupData.items);

  void updateGroupName(String newName) {
    if (groupData.headerData.groupName != newName) {
      groupData.headerData.groupName = newName;
      _notify();
    }
  }

  /// Remove the item at [index].
  /// * [index] the index of the item you want to remove
  /// * [notify] the default value of [notify] is true, it will notify the
  /// listener. Set to false if you do not want to notify the listeners.
  ///
  KanbanGroupItem? removeAt(int index, {bool notify = true}) {
    if (groupData._items.length <= index) {
      Log.error(
        'Fatal error, index is out of bounds. Index: $index,  len: ${groupData._items.length}',
      );
      return null;
    }

    if (index < 0) {
      Log.error('Invalid index:$index');
      return null;
    }

    Log.debug('[$KanbanGroupController] $groupData remove item at $index');
    final item = groupData._items.removeAt(index);
    if (notify) {
      _notify();
    }
    return item;
  }

  void removeWhere(bool Function(KanbanGroupItem) condition) {
    final index = items.indexWhere(condition);
    if (index != -1) {
      removeAt(index);
    }
  }

  /// Move the item from [fromIndex] to [toIndex]. It will do nothing if the
  /// [fromIndex] equal to the [toIndex].
  bool move(int fromIndex, int toIndex) {
    assert(toIndex >= 0);
    if (groupData._items.length < fromIndex) {
      Log.error(
        'Out of bounds error. index: $fromIndex should not greater than ${groupData._items.length}',
      );
      return false;
    }

    if (fromIndex == toIndex) {
      return false;
    }

    Log.debug(
      '[$KanbanGroupController] $groupData move item from $fromIndex to $toIndex',
    );
    final item = groupData._items.removeAt(fromIndex);
    groupData._items.insert(toIndex, item);
    _notify();
    return true;
  }

  /// Insert an item to [index] and notify the listen if the value of [notify]
  /// is true.
  ///
  /// The default value of [notify] is true.
  bool insert(int index, KanbanGroupItem item, {bool notify = true}) {
    assert(index >= 0);
    Log.debug('[$KanbanGroupController] $groupData insert $item at $index');

    if (_containsItem(item)) {
      return false;
    } else {
      if (groupData._items.length > index) {
        groupData._items.insert(index, item);
      } else {
        groupData._items.add(item);
      }

      if (notify) _notify();
      return true;
    }
  }

  bool add(KanbanGroupItem item, {bool notify = true}) {
    if (_containsItem(item)) {
      return false;
    } else {
      groupData._items.add(item);
      if (notify) _notify();
      return true;
    }
  }

  /// Replace the item at index with the [newItem].
  void replace(int index, KanbanGroupItem newItem) {
    if (groupData._items.isEmpty) {
      groupData._items.add(newItem);
      Log.debug('[$KanbanGroupController] $groupData add $newItem');
    } else {
      if (index >= groupData._items.length) {
        Log.error(
          '[$KanbanGroupController] unexpected items length, index should less than the count of the items. Index: $index, items count: ${items.length}',
        );
        return;
      }

      final removedItem = groupData._items.removeAt(index);
      groupData._items.insert(index, newItem);
      Log.debug(
        '[$KanbanGroupController] $groupData replace $removedItem with $newItem at $index',
      );
    }

    _notify();
  }

  void replaceOrInsertItem(KanbanGroupItem newItem) {
    final index = groupData._items.indexWhere((item) => item.id == newItem.id);
    if (index != -1) {
      groupData._items.removeAt(index);
      groupData._items.insert(index, newItem);
      _notify();
    } else {
      groupData._items.add(newItem);
      _notify();
    }
  }

  bool _containsItem(KanbanGroupItem item) {
    return groupData._items.indexWhere((element) => element.id == item.id) !=
        -1;
  }

  void enableDragging(bool isEnable) {
    groupData.draggable.value = isEnable;

    for (final item in groupData._items) {
      item.draggable.value = isEnable;
    }
  }

  void _notify() {
    notifyListeners();
  }
}

/// [KanbanGroupData] represents the data of each group of the Board.
class KanbanGroupData<CustomData> extends ReoderFlexItem with EquatableMixin {
  KanbanGroupData({
    required this.id,
    required String name,
    this.customData,
    List<KanbanGroupItem> items = const [],
  })  : _items = items,
        headerData = KanbanGroupHeaderData(
          groupId: id,
          groupName: name,
        );

  @override
  final String id;
  KanbanGroupHeaderData headerData;
  final CustomData? customData;

  final List<KanbanGroupItem> _items;

  /// Returns the readonly List<KanbanGroupItem>
  UnmodifiableListView<KanbanGroupItem> get items =>
      UnmodifiableListView([..._items]);

  @override
  List<Object?> get props => [id, ..._items];

  @override
  String toString() => 'Group:[$id]';
}

class KanbanGroupHeaderData {
  KanbanGroupHeaderData({
    required this.groupId,
    required this.groupName,
  });

  String groupId;
  String groupName;
}
