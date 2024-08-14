import 'package:flutter/cupertino.dart';
import 'package:task_manager_test/kanban_board/kanban_board.dart';

class BoardProvider with ChangeNotifier {
  final KanbanBoardScrollController boardController =
      KanbanBoardScrollController();

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
  );
}
