import 'package:flutter/material.dart';
import 'package:task_manager_test/helpers/prefs.dart';
import 'package:task_manager_test/kanban_board/kanban_board.dart';

class BoardProvider with ChangeNotifier {
  final KanbanBoardScrollController boardController =
      KanbanBoardScrollController();

  static const config = KanbanBoardConfig(
    groupBackgroundColor: Colors.white,
    stretchGroupHeight: false,
  );

  final KanbanBoardController controller = KanbanBoardController(
    onMoveGroup: (fromGroupId, fromIndex, toGroupId, toIndex) {
      debugPrint('Move item from $fromIndex to $toIndex');
    },
    onMoveGroupItem: (groupId, fromIndex, toIndex) {
      debugPrint('Move $groupId:$fromIndex to $groupId:$toIndex');
    },
    onMoveGroupItemToGroup: (fromGroupId, fromIndex, toGroupId, toIndex) {
      debugPrint('Move $fromGroupId:$fromIndex to $toGroupId:$toIndex');
    },
    onAnyChange: (boardGroupData) {
      Prefs.instance.saveBoardData(boardGroupData);
      print(boardGroupData.length);
    },
  );
}
